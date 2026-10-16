//! Label placement check for TikZ figures.
//!
//! Usage: label-check <words.xml> <lines.png> <review.png> <annotated.png>
//! - words.xml: `pdftotext -bbox` output of the normal PDF.
//! - lines.png: raster of the same PDF with all text made invisible.
//! - review.png: raster of the normal PDF at the same pixel width.
//! Reports words that a line crosses and words that overlap. Exit 2 on findings.

use std::fs::File;
use std::io::BufWriter;
use std::process::ExitCode;

const POINTS_PER_CM: f64 = 72.0 / 2.54;
const MIN_INK_PIXELS: usize = 6;
const OVERLAP_FRACTION: f64 = 0.3;
// A line crosses a word and covers a thin part of its box. A fill covers most of it.
const MAX_LINE_COVERAGE: f64 = 0.5;

#[derive(Debug, Clone)]
struct Word {
    text: String,
    x_min: f64,
    y_min: f64,
    x_max: f64,
    y_max: f64,
}

struct Raster {
    width: usize,
    height: usize,
    rgb: Vec<u8>,
}

#[derive(Debug, PartialEq)]
enum Finding {
    Crossing { word: usize, ink_pixels: usize },
    Overlap { first: usize, second: usize },
}

fn attribute(tag: &str, key: &str) -> Result<f64, String> {
    let pattern = format!("{key}=\"");
    let start = tag.find(&pattern).ok_or(format!("missing {key}"))? + pattern.len();
    let length = tag[start..].find('"').ok_or(format!("unterminated {key}"))?;
    tag[start..start + length]
        .parse()
        .map_err(|error| format!("bad {key}: {error}"))
}

fn decode_entities(text: &str) -> String {
    text.replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&quot;", "\"")
        .replace("&amp;", "&")
}

fn parse_words(xml: &str) -> Result<(f64, Vec<Word>), String> {
    let page_start = xml.find("<page ").ok_or("no <page> element")?;
    let page_tag = &xml[page_start..];
    let page_width = attribute(&page_tag[..page_tag.find('>').ok_or("bad <page>")?], "width")?;
    let mut words = Vec::new();
    for chunk in xml.split("<word ").skip(1) {
        let tag_end = chunk.find('>').ok_or("bad <word>")?;
        let text_end = chunk.find("</word>").ok_or("unterminated <word>")?;
        words.push(Word {
            text: decode_entities(&chunk[tag_end + 1..text_end]),
            x_min: attribute(&chunk[..tag_end], "xMin")?,
            y_min: attribute(&chunk[..tag_end], "yMin")?,
            x_max: attribute(&chunk[..tag_end], "xMax")?,
            y_max: attribute(&chunk[..tag_end], "yMax")?,
        });
    }
    Ok((page_width, words))
}

/// Shrink the box: font boxes include empty space above and below the glyphs.
fn core_box(word: &Word) -> (f64, f64, f64, f64) {
    let vertical_slack = 0.2 * (word.y_max - word.y_min);
    let horizontal_slack = 0.05 * (word.x_max - word.x_min);
    (
        word.x_min + horizontal_slack,
        word.y_min + vertical_slack,
        word.x_max - horizontal_slack,
        word.y_max - vertical_slack,
    )
}

/// Dark strokes, plus faint grey anti-aliased pixels. Light fills and glow do not count.
fn is_ink(red: u8, green: u8, blue: u8) -> bool {
    let luminance = 0.299 * f64::from(red) + 0.587 * f64::from(green) + 0.114 * f64::from(blue);
    let spread = red.max(green).max(blue) - red.min(green).min(blue);
    luminance < 128.0 || (luminance < 205.0 && spread < 70)
}

fn count_ink(raster: &Raster, scale: f64, bounds: (f64, f64, f64, f64)) -> usize {
    let x_start = (bounds.0 * scale).floor().max(0.0) as usize;
    let y_start = (bounds.1 * scale).floor().max(0.0) as usize;
    let x_end = ((bounds.2 * scale).ceil() as usize).min(raster.width);
    let y_end = ((bounds.3 * scale).ceil() as usize).min(raster.height);
    let mut count = 0;
    for y in y_start..y_end {
        for x in x_start..x_end {
            let index = 3 * (y * raster.width + x);
            if is_ink(raster.rgb[index], raster.rgb[index + 1], raster.rgb[index + 2]) {
                count += 1;
            }
        }
    }
    count
}

fn overlap_area(a: (f64, f64, f64, f64), b: (f64, f64, f64, f64)) -> f64 {
    let width = (a.2.min(b.2) - a.0.max(b.0)).max(0.0);
    let height = (a.3.min(b.3) - a.1.max(b.1)).max(0.0);
    width * height
}

fn area(bounds: (f64, f64, f64, f64)) -> f64 {
    (bounds.2 - bounds.0) * (bounds.3 - bounds.1)
}

/// Accents, brackets and primes are glyphs that sit on top of a letter by design.
/// A word with no ASCII letter or digit is such a fragment.
fn is_math_fragment(word: &Word) -> bool {
    !word.text.chars().any(|character| character.is_ascii_alphanumeric())
}

fn find_problems(words: &[Word], lines: &Raster, scale: f64) -> Vec<Finding> {
    let boxes: Vec<_> = words.iter().map(core_box).collect();
    let mut findings = Vec::new();
    for (index, bounds) in boxes.iter().enumerate() {
        let ink_pixels = count_ink(lines, scale, *bounds);
        let box_pixels = area(*bounds) * scale * scale;
        if ink_pixels >= MIN_INK_PIXELS && (ink_pixels as f64) < MAX_LINE_COVERAGE * box_pixels {
            findings.push(Finding::Crossing { word: index, ink_pixels });
        }
    }
    for first in 0..boxes.len() {
        for second in first + 1..boxes.len() {
            if is_math_fragment(&words[first]) || is_math_fragment(&words[second]) {
                continue;
            }
            let shared = overlap_area(boxes[first], boxes[second]);
            let smaller = area(boxes[first]).min(area(boxes[second]));
            if smaller > 0.0 && shared > OVERLAP_FRACTION * smaller {
                findings.push(Finding::Overlap { first, second });
            }
        }
    }
    findings
}

fn read_png(path: &str) -> Result<Raster, String> {
    let file = File::open(path).map_err(|error| format!("{path}: {error}"))?;
    let mut reader = png::Decoder::new(file)
        .read_info()
        .map_err(|error| format!("{path}: {error}"))?;
    let mut buffer = vec![0; reader.output_buffer_size()];
    let info = reader
        .next_frame(&mut buffer)
        .map_err(|error| format!("{path}: {error}"))?;
    let channels = match info.color_type {
        png::ColorType::Rgb => 3,
        png::ColorType::Rgba => 4,
        other => return Err(format!("{path}: unsupported colour type {other:?}")),
    };
    let rgb = buffer[..info.buffer_size()]
        .chunks(channels)
        .flat_map(|pixel| [pixel[0], pixel[1], pixel[2]])
        .collect();
    Ok(Raster { width: info.width as usize, height: info.height as usize, rgb })
}

fn draw_box(raster: &mut Raster, scale: f64, word: &Word, colour: [u8; 3]) {
    let x_start = ((word.x_min * scale) as usize).saturating_sub(2);
    let y_start = ((word.y_min * scale) as usize).saturating_sub(2);
    let x_end = (((word.x_max * scale) as usize) + 2).min(raster.width - 1);
    let y_end = (((word.y_max * scale) as usize) + 2).min(raster.height - 1);
    for x in x_start..=x_end {
        for y in [y_start, y_end] {
            let index = 3 * (y * raster.width + x);
            raster.rgb[index..index + 3].copy_from_slice(&colour);
        }
    }
    for y in y_start..=y_end {
        for x in [x_start, x_end] {
            let index = 3 * (y * raster.width + x);
            raster.rgb[index..index + 3].copy_from_slice(&colour);
        }
    }
}

fn write_png(path: &str, raster: &Raster) -> Result<(), String> {
    let file = File::create(path).map_err(|error| format!("{path}: {error}"))?;
    let mut encoder = png::Encoder::new(
        BufWriter::new(file),
        raster.width as u32,
        raster.height as u32,
    );
    encoder.set_color(png::ColorType::Rgb);
    encoder.set_depth(png::BitDepth::Eight);
    encoder
        .write_header()
        .and_then(|mut writer| writer.write_image_data(&raster.rgb))
        .map_err(|error| format!("{path}: {error}"))
}

fn run(arguments: &[String]) -> Result<bool, String> {
    let [words_path, lines_path, review_path, annotated_path] = arguments else {
        return Err("usage: label-check <words.xml> <lines.png> <review.png> <annotated.png>".into());
    };
    let xml = std::fs::read_to_string(words_path).map_err(|error| format!("{words_path}: {error}"))?;
    let (page_width, words) = parse_words(&xml)?;
    let lines = read_png(lines_path)?;
    let mut review = read_png(review_path)?;
    if lines.width != review.width || lines.height != review.height {
        return Err("lines.png and review.png differ in size".into());
    }
    let scale = lines.width as f64 / page_width;
    let findings = find_problems(&words, &lines, scale);
    for finding in &findings {
        match finding {
            Finding::Crossing { word, ink_pixels } => {
                let found = &words[*word];
                println!(
                    "CROSSING \"{}\" at {:.1} cm right, {:.1} cm down: a line or shape passes through the word ({} ink pixels)",
                    found.text,
                    found.x_min / POINTS_PER_CM,
                    found.y_min / POINTS_PER_CM,
                    ink_pixels
                );
                draw_box(&mut review, scale, found, [255, 0, 200]);
            }
            Finding::Overlap { first, second } => {
                println!(
                    "OVERLAP \"{}\" and \"{}\" at {:.1} cm right, {:.1} cm down",
                    words[*first].text,
                    words[*second].text,
                    words[*first].x_min / POINTS_PER_CM,
                    words[*first].y_min / POINTS_PER_CM
                );
                draw_box(&mut review, scale, &words[*first], [255, 140, 0]);
                draw_box(&mut review, scale, &words[*second], [255, 140, 0]);
            }
        }
    }
    println!("label-check: {} words, {} findings", words.len(), findings.len());
    write_png(annotated_path, &review)?;
    Ok(findings.is_empty())
}

fn main() -> ExitCode {
    let arguments: Vec<String> = std::env::args().skip(1).collect();
    match run(&arguments) {
        Ok(true) => ExitCode::SUCCESS,
        Ok(false) => ExitCode::from(2),
        Err(message) => {
            eprintln!("label-check: {message}");
            ExitCode::FAILURE
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const XML: &str = r#"<doc><page width="100.0" height="50.0">
<word xMin="10.0" yMin="10.0" xMax="30.0" yMax="20.0">x(t)</word>
<word xMin="12.0" yMin="11.0" xMax="28.0" yMax="19.0">a&amp;b</word>
</page></doc>"#;

    fn blank(width: usize, height: usize) -> Raster {
        Raster { width, height, rgb: vec![255; 3 * width * height] }
    }

    #[test]
    fn parses_page_width_words_and_entities() {
        let (page_width, words) = parse_words(XML).unwrap();
        assert_eq!(page_width, 100.0);
        assert_eq!(words.len(), 2);
        assert_eq!(words[0].text, "x(t)");
        assert_eq!(words[1].text, "a&b");
        assert_eq!(words[0].x_max, 30.0);
    }

    #[test]
    fn rejects_xml_without_page() {
        assert!(parse_words("<word>").is_err());
    }

    #[test]
    fn ink_rule_accepts_dark_and_faint_grey_but_not_light_fill() {
        assert!(is_ink(30, 40, 45));
        assert!(is_ink(252, 23, 33));
        assert!(is_ink(150, 150, 150));
        assert!(!is_ink(245, 251, 255));
        assert!(!is_ink(255, 110, 110));
        assert!(!is_ink(210, 225, 239));
    }

    #[test]
    fn vertical_line_through_word_is_a_crossing() {
        let (_, words) = parse_words(XML).unwrap();
        let mut lines = blank(100, 50);
        for y in 0..50 {
            let index = 3 * (y * 100 + 20);
            lines.rgb[index..index + 3].copy_from_slice(&[0, 0, 0]);
        }
        let findings = find_problems(&words[..1], &lines, 1.0);
        assert!(matches!(findings[0], Finding::Crossing { word: 0, .. }));
    }

    #[test]
    fn empty_raster_gives_no_crossing() {
        let (_, words) = parse_words(XML).unwrap();
        let findings = find_problems(&words[..1], &blank(100, 50), 1.0);
        assert!(findings.is_empty());
    }

    #[test]
    fn overlapping_words_are_reported() {
        let (_, words) = parse_words(XML).unwrap();
        let findings = find_problems(&words, &blank(100, 50), 1.0);
        assert_eq!(findings, vec![Finding::Overlap { first: 0, second: 1 }]);
    }

    #[test]
    fn filled_box_behind_text_is_not_a_crossing() {
        let (_, words) = parse_words(XML).unwrap();
        let mut lines = blank(100, 50);
        for y in 8..22 {
            for x in 8..32 {
                let index = 3 * (y * 100 + x);
                lines.rgb[index..index + 3].copy_from_slice(&[0, 0, 0]);
            }
        }
        assert!(find_problems(&words[..1], &lines, 1.0).is_empty());
    }

    #[test]
    fn accent_over_a_letter_is_not_an_overlap() {
        let mut words = parse_words(XML).unwrap().1;
        words[1].text = "\u{2c6}".into();
        assert!(find_problems(&words, &blank(100, 50), 1.0).is_empty());
    }

    #[test]
    fn bracket_with_accent_is_not_an_overlap() {
        let mut words = parse_words(XML).unwrap().1;
        words[1].text = "[\u{2c6}".into();
        assert!(find_problems(&words, &blank(100, 50), 1.0).is_empty());
    }

    #[test]
    fn touching_but_separate_words_are_not_overlap() {
        let mut words = parse_words(XML).unwrap().1;
        words[1].x_min = 40.0;
        words[1].x_max = 60.0;
        assert!(find_problems(&words, &blank(100, 50), 1.0).is_empty());
    }

    #[test]
    fn annotation_draws_the_box_outline() {
        let (_, words) = parse_words(XML).unwrap();
        let mut raster = blank(100, 50);
        draw_box(&mut raster, 1.0, &words[0], [255, 0, 200]);
        let index = 3 * (8 * 100 + 20);
        assert_eq!(&raster.rgb[index..index + 3], &[255, 0, 200]);
    }
}
