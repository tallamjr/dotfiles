#!/bin/bash
# block-dangerous-bash.sh
# PreToolUse hook: denies high-risk destructive Bash commands ANYWHERE in the
# command string, including when nested in compound commands (cd x && rm -rf y),
# command substitutions $(...), pipes, or after ; && ||. Prefix-based permission
# deny rules (e.g. "Bash(rm -rf:*)") only match commands that START with the
# pattern, so nested occurrences slip through. This hook closes that gap by
# scanning the whole command.
#
# rm with recursive+force is allowed only when it targets the temp/scratchpad
# space (/tmp or /private/tmp); everywhere else it is denied. Override a genuine
# need by running the command yourself or temporarily disabling this hook.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

# Collapse newlines/tabs so multi-line commands match as one string.
NORM=$(printf '%s' "$COMMAND" | tr '\n\t' '  ')

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("Blocked by safety hook: " + $reason + " Run it yourself if this is intended.")
    }
  }'
  exit 0
}

# --- Catastrophic patterns: always deny ----------------------------------
# Fork bomb :(){ :|:& };:
printf '%s' "$NORM" | grep -qE ':[[:space:]]*\([[:space:]]*\)[[:space:]]*\{[[:space:]]*:[[:space:]]*\|[[:space:]]*:[[:space:]]*&' \
  && deny "fork bomb pattern detected."
# Filesystem format
printf '%s' "$NORM" | grep -qE '(^|[;&|`(]|&&|\|\|)[[:space:]]*(sudo[[:space:]]+)?mkfs([._[:space:]])' \
  && deny "mkfs (filesystem format) detected."
# dd writing to a raw device
printf '%s' "$NORM" | grep -qE '\bdd\b[^;&|]*[[:space:]]of=/dev/' \
  && deny "dd writing to a device (of=/dev/...) detected."
# redirect into a raw disk device
printf '%s' "$NORM" | grep -qE '>[[:space:]]*/dev/(sd|nvme|disk|hd|mmcblk)' \
  && deny "redirect to a raw disk device detected."
# chmod -R 777 on the filesystem root
printf '%s' "$NORM" | grep -qE '\bchmod[[:space:]]+-[[:alpha:]]*R[[:alpha:]]*[[:space:]]+0?777[[:space:]]+/([[:space:]]|$)' \
  && deny "chmod -R 777 on / detected."

# --- Destructive git (recoverable but data-losing) -----------------------
printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+reset[[:space:]]+--hard\b' \
  && deny "git reset --hard discards working-tree changes."
printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+clean[[:space:]]+-[[:alpha:]]*f' \
  && deny "git clean -f deletes untracked files."
printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+push[[:space:]]+[^;&|]*(--force([[:space:]]|$)|--force-with-lease|[[:space:]]-f([[:space:]]|$))' \
  && deny "git force-push detected."

# --- rm with recursive + force, anywhere in the command ------------------
# Take the first rm invocation (up to the next command separator) and check it
# carries both a recursive and a force flag (short combined, short separate, or
# long form). rm -f (force only) or rm -r (recursive only) do not trigger.
RM_SEG=$(printf '%s' "$NORM" | grep -oE '\brm[[:space:]][^;&|`)]*' | head -1)
if [ -n "$RM_SEG" ]; then
  HAS_REC=0; HAS_FORCE=0
  printf '%s' "$RM_SEG" | grep -qE '(^|[[:space:]])-[[:alpha:]]*r|--recursive' && HAS_REC=1
  printf '%s' "$RM_SEG" | grep -qE '(^|[[:space:]])-[[:alpha:]]*f|--force' && HAS_FORCE=1
  if [ "$HAS_REC" = 1 ] && [ "$HAS_FORCE" = 1 ]; then
    # Allow only when it operates within the temp / scratchpad space.
    if printf '%s' "$RM_SEG" | grep -qE '(^|[[:space:]"'\''])(/private)?/tmp/'; then
      exit 0
    fi
    deny "recursive force-remove (rm -rf) outside /tmp."
  fi
fi

exit 0
