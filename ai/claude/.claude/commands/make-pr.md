# Command: Make Pull Request

## Purpose
Create a pull request that relates to a specific GitHub issue and describes how recent changes solve the problem.

## Parameters
- `ISSUE_NUMBER`: The GitHub issue number (e.g., 123 for issue #123)

## Usage
Execute this command by referencing: `/make-pr ISSUE_NUMBER`

## Process
1. Use `gh api` to fetch issue details and requirements
2. Review current branch changes with `git log` and `git diff`
3. Analyze how changes address the issue requirements
4. Create PR with descriptive title and body
5. Update issue checkboxes to mark completed TODO items
6. Ensure PR links properly to the issue

## PR Requirements
- Title should clearly reference the issue being solved
- Body should explain how changes solve the issue
- No emojis in PR title or description
- No commentary on performance gains unless specifically relevant
- Use British English spelling and grammar
- Link to resolving issue using "Fixes #ISSUE_NUMBER" or "Resolves #ISSUE_NUMBER"

## PR Body Format
```markdown
## Summary
Brief description of changes made

## How this addresses #ISSUE_NUMBER
Specific explanation of how changes solve the issue requirements

## Changes Made
- Bullet point list of key changes
- Reference specific files or functions modified

## Testing
- How changes were verified
- Any test additions or modifications
```

## Follow-up Actions
1. Use `gh api` to update issue checkboxes for completed TODO items
2. Verify PR properly links to the issue
3. Ensure all related issue requirements are addressed

## Success Criteria
- PR created successfully with proper issue linkage
- PR description clearly explains how issue is resolved
- Issue checkboxes updated to reflect completed work
- No emojis used in PR content
- Follows project's conventional commit message standards
