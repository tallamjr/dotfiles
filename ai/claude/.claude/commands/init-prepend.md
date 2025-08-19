# Command: Initialise Planning Section

## Purpose
Add standardised planning and review workflow section to project's CLAUDE configuration file.

## Parameters
None required - automatically detects and updates appropriate CLAUDE file

## Process
Check project root directory for existing CLAUDE configuration files following this priority:

### File Priority Order
1. **CLAUDE.md exists**: Prepend planning section to beginning of CLAUDE.md
2. **CLAUDE.local.md exists** (but no CLAUDE.md): Prepend planning section to beginning of CLAUDE.local.md
3. **Neither file exists**: Run `/init` to create CLAUDE.local.md, then add planning section to top of newly created file

## Section to Add

```markdown
## Plan & Review

### Before Starting Work
- Always enter plan mode to create a comprehensive plan
- Write detailed plan to .claude/tasks/TASK_NAME.md
- Plan should include detailed implementation steps and reasoning
- Break down tasks into manageable components
- Research external dependencies or packages using Task tool
- Focus on MVP approach - avoid over-planning
- Request user review and approval before proceeding with implementation

### While Implementing
- Update plan as work progresses
- Document completed tasks with detailed descriptions of changes made
- Ensure handover information is clear for other engineers
- Track progress against original plan objectives

### After Task Completion
- Review and update this configuration file if sections below require modification
- Document lessons learned and architectural decisions
- Ensure all planned objectives have been met
```

## Implementation Steps
1. Use Read tool to check for existing CLAUDE.md in project root
2. If not found, check for CLAUDE.local.md
3. If neither exists, run `/init` command to create CLAUDE.local.md
4. Use Edit tool to prepend the planning section to the appropriate file
5. Ensure proper markdown formatting and section hierarchy

## Success Criteria
- Planning section successfully added to appropriate CLAUDE file
- Section is properly formatted and positioned at the beginning
- File maintains existing content and structure
- Planning workflow is clearly documented for future use
