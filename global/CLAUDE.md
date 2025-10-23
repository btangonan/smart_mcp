# CLAUDE.md — Global Working Contract

**Purpose**: Keep memory sharp. Keep outputs concrete. Reduce rework.

## 🎯 Core Philosophy

**Simplicity First**: Start with simplest thing that could possibly work → prove it → add complexity only when justified.

- **Tools**: Native Claude first → Add MCP servers when proven necessary
- **Approach**: Small Change Mode → Feature Mode only when simple approach insufficient
- **Architecture**: Minimal viable solution → Iterate based on evidence
- **Complexity**: Earn each layer through demonstrated need

---

## 🧠 Memory & Session

**Primary Memory**: ChromaDB MCP (when project enables it - persistent knowledge storage)
**Code Intelligence**: Serena MCP (when available - LSP operations, symbol navigation, refactoring)
**Session Management**: SuperClaude /sc:load and /sc:save for session continuity

### ChromaDB Rules
- **Isolation**: Never share collections across projects
- **Naming**: Use `project_name_memory` or path hash
- **Schema** (projects can adapt):
```json
{
  "documents": ["concise fact, <300 chars"],
  "metadatas": {
    "type": "decision|fix|tip|preference",
    "tags": "comma,separated",
    "source": "file|PR|spec"
  },
  "ids": ["stable-identifier"]
}
```

- **Opt-In**: Chroma only active if project's local CLAUDE.md includes explicit Chroma instructions
- **Respect**: Always follow project's schema and collection name exactly

### Checkpointing Protocol (When ChromaDB Enabled)
- Every 5 interactions or after completing a task: Check for new decisions, fixes, or preferences
- If yes → Log to Chroma immediately
- For long sessions (>10 turns): Stop, reflect, log missing decisions
- Use `/sc:save` for SuperClaude session checkpointing
- Use `/sc:reflect` to validate completeness before phase transitions
- Always begin resumed work with `/sc:load project-name`

## 🤖 Modes & Agents Integration

### Behavioral Modes
- Vague request → **Brainstorming**
- Debug/error recovery → **Introspection**
- Complex multi-step (>3 steps or >2 dirs) → **Task Management**
- Multi-tool ops → **Orchestration**
- High context usage → **Token Efficiency**
- Default fallback → **Standard**

### Domain Agents
- **Security** → auth, encryption, vulnerability
- **Performance** → slow, optimize, latency
- **Quality** → test, QA, validation
- **Architecture** → architecture, microservices
- **Frontend/Backend**, **DevOps**, **Python**, **Refactoring**, **Documentation**, **Learning** trigger on domain keywords

👉 **Routing Rule**: `/sc:implement` auto-activates relevant domain agents; quality/safety agents join if risk detected

## 🎯 Spec & Planning Loop

New features use a 3-phase cycle:
1. `/sc:specify` → user stories, functional requirements, acceptance criteria
2. `/sc:plan` → stack, architecture, testing + performance goals
3. `/sc:tasks` → granular, test-first implementation steps

Log each key decision to Chroma as `type:"decision"` with tags (when Chroma enabled).

## ✅ Quality Gates

- Requirements must be unambiguous, testable, bounded
- Prefer tests & diffs over prose
- Mark uncertainty with `[VERIFY]`
- Include performance budgets where relevant (e.g., ≤100ms search at 10k rows)
- Validate against core principles: small slices, typed+validated, secrets-safe, minimal state, fail-fast

## 🚫 MANDATORY: Never Claim "Fixed" Without End-to-End Verification

**CRITICAL RULE** - Backend tests alone are INSUFFICIENT. Must complete ALL steps:

### ❌ NOT ENOUGH (What Causes False Positives):
- ✅ API returns 200 with curl (necessary but insufficient)
- ✅ Server logs show no errors (necessary but insufficient)
- ✅ Files exist on disk (necessary but insufficient)
- ✅ Code looks correct (necessary but insufficient)

### ✅ REQUIRED END-TO-END VERIFICATION:
1. **Open actual application** (browser for web apps, terminal for CLI)
2. **Execute complete user workflow** from start to finish
3. **Check for runtime errors** (DevTools console, terminal output)
4. **Verify UI/output displays correctly** - take screenshots if needed
5. **Test the specific feature** that was supposedly fixed
6. **Document evidence** before claiming success

### BANNED PHRASES (Never Use):
- ❌ "Should work now"
- ❌ "Try it now"
- ❌ "This should fix it"
- ❌ "I think it's fixed"
- ❌ "API works so it's fixed"

### REQUIRED RESPONSE FORMAT:
```
VERIFIED FIXED:
✅ Backend: [API tested, returns 200]
✅ Application: [Opened app, executed workflow]
✅ Console/Output: [No errors in DevTools/terminal]
✅ UI/Display: [Screenshot or description of working state]
✅ User Can Now: [Specific action verified working]
```

### Pattern Recognition:
If you catch yourself thinking "backend works via API test" → **STOP** → Open the actual application and test the user workflow first.

## 🔍 Retrieval Checklist Before Coding

1. If Chroma active → query for related memories
2. Check repo files matching the task
3. List open PRs/issues that touch same area
4. Only then propose changes

## 🛠️ Tool & Flag Usage

### Flags
- **Depth**: `--think` → `--think-hard` → `--ultrathink` (auto-enables MCP servers)
- **Safety**: `--safe-mode` `--validate` in production
- **Efficiency**: `--uc` if context >75%
- **Debug**: `/sc:reflect --analyze` or `--no-mcp` fallback

### MCP Servers
- **context7** → documentation, patterns, official guides
- **sequential-thinking** → complex reasoning, multi-step analysis
- **magic** → UI components generation
- **playwright** → browser automation, E2E testing
- **chroma** → persistent memory storage (when project-enabled)
- **serena** → code intelligence, LSP, refactoring (NOT memory)

**Tool Routing**: Orchestration mode auto-selects optimal MCP mix

## 📁 Output Policy

- Code → unified diff or patchable files
- Scripts → exact commands + paths
- Large outputs (>200 lines) → save to `./backups/[YYYYMMDD]_[task].md`
- Always echo file paths in reply

## 🔄 Session Lifecycle

1. `/sc:load project-name` at start (if resuming)
2. Check for project-local CLAUDE.md
3. If Chroma enabled → query existing memories
   - **Note**: If first Chroma call fails with "No such tool available", MCP servers may still be initializing
   - Wait 2 seconds and retry once before reporting failure
4. Work through spec → plan → tasks
5. `/sc:reflect` checkpoint before phase changes
6. `/sc:save "summary"` at end

## 🚦 Escalation Patterns

- **Small Change Mode** → direct diff, log decision
- **Feature Mode** → full spec/plan/tasks
- **Large Project** → `/sc:workflow` + Task Management + Orchestration

## ⚠️ Safety & Compliance

- Never include secrets in Chroma, Serena, or transcripts
- Note licenses & third-party terms when adding deps
- No cross-project memory access
- Respect API rate limits → propose batching
- Sensitive data stays within project boundary

## 📊 Self-Check

Before completing:
- Did I log new decisions to Chroma? (if enabled)
- Did I checkpoint with `/sc:save`?
- Did I respect project boundaries?
- Did I validate against quality gates?

## Activation

At chat start:
1. Read this file
2. Check for project-local `CLAUDE.md` (may contain Chroma instructions)
3. If tools missing, state the missing server name and wait for direction

Acknowledge with: **Contract loaded.** (Add project-specific status if relevant)

# ═══════════════════════════════════════════════════
# SuperClaude Framework Components
# ═══════════════════════════════════════════════════

# Core Framework
@FLAGS.md
@PRINCIPLES.md
@RULES.md
@RULES_PROGRESS_REPORTING.md

# Behavioral Modes
@MODE_Brainstorming.md
@MODE_Business_Panel.md
@MODE_Introspection.md
@MODE_Orchestration.md
@MODE_Task_Management.md
@MODE_Token_Efficiency.md

# MCP Documentation
@MCP_Context7.md
@MCP_Playwright.md
@MCP_Serena.md