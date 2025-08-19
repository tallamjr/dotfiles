# Command: Audit Notebooks

## Purpose
Conduct comprehensive audit of example code and educational notebooks to identify and eliminate misleading, fake, or non-functional implementations.

## Parameters
None required - operates on examples and notebooks directories

## Role
You are a senior developer advocate and documentation engineer conducting a comprehensive audit of educational materials.

## Objectives
1. Identify examples with misleading claims that don't match their actual implementation
2. Find placeholder, dummy, or fake code that doesn't demonstrate real functionality
3. Eliminate examples that use mock/dummy data when real data should be used
4. Ensure all examples and notebooks execute successfully and demonstrate actual capabilities
5. Verify all code examples provide educational value and realistic use cases

## Specific Issues to Identify

### Misleading Examples
- Example titles/descriptions that claim to demonstrate X but actually show Y
- Code comments that describe functionality that doesn't exist
- Examples that claim to solve problems but use hardcoded solutions
- Notebooks with misleading cell descriptions that don't match the code
- Examples that promise specific outcomes but deliver generic results

### Fake Implementations
- Functions that return hardcoded values instead of real computations
- Examples that skip complex logic and use placeholder values
- Notebooks with cells that don't actually execute the described operations
- Mock data generators that don't reflect realistic scenarios
- Examples that simulate functionality rather than implementing it

### Dummy Data Usage
- Examples using synthetic data when real datasets are available from data directory
- Hardcoded example inputs that don't represent realistic use cases
- Mock API responses that don't reflect actual service behaviour
- Simplified datasets that don't demonstrate real-world complexity
- Examples that avoid real data processing challenges

## Process
1. Systematically examine each file in examples/ and notebooks/ directories
2. Execute all notebooks and examples to verify they work as claimed
3. Test notebooks with `pytest --nbmake` to ensure execution reliability
4. Test Python examples with `pytest` where applicable
5. Identify examples that can be enhanced with real data from data directory
6. Document each problematic example with specific issues
7. Remove or completely rewrite non-functional examples
8. Verify remaining examples provide genuine educational value

## Output Format
For each problematic example found, provide:
- File path and example/notebook name
- Specific problem description
- Current vs. claimed functionality gap
- Recommendation (remove, rewrite, or enhance with real data)
- If rewriting: proposed real-data alternative approach using data directory
- Testing strategy to verify functionality

## Testing Requirements
After audit completion, verify:
1. Run `pytest --nbmake` on all notebooks - all must pass
2. Run `pytest` on example Python files - all must pass
3. Manually execute complex examples to verify claimed functionality
4. Ensure examples work with real data sources from data directory
5. Verify examples demonstrate actual project capabilities

## Success Criteria
- Zero examples using dummy/mock data when real data is available
- All example titles and descriptions accurately reflect implementation
- All notebooks execute successfully with `pytest --nbmake`
- All Python examples pass `pytest` validation where applicable
- Examples demonstrate realistic use cases with real data from data directory
- No placeholder or TODO code remains in examples
- All examples provide genuine educational value
- No emojis used in any notebook content

## Follow-up Actions
After audit completion:
1. Remove all identified fake/useless examples
2. Replace dummy data examples with real data equivalents from data directory
3. Ensure all remaining examples execute successfully
4. Verify examples provide practical learning value
5. Format code using appropriate tools (Black for Python, rustfmt for Rust)
6. Confirm test suite passes both `pytest` and `pytest --nbmake`
