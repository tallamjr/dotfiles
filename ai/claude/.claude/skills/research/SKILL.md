---
disable-model-invocation: true
context: fork
description: Deep research combining codebase exploration and web resources
---

# Research

Conduct deep research on a topic by combining codebase exploration with web resources and documentation.

## Arguments

- `$ARGUMENTS` = Research question or topic (required)

## Process

1. **Understand the question**:
   - Parse the research topic from arguments
   - Identify whether this is a codebase question, external topic, or both

2. **Codebase exploration** (if relevant):
   - Use Glob and Grep to find related code, configuration, and documentation
   - Read relevant files to understand current implementation
   - Map dependencies and relationships

3. **External research** (if relevant):
   - Use WebSearch to find authoritative sources
   - Use WebFetch to read documentation pages
   - Check official documentation for libraries and tools
   - Cross-reference multiple sources for accuracy

4. **Synthesise findings**:
   - Combine codebase and external research
   - Identify gaps, contradictions, or areas needing attention
   - Draw conclusions supported by evidence

5. **Present structured output**:

## Output Format

### Research: [Topic]

#### Summary
2-3 sentence overview of findings.

#### Findings
Detailed findings organised by subtopic, with source references.

#### Codebase Impact
How findings relate to the current codebase (if applicable).

#### Recommendations
Actionable next steps based on research.

#### Sources
- Links to external sources consulted
- File paths for codebase references
