---
disable-model-invocation: true
context: fork
description: Conduct a comprehensive test suite audit to identify and eliminate ineffective or fake tests
---

# Command: Audit Tests

## Purpose
Conduct a comprehensive test suite audit to identify and eliminate ineffective, misleading, or fake tests that don't provide real validation.

## Parameters
None required - operates on entire test suite

## Role
You are a senior QA engineer and test architect conducting a comprehensive test suite audit.

## Objectives
1. Identify tests with misleading names that don't match their actual validation
2. Find placeholder, dummy, or fake test implementations that don't provide real coverage
3. Eliminate tests that use mock/dummy data when real data should be used
4. Ensure all tests provide meaningful validation of actual functionality
5. Remove or fix tests that always pass regardless of implementation correctness

## Specific Issues to Identify

### Misleading Tests
- Test names that claim to test X but actually test Y or nothing
- Tests that assert trivial conditions (e.g., assert True)
- Tests with misleading descriptions that don't match implementation
- Integration tests that only test mocked components

### Fake Implementations
- Tests that use hardcoded expected values without real logic validation
- Mock objects that return static data instead of realistic responses
- Tests that skip actual functionality and only test test setup
- Placeholder tests with TODO comments that don't actually test anything
- Tests that only validate mock calls rather than real behavior

### Dummy Data Usage
- Tests using fake data when real data is available and should be used
- Hardcoded test inputs that don't represent realistic scenarios
- Mock responses that don't reflect actual API/service behavior
- Test databases with unrealistic or minimal data sets

## Process
1. Systematically examine each test file and test case
2. Run the test suite (pytest for Python, cargo test for Rust) to identify tests that always pass
3. Analyze test coverage to find gaps in real functionality testing
4. Identify tests that can be replaced with real data scenarios from data directory
5. Document each problematic test with specific issues
6. Remove or completely rewrite ineffective tests
7. Verify remaining tests provide meaningful validation

## Output Format
For each problematic test found, provide:
- Test file path and test name
- Specific problem description
- Recommendation (remove, rewrite, or fix)
- If rewriting: proposed real-data alternative using data from data directory
- Expected impact on test coverage and quality

## Success Criteria
- Zero tests using dummy/mock data when real data is available
- All test names accurately describe what is being validated
- No tests that always pass regardless of implementation
- All remaining tests provide meaningful validation of real functionality
- Test suite uses real data sources from data directory where appropriate
- No placeholder or TODO tests remain in the suite
- Test coverage exceeds 80% for all real implementations

## Testing Requirements
After audit completion:
1. Run `pytest` for Python tests - all must pass
2. Run `pytest --nbmake` for notebook tests - all must pass
3. Run `cargo test` for Rust tests - all must pass
4. Verify test coverage meets 80% threshold
5. Ensure tests can fail when implementation is broken

## Follow-up Actions
After audit completion:
1. Remove all identified fake/useless tests
2. Replace dummy data tests with real data equivalents
3. Ensure remaining test suite maintains adequate coverage
4. Format test code using appropriate tools (Black for Python, rustfmt for Rust)
