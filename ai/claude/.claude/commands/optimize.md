# Command: Optimize Code

## Purpose
Analyze codebase for performance issues and suggest concrete optimizations while avoiding over-engineering.

## Parameters
None required - operates on entire codebase

## Analysis Areas

### Performance Issues
- Inefficient algorithms or data structures
- Memory leaks or excessive memory usage
- Slow database queries or API calls
- Unnecessary I/O operations
- CPU-intensive operations that could be optimized

### Code Quality Improvements
- Redundant code files and functions (DRY principle violations)
- Opportunities for zero-copy data workflows
- Dead code elimination
- Inefficient imports or dependencies

### Reference Resources
- [Google Engineering Practices](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- Language-specific performance guides

## Process
1. Systematically examine codebase for performance bottlenecks
2. Use profiling tools where applicable
3. Identify redundant code patterns
4. Look for zero-copy optimization opportunities
5. Document findings with specific file paths and line numbers
6. Suggest concrete, measurable improvements
7. Prioritize optimizations by impact vs effort

## Output Requirements
Create `OPTIMIZE.md` file containing:

### Analysis Summary
- Overview of codebase performance state
- Key bottlenecks identified
- Estimated impact of suggested optimizations

### Specific Findings
For each optimization opportunity:
- **File**: path/to/file.ext:line_number
- **Issue**: Description of performance problem
- **Solution**: Concrete optimization approach
- **Impact**: Expected performance improvement
- **Effort**: Implementation complexity (Low/Medium/High)

### Implementation Priority
1. **High Impact, Low Effort**: Quick wins
2. **High Impact, Medium Effort**: Strategic improvements
3. **Medium Impact, Low Effort**: Incremental gains

## Self-Review Process
After creating OPTIMIZE.md:
1. Review findings for accuracy and feasibility
2. Critique suggestions to avoid over-engineering
3. Ensure optimizations align with project constraints
4. Verify proposed changes won't introduce complexity
5. Update recommendations based on review

## Success Criteria
- OPTIMIZE.md file created with concrete, actionable recommendations
- Findings prioritized by impact vs effort
- No over-engineering suggestions included
- All recommendations include specific file references
- Self-review completed with critiques addressed

## Metrics to Consider
- Execution time improvements
- Memory usage reduction
- Code complexity reduction (fewer lines, functions, files)
- Maintainability improvements
