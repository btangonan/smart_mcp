# Claude Code Skill Best Practices

**Purpose**: Comprehensive guide for creating efficient, maintainable Claude Code skills that follow community standards and token optimization principles.

**Last Updated**: 2025-10-22

---

## Overview & Philosophy

### What is a Claude Code Skill?

A Claude Code skill is a **reusable behavior pattern** that Claude can trigger based on user input. Think of skills as **pointers to knowledge**, not **containers of knowledge**.

**Key Analogy**: Skills are like CLAUDE.md files
- CLAUDE.md: ~200 lines of high-level principles → references Chroma for data
- Skills: ~200-400 lines of behavior logic → references Chroma/other skills for details

### Core Principles

1. **Single Responsibility**: Each skill does ONE thing well
2. **Composition Over Monoliths**: Multiple small skills > one large skill
3. **Reference Over Duplication**: Point to Chroma/docs/other skills vs embedding everything
4. **Token Efficiency**: Minimal metadata, focused content
5. **Evidence-Based**: Size limits based on actual performance data

---

## Size Guidelines

### Official Evidence

**From Anthropic Documentation**:
> "Skill metadata uses a few dozen tokens. The full content is only loaded when the skill is triggered."

**Implication**: Frontmatter must be minimal to avoid wasting tokens on every conversation turn.

### Recommended Size Ranges

| Category | Line Count | Use Case | Examples |
|----------|-----------|----------|----------|
| ✅ **Simple Skills** | 150-250 lines | Single-purpose, focused functionality | quality-gate, context-builder |
| ✅ **Complex Skills** | 250-400 lines | Multi-component but cohesive logic | tool-selector, smart-mcp-coach |
| ⚠️ **Warning Zone** | 400-600 lines | Consider splitting or refactoring | (none recommended) |
| ❌ **Too Large** | >600 lines | Violates best practices, must refactor | (antipattern) |

### Evidence from CLAUDE.md Pattern

- **CLAUDE.md**: ~200 lines of contract + references to separate MODE_*.md files
- **MODE_*.md files**: ~100-200 lines each, focused on single behavior
- **Pattern**: Multiple focused files > one giant file

### Token Efficiency Math

**Frontmatter Tokens** (loaded every turn):
- Minimal (50 lines): ~200 tokens
- Moderate (150 lines): ~600 tokens
- Large (300 lines): ~1200 tokens

**Content Tokens** (loaded on trigger):
- Small (200 lines): ~800 tokens
- Medium (400 lines): ~1600 tokens
- Large (1000 lines): ~4000 tokens

**Verdict**: Keep frontmatter <100 lines, total content <400 lines for optimal efficiency.

---

## File Structure & Organization

### Recommended Structure

```markdown
---
name: skill-name
description: One-line purpose (<80 chars)
triggers:
  - keyword1
  - keyword2
category: main-category
---

# Skill Name

**Purpose**: Clear 1-2 sentence purpose statement

## Core Logic

[Essential decision-making logic and algorithms]

## Key Patterns

[2-3 core templates or examples]

## Integration Points

[How this skill works with others]

## Chroma Queries

[What data to retrieve from Chroma]

## Execution Instructions

[Specific behaviors when triggered]
```

### What Belongs in Skills vs Chroma

**In Skill File**:
- ✅ Trigger keywords and patterns
- ✅ Core decision-making logic
- ✅ Essential templates (2-3 max)
- ✅ Integration instructions
- ✅ Execution behaviors

**In Chroma**:
- ✅ Historical data and evidence
- ✅ Detailed case studies
- ✅ Past routing decisions
- ✅ Efficiency metrics
- ✅ Extended template libraries
- ✅ Edge case catalogs

**Remove Entirely**:
- ❌ Verbose explanations (be concise)
- ❌ Redundant examples (keep 1-2 best)
- ❌ Duplicate logic (reference other skills)
- ❌ Test scenarios (separate test docs)

---

## Frontmatter Best Practices

### Minimal Metadata

**Good** (50 lines):
```yaml
---
name: tool-selector
description: Intelligent MCP tool selection based on complexity analysis
triggers:
  - mcp tool selection
  - which tool should
  - optimize tool usage
category: orchestration
priority: high
integrations:
  - smart-mcp-coach
  - quality-gate
---
```

**Bad** (200 lines):
```yaml
---
name: tool-selector
description: |
  This is an incredibly detailed explanation of what this tool does,
  including extensive background, historical context, philosophical
  justification, and detailed use cases that could easily be 50+ lines
  of YAML that gets loaded on every single conversation turn...
triggers:
  - [100+ trigger variations listed verbosely]
category: orchestration
subcategories:
  - [extensive subcategory taxonomy]
metadata:
  - [tons of metadata that could be in Chroma]
---
```

### Trigger Design

**Focused** (5-10 essential triggers):
```yaml
triggers:
  - tool selection
  - which mcp
  - optimize tools
  - performance issues
  - too many tools
```

**Unfocused** (50+ variations):
```yaml
triggers:
  - tool selection
  - tool choosing
  - select a tool
  - which tool
  - what tool
  - pick a tool
  - [... 44 more variations]
```

**Verdict**: Be selective. Claude's semantic understanding catches variations.

---

## Content Organization Patterns

### The 80/20 Rule

**80% of value from 20% of content**:
- Keep the 20% that delivers 80% of functionality
- Move the remaining 80% to Chroma or remove

### Template Reduction Strategy

**Before** (8 detailed templates, 300 lines):
```markdown
## Routing Templates

### Template 1: Refactoring Scenario
[50 lines of detailed walkthrough]

### Template 2: Debugging Scenario
[50 lines of detailed walkthrough]

### Template 3: Implementation Scenario
[50 lines of detailed walkthrough]

[... 5 more detailed templates ...]
```

**After** (3 core patterns, 80 lines):
```markdown
## Core Routing Patterns

### Pattern 1: Analysis Tasks → sequential-thinking
**Triggers**: complex reasoning, multi-step analysis
**Query**: `complexity:analysis tools:sequential`

### Pattern 2: Bulk Edits → morphllm
**Triggers**: pattern-based changes, multi-file edits
**Query**: `complexity:moderate tools:morphllm`

### Pattern 3: UI Work → magic
**Triggers**: components, design, frontend
**Query**: `complexity:low tools:magic`

**Extended Templates**: Query Chroma for detailed scenarios
```

### Verbose → Concise Transformation

**Verbose** (100 lines):
```markdown
The tool selector is a sophisticated routing system designed to intelligently
analyze incoming user requests and determine the optimal combination of MCP
tools to use for task execution. It considers multiple factors including
complexity, domain requirements, performance constraints, and available tool
capabilities. The system employs a multi-stage decision framework that begins
with request classification, proceeds through complexity scoring...
[90 more lines of explanation]
```

**Concise** (20 lines):
```markdown
**Purpose**: Route tasks to optimal MCP tools based on complexity and domain.

**Process**:
1. Classify request → domain + complexity
2. Score available tools → match criteria
3. Select best tool(s) → execute with context
4. Log decision → Chroma for learning

**Key Factors**: complexity, domain, performance, available tools
```

---

## Chroma Integration Guidelines

### Query Strategy

**Effective Chroma Usage**:
```markdown
## Chroma Queries

**Before Routing**:
- Query: `"similar routing decisions"` → Learn from history
- Query: `"tool performance for [domain]"` → Evidence-based selection
- Limit: 5 results (efficiency)

**After Execution**:
- Log: Decision + outcome + reasoning
- Schema: `{type:"decision", tags:"routing,[tools],[domain]"}`
```

### What to Log

**Good Logging**:
- Routing decisions with reasoning
- Tool performance observations
- Novel scenarios encountered
- Refactoring insights

**Bad Logging**:
- Redundant information
- Generic statements
- Non-actionable observations

---

## Common Mistakes to Avoid

### 1. The Teaching Trap

**Problem**: Trying to teach everything in one skill file

**Example**:
```markdown
# Tool Selector

[50 lines of core logic]

## Teaching Framework

### Phase 1: Understanding MCP Tools
[100 lines of educational content]

### Phase 2: Complexity Analysis
[100 lines of educational content]

[... more teaching phases ...]
```

**Solution**: Reference smart-mcp-coach instead
```markdown
## Teaching Integration

For detailed MCP tool education, trigger smart-mcp-coach.
This skill focuses on routing decisions, not teaching.
```

### 2. The Template Explosion

**Problem**: Including every possible scenario as a template

**Solution**:
- Keep 2-3 core templates in skill
- Store extended template library in Chroma
- Reference examples rather than embedding them all

### 3. The Documentation Duplication

**Problem**: Repeating information from other skills or docs

**Solution**:
- Reference other skills: "See quality-gate.md for validation rules"
- Reference docs: "See FOR_FUTURE_CLAUDE.md for architecture"
- Keep DRY principle

### 4. The Edge Case Catalog

**Problem**: Listing every possible edge case

**Solution**: Synthesize to principles
- Bad: "If X, then Y. If Z, then A. If Q, then B..." [50 variations]
- Good: "Default to simplest tool; escalate only when complexity score >0.7"

---

## Refactoring Checklist

### When to Refactor

**Triggers**:
- ⚠️ Skill >400 lines
- ⚠️ Frontmatter >100 lines
- ⚠️ Multiple responsibilities
- ⚠️ Duplicate logic with other skills
- ⚠️ Verbose examples or explanations

### Refactoring Process

1. **Analyze Current Structure**
   - [ ] Count total lines
   - [ ] Identify sections and their sizes
   - [ ] Find redundant or verbose content

2. **Extract to Chroma**
   - [ ] Historical data → Chroma
   - [ ] Extended examples → Chroma
   - [ ] Evidence and metrics → Chroma

3. **Condense Content**
   - [ ] Verbose → concise transformations
   - [ ] 8 templates → 2-3 core patterns
   - [ ] Remove redundant examples

4. **Reference, Don't Duplicate**
   - [ ] Point to other skills for shared logic
   - [ ] Reference docs instead of repeating
   - [ ] Use Chroma queries for details

5. **Validate Functionality**
   - [ ] Core logic preserved?
   - [ ] Triggers still work?
   - [ ] Integrations intact?
   - [ ] Chroma queries functional?

### Target Reductions

| Section | Typical Before | Target After | Strategy |
|---------|---------------|--------------|----------|
| Frontmatter | 150 lines | 50 lines | Minimal metadata only |
| Purpose | 50 lines | 20 lines | Concise bullets |
| Templates | 300 lines | 80 lines | 2-3 core patterns |
| Teaching | 100 lines | 30 lines | Reference coach skill |
| Edge Cases | 100 lines | 30 lines | Synthesize to principles |

---

## Quality Metrics

### File Size Compliance

**Measurement**:
```bash
wc -l ~/.claude/skills/*.md
```

**Targets**:
- Simple skills: 150-250 lines ✅
- Complex skills: 250-400 lines ✅
- Any skill: <400 lines ⚠️

### Token Efficiency

**Frontmatter Tokens** (estimated):
```
Lines * 4 = Token Count
50 lines * 4 = ~200 tokens ✅
150 lines * 4 = ~600 tokens ⚠️
```

**Target**: <100 lines frontmatter (<400 tokens)

### Functionality Preservation

**Validation Checks**:
- [ ] Triggers activate correctly
- [ ] Core logic executes properly
- [ ] Integrations work with other skills
- [ ] Chroma queries return useful data
- [ ] No regressions in behavior

---

## Examples: Good vs Bad

### Example 1: Concise vs Verbose

**Bad** (Verbose purpose, 80 lines):
```markdown
# Tool Selector

## Purpose and Philosophical Foundation

The tool selector represents a sophisticated approach to intelligent routing
within the Smart MCP framework. It embodies the principle that optimal tool
selection requires deep understanding of both the task domain and the
capabilities of available tools. By analyzing multiple dimensions of
incoming requests including semantic content, structural patterns,
performance requirements, and contextual factors, the tool selector
can make nuanced decisions about which MCP tools to employ...

[60 more lines of philosophical discussion]
```

**Good** (Concise purpose, 15 lines):
```markdown
# Tool Selector

**Purpose**: Route tasks to optimal MCP tools based on complexity and domain analysis.

**Core Function**:
- Classify request → domain + complexity score
- Match tools to requirements
- Execute with appropriate context
- Log decision for learning

**Key Value**: Evidence-based routing that improves over time via Chroma learning.
```

### Example 2: Template Reduction

**Bad** (8 templates, 400 lines):
```markdown
## Routing Templates

### Scenario 1: User Requests Refactoring
**User Input**: "refactor the authentication system"
**Analysis Process**: [30 lines of detailed walkthrough]
**Tool Selection**: [20 lines of reasoning]
**Execution**: [20 lines of steps]

[7 more detailed scenarios at ~50 lines each...]
```

**Good** (3 patterns, 60 lines):
```markdown
## Core Routing Patterns

### Analysis Tasks
**Indicators**: reasoning, multi-step, complex
**Tool**: sequential-thinking MCP
**Chroma Query**: `routing:analysis outcome:success`

### Bulk Transformations
**Indicators**: pattern, multi-file, replace
**Tool**: morphllm MCP
**Chroma Query**: `routing:edit efficiency:high`

### UI Development
**Indicators**: component, design, frontend
**Tool**: magic MCP
**Chroma Query**: `routing:ui frameworks:[detected]`

**Extended Scenarios**: Query Chroma `routing:examples` for detailed walkthroughs
```

---

## Quick Reference

### Skill Creation Checklist

- [ ] Purpose clear in 1-2 sentences
- [ ] Frontmatter <100 lines
- [ ] Total content <400 lines
- [ ] 2-3 core templates max
- [ ] References to Chroma for data
- [ ] References to other skills (no duplication)
- [ ] Concise explanations (no verbose prose)
- [ ] Single responsibility maintained
- [ ] Token efficiency considered

### Refactoring Quick Wins

1. **Frontmatter**: Remove verbose descriptions → concise metadata
2. **Purpose**: Long paragraphs → bullet points
3. **Templates**: 8+ scenarios → 2-3 core patterns + Chroma reference
4. **Teaching**: Embedded education → reference smart-mcp-coach
5. **Examples**: Many redundant → 1-2 best + Chroma for rest
6. **Edge Cases**: Catalog of scenarios → synthesized principles

---

## Resources

- **CLAUDE.md Pattern**: See ~/.claude/CLAUDE.md for reference architecture
- **Mode Files**: See ~/.claude/MODE_*.md for focused behavior examples
- **For Future Claude**: See docs/FOR_FUTURE_CLAUDE.md for system overview
- **Chroma Integration**: See CLAUDE.md for memory schema and usage

---

**Remember**: Skills are **pointers to knowledge**, not **containers**. Keep them focused, concise, and let Chroma handle the data.
