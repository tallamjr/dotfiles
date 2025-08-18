# Command: Create GitHub Issue

## Purpose
Create a GitHub issue from a proposal document located in the .github/DRAFTS/ directory.

## Parameters
- `PROPOSAL_NAME`: Name of the proposal document in .github/DRAFTS/ (without file extension)

## Usage
Execute this command by referencing: `/make-issue PROPOSAL_NAME`

## Process
1. Locate proposal document at `.github/DRAFTS/PROPOSAL_NAME.md`
2. Read and parse the proposal document content
3. Extract key information for issue creation:
   - Title from document header or filename
   - Description from proposal content
   - Requirements or objectives listed
   - Any implementation details or considerations
4. Use `gh issue create` to file the issue
5. Ensure proper formatting and structure

## Issue Requirements
- Title should be clear and descriptive
- Body should summarise the proposal content
- No emojis in title or description
- No commentary on potential performance gains unless specifically relevant
- Use British English spelling and grammar
- Include relevant labels if proposal suggests them

## Issue Body Format
```markdown
## Proposal Summary
Brief overview of the proposal

## Requirements
- Key requirements from the proposal
- Objectives to be achieved
- Success criteria

## Implementation Notes
- Technical considerations
- Dependencies or constraints
- Acceptance criteria

## References
Link to original proposal document in .github/DRAFTS/
```

## Validation Steps
1. Verify proposal document exists in .github/DRAFTS/
2. Ensure document content is properly parsed
3. Confirm issue creation was successful
4. Verify issue links back to proposal document

## Error Handling
- If proposal document not found, provide clear error message
- If document is empty or malformed, request clarification
- If `gh` command fails, check authentication and repository access

## Success Criteria
- GitHub issue created successfully
- Issue content accurately reflects proposal
- No emojis used in issue content
- Proper British English used throughout
- Issue properly linked to original proposal document
