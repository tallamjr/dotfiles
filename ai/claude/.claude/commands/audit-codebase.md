# Command: Audit Codebase

## Purpose
Conduct a comprehensive code audit to identify and eliminate misleading claims, placeholder implementations, and ensure code quality standards.

## Parameters
None required - operates on entire codebase

## Role
You are a principal software engineer conducting a comprehensive code audit using systematic analysis and subagents where appropriate.

## Objectives
1. Identify misleading claims in code comments, documentation, or function names
2. Find placeholder, dummy, or fake implementations that don't fulfill their intended purpose
3. Verify that all code functionality matches its stated purpose
4. Ensure comprehensive test coverage for all real implementations

## Specific Issues to Identify

### Misleading Claims
- Functions that claim to do X but actually do Y
- Comments that describe functionality that doesn't exist
- Variable names that don't match their actual purpose
- Documentation that contradicts implementation

### Placeholder Code
- Functions that return hardcoded values instead of real logic
- TODO comments with unimplemented functionality
- Mock data being used in production code
- Stub implementations that should be complete

## Process
1. Systematically examine each file in the codebase
2. Use Task tool for complex analysis requiring subagents
3. For each issue found, document the location and specific problem
4. Suggest concrete fixes for each identified issue
5. Verify fixes with appropriate tests (pytest for Python, cargo test for Rust)
6. Ensure test coverage exceeds 80% for new implementations

## Output Format
For each issue found, provide:
- File path and line number
- Description of the problem
- Proposed solution
- Test strategy to verify the fix

## Success Criteria
- Zero placeholder implementations remain in production code
- All function names and comments accurately describe their behavior
- All functionality is backed by comprehensive tests (pytest/cargo test)
- No misleading claims exist in documentation or code
- Code follows formatting standards (Black for Python, rustfmt for Rust)

## Follow-up Actions
After audit completion:
1. Run appropriate test suite to verify all fixes work
2. Run linting tools to ensure code quality standards
3. Document any architectural improvements needed
