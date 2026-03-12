---
disable-model-invocation: true
description: Systematically review and remove all emojis from the codebase
---

# Command: Clean Emojis

## Purpose
Systematically review and remove all emojis from the codebase to maintain professional code standards.

## Parameters
None required - operates on entire codebase

## Scope
Remove emojis from all text-based files including:
- Source code files (.py, .rs, .js, .ts, etc.)
- Documentation files (.md, .txt, .rst)
- Configuration files (.yaml, .json, .toml)
- Comment blocks and docstrings
- Variable names and function names
- Git commit messages (if accessible)
- README and other project documentation

## Process
1. Use Grep tool to search for common emoji patterns across codebase
2. Search for Unicode emoji ranges (U+1F600-U+1F64F, U+1F300-U+1F5FF, U+1F680-U+1F6FF, etc.)
3. Check for emoji shortcodes (:smile:, :rocket:, etc.)
4. Review found instances and determine appropriate replacements
5. Remove or replace emojis with descriptive text where context is needed
6. Verify changes don't break functionality

## Search Patterns
- Unicode emoji characters
- Emoji shortcodes (`:emoji_name:`)
- Common emoji symbols
- Emoticons that may render as emojis (:), :D, etc.)

## Replacement Guidelines
- Remove decorative emojis entirely
- Replace functional emojis with descriptive text
- Maintain meaning where emojis convey important information
- Use conventional text markers (TODO, FIXME, NOTE) instead of emoji indicators

## Files to Exclude
- Binary files
- Image files
- Third-party dependencies
- Build artifacts

## Verification
After cleaning:
1. Search again to confirm all emojis removed
2. Run tests to ensure functionality unchanged
3. Check that documentation remains clear and readable
4. Verify no broken references or formatting

## Success Criteria
- Zero emojis remain in codebase
- All functionality preserved
- Documentation clarity maintained
- No broken formatting or references
- Changes follow project coding standards

## Completion Report
Provide summary including:
- Total files scanned
- Number of emojis removed
- Types of emojis found
- Any replacements made with descriptive text
