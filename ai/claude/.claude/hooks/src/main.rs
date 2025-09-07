use serde::{Deserialize, Serialize};
use std::io::{self, Read};
use std::time::Duration;
use tracing::{info, warn};

#[derive(Deserialize)]
struct HookInput {
    hook_event_name: Option<String>,
    tool_name: Option<String>,
    prompt: Option<String>,
}

#[derive(Serialize)]
struct HookOutput {
    #[serde(skip_serializing_if = "Option::is_none")]
    decision: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    reason: Option<String>,
    #[serde(rename = "hookSpecificOutput", skip_serializing_if = "Option::is_none")]
    hook_specific_output: Option<HookSpecificOutput>,
}

#[derive(Serialize)]
struct HookSpecificOutput {
    #[serde(rename = "hookEventName")]
    hook_event_name: String,
    #[serde(rename = "additionalContext")]
    additional_context: String,
}

async fn check_connectivity() -> (bool, bool) {
    // Check Claude API endpoint instead of general internet
    let claude_api_check = tokio::time::timeout(
        Duration::from_millis(500),
        reqwest::Client::new()
            .get("https://api.anthropic.com/v1/messages")
            .timeout(Duration::from_millis(500))
            .send(),
    );

    let lmstudio_check = tokio::time::timeout(
        Duration::from_millis(200),
        reqwest::Client::new()
            .get("http://localhost:1234/v1/models")
            .timeout(Duration::from_millis(200))
            .send(),
    );

    let (claude_api_ok, lmstudio_ok) = tokio::join!(
        async {
            match claude_api_check.await {
                Ok(Ok(_)) => true, // Any response (even error) means API is reachable
                _ => false,        // Timeout/connection error means API blocked
            }
        },
        async {
            match lmstudio_check.await {
                Ok(Ok(resp)) => resp.status().is_success(),
                _ => false,
            }
        }
    );

    (claude_api_ok, lmstudio_ok)
}

#[tokio::main]
async fn main() -> io::Result<()> {
    tracing_subscriber::fmt::init();

    let mut input = String::new();
    io::stdin().read_to_string(&mut input)?;

    let hook_input: HookInput = match serde_json::from_str(&input) {
        Ok(data) => data,
        Err(e) => {
            warn!("Failed to parse JSON input: {}", e);
            return Ok(());
        }
    };

    // Only process UserPromptSubmit events
    if hook_input.hook_event_name.as_deref() != Some("UserPromptSubmit") {
        return Ok(());
    }

    let (internet_ok, lmstudio_ok) = check_connectivity().await;

    let output = match (internet_ok, lmstudio_ok) {
        (true, _) => {
            info!("Online mode - normal operation");
            return Ok(()); // No output needed for online mode
        }
        (false, true) => {
            info!("Offline mode - LM Studio available");
            HookOutput {
                decision: None,
                reason: None,
                hook_specific_output: Some(HookSpecificOutput {
                    hook_event_name: "UserPromptSubmit".to_string(),
                    additional_context: "OFFLINE MODE: Internet unavailable. Local gpt-oss-20b model loaded in LM Studio. Claude will automatically fallback to: lms chat -p \"your prompt\" gpt-oss-20b".to_string(),
                }),
            }
        }
        (false, false) => {
            warn!("Completely offline - blocking");
            HookOutput {
                decision: Some("block".to_string()),
                reason: Some("System offline: No internet connection and LM Studio not running. Please start LM Studio or check your connection.".to_string()),
                hook_specific_output: None,
            }
        }
    };

    println!("{}", serde_json::to_string(&output)?);
    Ok(())
}
