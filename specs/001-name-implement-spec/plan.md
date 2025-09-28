# Implementation Plan: Implement Spec-Driven Development

**Branch**: `001-name-implement-spec` | **Date**: 2025-09-07 | **Spec**: [link](./spec.md)
**Input**: Feature specification from `/specs/001-name-implement-spec/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Fill Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Project Type from context (web=frontend+backend, mobile=app+api)
   → Set Structure Decision based on project type
3. Evaluate Constitution Check section below
   → If violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify approach first"
   → Update Progress Tracking: Initial Constitution Check
4. Execute Phase 0 → research.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve unknowns"
5. Execute Phase 1 → contracts, data-model.md, quickstart.md, agent-specific template file (e.g., `CLAUDE.md` for Claude Code, `.github/copilot-instructions.md` for GitHub Copilot, or `GEMINI.md` for Gemini CLI).
6. Re-evaluate Constitution Check section
   → If new violations: Refactor design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
7. Plan Phase 2 → Describe task generation approach (DO NOT create tasks.md)
8. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 7. Phases 2-4 are executed by other commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3-4: Implementation execution (manual or via tools)

## Summary
The user wants to implement a spec-driven development process. This will involve creating a set of scripts and templates to manage the lifecycle of a feature, from specification to implementation.

## Technical Context
**Language/Version**: [NEEDS CLARIFICATION: e.g., Python 3.11, Swift 5.9, Rust 1.75]
**Primary Dependencies**: [NEEDS CLARIFICATION: e.g., FastAPI, UIKit, LLVM]
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]
**Testing**: [NEEDS CLARIFICATION: e.g., pytest, XCTest, cargo test]
**Target Platform**: [NEEDS CLARIFICATION: e.g., Linux server, iOS 15+, WASM]
**Project Type**: single
**Performance Goals**: [NEEDS CLARIFICATION: domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps]
**Constraints**: [NEEDS CLARIFICATION: domain-specific, e.g., <200ms p95, <100MB memory, offline-capable]
**Scale/Scope**: [NEEDS CLARIFICATION: domain-specific, e.g., 10k users, 1M LOC, 50 screens]

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Simplicity**:
- Projects: [#] (max 3 - e.g., api, cli, tests) - **1**
- Using framework directly? (no wrapper classes) - **Yes**
- Single data model? (no DTOs unless serialization differs) - **Yes**
- Avoiding patterns? (no Repository/UoW without proven need) - **Yes**

**Architecture**:
- EVERY feature as library? (no direct app code) - **Yes**
- Libraries listed: [name + purpose for each] - **spec-driven-development: A library to manage the spec-driven development process.**
- CLI per library: [commands with --help/--version/--format] - **`spec --help`, `spec --version`, `spec --format json`**
- Library docs: llms.txt format planned? - **Yes**

**Testing (NON-NEGOTIABLE)**:
- RED-GREEN-Refactor cycle enforced? (test MUST fail first) - **Yes**
- Git commits show tests before implementation? - **Yes**
- Order: Contract→Integration→E2E→Unit strictly followed? - **Yes**
- Real dependencies used? (actual DBs, not mocks) - **Yes**
- Integration tests for: new libraries, contract changes, shared schemas? - **Yes**
- FORBIDDEN: Implementation before test, skipping RED phase - **Yes**

**Observability**:
- Structured logging included? - **Yes**
- Frontend logs → backend? (unified stream) - **N/A**
- Error context sufficient? - **Yes**

**Versioning**:
- Version number assigned? (MAJOR.MINOR.BUILD) - **0.1.0**
- BUILD increments on every change? - **Yes**
- Breaking changes handled? (parallel tests, migration plan) - **Yes**

## Project Structure

### Documentation (this feature)
```
specs/001-name-implement-spec/
├── plan.md              # This file (/plan command output)
├── research.md          # Phase 0 output (/plan command)
├── data-model.md        # Phase 1 output (/plan command)
├── quickstart.md        # Phase 1 output (/plan command)
├── contracts/           # Phase 1 output (/plan command)
└── tasks.md             # Phase 2 output (/tasks command - NOT created by /plan)
```

### Source Code (repository root)
```
# Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/
```

**Structure Decision**: Option 1

## Phase 0: Outline & Research
1. **Extract unknowns from Technical Context** above:
   - Research the best language for this project.
   - Research the best testing framework for the chosen language.
   - Research the best way to handle storage.
   - Research the performance goals for this project.
   - Research the constraints for this project.
   - Research the scale/scope for this project.

2. **Generate and dispatch research agents**:
   ```
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action → endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Generate contract tests** from contracts:
   - One test file per endpoint
   - Assert request/response schemas
   - Tests must fail (no implementation yet)

4. **Extract test scenarios** from user stories:
   - Each story → integration test scenario
   - Quickstart test = story validation steps

5. **Update agent file incrementally** (O(1) operation):
   - Run `/scripts/update-agent-context.sh [claude|gemini|copilot]` for your AI assistant
   - If exists: Add only NEW tech from current plan
   - Preserve manual additions between markers
   - Update recent changes (keep last 3)
   - Keep under 150 lines for token efficiency
   - Output to repository root

**Output**: data-model.md, /contracts/*, failing tests, quickstart.md, agent-specific file

## Phase 2: Task Planning Approach
*This section describes what the /tasks command will do - DO NOT execute during /plan*

**Task Generation Strategy**:
- Load `/templates/tasks-template.md` as base
- Generate tasks from Phase 1 design docs (contracts, data model, quickstart)
- Each contract → contract test task [P]
- Each entity → model creation task [P]
- Each user story → integration test task
- Implementation tasks to make tests pass

**Ordering Strategy**:
- TDD order: Tests before implementation
- Dependency order: Models before services before UI
- Mark [P] for parallel execution (independent files)

**Estimated Output**: 25-30 numbered, ordered tasks in tasks.md

**IMPORTANT**: This phase is executed by the /tasks command, NOT by /plan

## Phase 3+: Future Implementation
*These phases are beyond the scope of the /plan command*

**Phase 3**: Task execution (/tasks command creates tasks.md)
**Phase 4**: Implementation (execute tasks.md following constitutional principles)
**Phase 5**: Validation (run tests, execute quickstart.md, performance validation)

## Complexity Tracking
*Fill ONLY if Constitution Check has violations that must be justified*

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
|           |            |                                     |

## Progress Tracking
*This checklist is updated during execution flow*

**Phase Status**:
- [X] Phase 0: Research complete (/plan command)
- [X] Phase 1: Design complete (/plan command)
- [X] Phase 2: Task planning complete (/plan command - describe approach only)
- [ ] Phase 3: Tasks generated (/tasks command)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [X] Initial Constitution Check: PASS
- [X] Post-Design Constitution Check: PASS
- [X] All NEEDS CLARIFICATION resolved
- [ ] Complexity deviations documented

---
*Based on Constitution v2.1.1 - See `/memory/constitution.md`*