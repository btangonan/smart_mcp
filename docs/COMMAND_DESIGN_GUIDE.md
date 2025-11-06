# Smart MCP Command Design Guide
## For Claude Instances Designing New Slash Commands

**Purpose**: This guide enables you (Claude) to design new Smart MCP slash commands that another Claude instance will implement.

**Your Role**: Command Designer - You will create the specification, instruction framework, and metadata that the implementation Claude will use to build a new `/sm:*` command.

**Last Updated**: 2025-11-06

---

## Understanding Smart MCP Architecture

### What is Smart MCP?

Smart MCP is a **dual-interface system** that combines Claude Code slash commands with an MCP server to deliver reusable instruction frameworks globally.

### How It Works (Execution Flow)

```
User types: /sm:commandname argument
        ↓
1. Claude Code reads: ~/.claude/commands/sm/commandname.md
   - Discovers command via YAML frontmatter
   - Shows rich documentation
        ↓
2. Claude sees invocation instruction:
   "Use the sm tool with shortcut='commandname' and context='argument'"
        ↓
3. Claude calls MCP server:
   sm(shortcut="commandname", context="argument")
        ↓
4. MCP server (smart_mcp.py):
   - Loads shortcuts.json (global + project merge)
   - Finds "commandname" entry
   - Gets instruction framework text
   - Substitutes variables: {task}, {context}, {target}, {file}
        ↓
5. Returns full instruction framework to Claude
        ↓
6. Claude executes the framework systematically
```

### Dual-Interface Components

**Component 1: Slash Command File (.md)**
- Location: `~/.claude/commands/sm/commandname.md`
- Size: 150-250 lines for advanced concepts
- Purpose: Discovery, documentation, metadata
- Contains: YAML frontmatter + documentation sections

**Component 2: Instruction Storage (shortcuts.json)**
- Location: `~/.claude/smart_mcp/shortcuts.json`
- Size: 3-10KB instruction text per shortcut
- Purpose: Instruction framework storage
- Contains: JSON with description + instruction

**CRITICAL**: Both components are required. Missing either = broken command.

---

## Command Design Philosophy

### What Makes a Good Slash Command?

✅ **Systematic Framework**: Provides structured methodology, not just instructions
✅ **Reusable Pattern**: Applies to multiple scenarios, not one-off tasks
✅ **Clear Trigger Conditions**: Obvious when to use vs other commands
✅ **Self-Contained**: Doesn't require external context to execute
✅ **Teachable**: Framework that Claude can learn and apply systematically

❌ **Avoid**: Simple instructions that could be regular prompts
❌ **Avoid**: Overlapping functionality with existing commands
❌ **Avoid**: Too narrow/specific to be reusable

### Existing Commands (Reference)

1. **/sm:refactor** - Surgical refactoring with golden-master testing
   - **Trigger**: Need to improve code quality without changing behavior
   - **Framework**: Find smells → Better abstractions → Patterns → Naming → Reduce complexity
   - **Secret Sauce**: Golden-master characterization, fitness functions

2. **/sm:debug** - 7-step systematic debugging process
   - **Trigger**: Complex bugs requiring root cause analysis
   - **Framework**: Define → Investigate → Anticipate → Plan → Audit → Revise → Execute
   - **Secret Sauce**: Self-critique before execution

3. **/sm:audit** - 8-stage repository self-assessment
   - **Trigger**: Need to assess codebase health and maturity
   - **Framework**: 8 stages from repo probe to maturity scoring
   - **Secret Sauce**: Evidence-based artifacts, 0-3 maturity scale

4. **/sm:introspect** - Meta-cognitive solution soundness analysis
   - **Trigger**: Unsure if solving the RIGHT problem in RIGHT way
   - **Framework**: Context reset → Evidence → Assumptions → Hypotheses → Biases → Soundness
   - **Secret Sauce**: Naive-agent perspective, bias detection

### Gap Analysis Questions

Before designing a new command, ask:
1. Does this fill a gap not covered by existing commands?
2. Is this a systematic framework or just instructions?
3. Would this be reusable across multiple projects/scenarios?
4. Can this be executed without external context?
5. Does this provide unique value vs regular prompts?

---

## Your Design Task

When asked to design a new command, you will create a **complete specification** with:

### 1. Command Overview

```markdown
## Command Name
/sm:commandname

## One-Line Description
Brief (50-100 chars) description of what this command does

## Primary Use Cases
- Specific scenario 1
- Specific scenario 2
- Specific scenario 3

## Differentiation from Existing Commands
How this differs from /sm:refactor, /sm:debug, /sm:audit, /sm:introspect

## Gap Filled
What need does this address that isn't currently covered?
```

### 2. Metadata Specification

```yaml
name: commandname
description: "Brief one-line description"
category: gitignored  # Always use "gitignored" for global scope
complexity: basic|intermediate|advanced
mcp-servers: [list, of, mcp, servers, used]
personas: [relevant, superclaude, personas]
```

**Complexity Guidelines**:
- **basic**: Simple frameworks, 3-5 steps, minimal MCP integration
- **intermediate**: Multi-stage frameworks, 5-8 steps, some MCP tools
- **advanced**: Complex methodologies, 7+ steps, heavy MCP integration

**MCP Servers Available**:
- `sequential`: Multi-step reasoning, complex analysis
- `chroma`: Project memory, institutional knowledge
- `context7`: Library documentation, official guides
- `magic`: UI component generation
- `playwright`: Browser testing, E2E validation
- `serena`: Code intelligence, LSP operations

**SuperClaude Personas**:
- `architect`: System design, architecture
- `auditor`: Code review, quality assessment
- `security`: Security analysis, vulnerability detection
- `performance`: Performance optimization
- `qa-specialist`: Testing, quality assurance
- `root-cause-analyst`: Problem investigation
- `socratic-mentor`: Teaching, learning guidance

### 3. Framework Design

Create a **structured methodology** with clear phases/steps:

```markdown
## Behavioral Flow

### Phase 1: [Name]
[What happens in this phase]
- Specific action 1
- Specific action 2

### Phase 2: [Name]
[What happens in this phase]
- Specific action 1
- Specific action 2

[Continue for all phases...]

## Key Patterns
- **Pattern 1**: Description
- **Pattern 2**: Description

## MCP Integration
- **[Server Name]**: How and when it's used
- **[Server Name]**: How and when it's used

## Tool Coordination
- **Read/Grep/Glob**: For what purpose
- **Bash**: For what purpose
- **Edit/Write**: For what purpose
```

### 4. Instruction Framework Text

This is the actual text that will be stored in `shortcuts.json` and returned to Claude for execution.

**Format**:
```markdown
ROLE
You are [persona description]. Your goal: [clear objective].

PHILOSOPHY
[Core principles that guide execution]

KEY DISTINCTION
[How this differs from similar commands - optional]

BEHAVIORAL FLOW

1. [Phase Name]: [What to do]
   - [Specific action]
   - [Specific action]

2. [Phase Name]: [What to do]
   - [Specific action]
   - [Specific action]

[Continue for all phases...]

OUTPUTS

[What artifacts or results are produced]

ACCEPTANCE CRITERIA

✓ [Criterion 1]
✓ [Criterion 2]
✓ [Criterion 3]

WILL DO
- [Behavior 1]
- [Behavior 2]

WILL NOT DO
- [Anti-pattern 1]
- [Anti-pattern 2]
```

**Variable Placeholders**:
Use these placeholders that will be substituted with user arguments:
- `{task}` - Main task description from user
- `{context}` - Additional context or file path
- `{target}` - Target component or area
- `{file}` - Specific file path

Example: "Your [TASK] is: [{task}]" becomes "Your [TASK] is: [fix authentication bug]"

**Instruction Size**: Aim for 2,000-4,000 characters (3-10KB for advanced frameworks)

### 5. Documentation Sections

Create user-facing documentation:

```markdown
## Triggers
- When to use this command (specific scenarios)
- What problems it solves
- Prerequisites or conditions

## Usage
/sm:commandname [arguments]

Examples:
/sm:commandname specific-example-1
/sm:commandname specific-example-2

## Examples

### Example 1: [Scenario Name]
/sm:commandname [args]

[Brief description of what happens]

### Example 2: [Scenario Name]
/sm:commandname [args]

[Brief description of what happens]

## Boundaries

**Will:**
- Specific capability 1
- Specific capability 2
- Specific capability 3

**Will Not:**
- What it doesn't do 1
- What it doesn't do 2
- What it doesn't do 3
```

---

## Output Format for Implementation

When you've designed a command, provide your specification in this format:

```markdown
# New Command Specification: /sm:commandname

## METADATA
```yaml
name: commandname
description: "One-line description"
category: gitignored
complexity: advanced
mcp-servers: [sequential, chroma]
personas: [architect, auditor]
```

## INSTRUCTION FRAMEWORK (for shortcuts.json)

```
[Full instruction text here with {placeholders}]
```

## DOCUMENTATION (for .md file)

### Triggers
[Content]

### Usage
[Content]

### Examples
[Content]

### Boundaries
[Content]

## IMPLEMENTATION NOTES

[Any special considerations for the implementation Claude]
[Dependencies, prerequisites, validation steps]

## RATIONALE

Why this command is needed:
[Explanation]

How it differs from existing commands:
[Comparison]

Expected use frequency:
[Estimate]
```

---

## Design Checklist

Before submitting your specification, verify:

- [ ] Command name is clear and descriptive (lowercase, no special chars)
- [ ] One-line description is concise (50-100 chars)
- [ ] Differentiation from existing commands is clear
- [ ] Complexity level matches framework depth
- [ ] MCP servers selected are appropriate and justified
- [ ] Personas align with command purpose
- [ ] Framework has clear phases/steps (minimum 3, maximum ~10)
- [ ] Instruction text uses variable placeholders appropriately
- [ ] Instruction text is 2,000-4,000 characters
- [ ] Documentation sections are complete (Triggers, Usage, Examples, Boundaries)
- [ ] Examples are realistic and helpful
- [ ] Boundaries clearly state what command will/won't do
- [ ] Implementation notes include any special requirements

---

## Common Design Patterns

### Pattern 1: Multi-Stage Analysis Framework

**Structure**: Stage 0 → Stage 1 → ... → Stage N → Summary
**Examples**: /sm:audit (8 stages)
**Use When**: Need systematic exploration with evidence gathering

### Pattern 2: Self-Critique Loop

**Structure**: Plan → Audit (critique) → Revise → Execute
**Examples**: /sm:debug (7 steps with audit phase)
**Use When**: Want to prevent premature execution and rework

### Pattern 3: Meta-Cognitive Reset

**Structure**: Context reset → Evidence → Assumptions → Analysis → Recommendations
**Examples**: /sm:introspect (8-phase naive-agent perspective)
**Use When**: Need fresh perspective to avoid cognitive biases

### Pattern 4: Golden-Master Validation

**Structure**: Capture baseline → Transform → Validate → Compare
**Examples**: /sm:refactor (golden-master characterization)
**Use When**: Need to ensure behavior preservation during changes

### Pattern 5: Fitness Function Gates

**Structure**: Define criteria → Execute → Measure → Gate (pass/fail)
**Examples**: /sm:refactor (LOC limits, dependency rules)
**Use When**: Need automated quality gates in framework

---

## Anti-Patterns to Avoid

❌ **Too Specific**: "Fix React hooks in authentication component"
✅ **Good**: "Systematic refactoring with behavior preservation"

❌ **Just Instructions**: "Add error handling and write tests"
✅ **Good**: "7-step debugging framework with self-critique"

❌ **Overlapping**: Creating "super-debug" that duplicates /sm:debug
✅ **Good**: Finding gaps not covered by existing commands

❌ **External Dependencies**: Requiring specific tools not available
✅ **Good**: Using available MCP servers and native Claude capabilities

❌ **One-Off Tasks**: "Deploy to production environment"
✅ **Good**: Reusable patterns applicable to multiple scenarios

---

## Example: Design Session

**User Request**: "Create a command for performance optimization"

**Your Analysis**:
1. Gap check: Not covered by /sm:refactor (behavior preservation) or /sm:debug (bug fixing)
2. Systematic framework: Need methodology for identifying and fixing bottlenecks
3. Reusability: Applies to any codebase/language
4. Trigger: Clear performance issues or optimization requirements

**Your Specification**:

```markdown
# New Command Specification: /sm:optimize

## METADATA
```yaml
name: optimize
description: "Systematic performance optimization with measurement-driven analysis"
category: gitignored
complexity: advanced
mcp-servers: [sequential, chroma]
personas: [performance, architect]
```

## INSTRUCTION FRAMEWORK

ROLE
You are SuperClaude, a performance optimization specialist. Your goal: identify and eliminate performance bottlenecks through measurement-driven analysis.

PHILOSOPHY
Measure before optimizing. Profile before presuming. Validate after changing.

BEHAVIORAL FLOW

1. Baseline Measurement
   - Profile current performance (time, memory, CPU)
   - Identify performance budgets and requirements
   - Document baseline metrics

2. Bottleneck Identification
   - Analyze profiling data for hotspots
   - Identify O(n²) or worse algorithms
   - Find memory leaks or excessive allocations

[Continue framework...]

OUTPUTS
- docs/optimize/profile-baseline.json
- docs/optimize/bottlenecks.md
- docs/optimize/optimization-plan.md

[Continue specification...]
```

---

## Questions to Consider

When designing a command, think about:

1. **Scope**: File-level, module-level, or system-level?
2. **Prerequisites**: What needs to exist before running?
3. **Side Effects**: Does it modify code, or just analyze?
4. **Output Artifacts**: What files/reports are generated?
5. **Validation**: How do we know it succeeded?
6. **Failure Modes**: What could go wrong, and how to handle?
7. **Integration**: Does it work well with other /sm:* commands?

---

## Your Next Steps

When asked to design a command:

1. **Understand the Request**: What problem needs solving?
2. **Check Existing Commands**: Does this gap exist?
3. **Design Framework**: Create systematic methodology
4. **Write Specification**: Use the output format above
5. **Validate Design**: Use the checklist
6. **Submit to Implementation Claude**: Provide complete specification

The implementation Claude will then:
1. Create the .md file in `global/commands/sm/commandname.md`
2. Add entry to `global/smart_mcp/shortcuts.json`
3. Deploy with `./scripts/install.sh`
4. Verify deployment from outside repo
5. Commit and push to repository

---

## Resources

**For More Details**:
- Read `docs/INFRASTRUCTURE.md` for complete architecture
- Read `docs/FOR_FUTURE_CLAUDE.md` for implementation guide
- Check existing commands in `~/.claude/commands/sm/*.md` for examples
- Query Chroma memory collection `smart_mcp_memory` for lessons learned

**Key Principles**:
- Systematic over ad-hoc
- Framework over instructions
- Reusable over specific
- Measured over assumed
- Self-critique over execute-first

---

## Success Criteria

Your design specification is ready when:

- ✅ Clear differentiation from existing commands
- ✅ Systematic framework with 3-10 clear phases
- ✅ Instruction text 2,000-4,000 characters
- ✅ Variable placeholders used appropriately
- ✅ Complete metadata (YAML frontmatter)
- ✅ Rich documentation (Triggers, Usage, Examples, Boundaries)
- ✅ Implementation notes for edge cases
- ✅ Rationale explaining why this is needed

**Remember**: Your role is DESIGN, not implementation. Focus on creating a clear, complete specification that the implementation Claude can execute.

Good luck designing! 🎯
