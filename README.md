# Project Overview

This repository provides a framework for **feature-driven development** driven by specifications, plans, and automated scripts. It is organized to help teams scaffold new features, manage implementation tasks, and enforce consistent standards across the codebase.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Feature Workflow](#feature-workflow)
- [Scripts & Utilities](#scripts--utilities)
- [Templates](#templates)
- [Testing & Validation](#testing--validation)
- [Contribution Guidelines](#contribution-guidelines)
- [Versioning & Governance](#versioning--governance)
- [License](#license)

---

## Repository Structure

```
.
├── AGENTS.md                     # Repository guidelines and conventions
├── memory/                       # Team/process documentation
│   ├── constitution.md           # Core principles and governance
│   └── constitution_update_checklist.md
├── scripts/                      # Bash utilities for scaffolding & maintenance
│   ├── check-task-prerequisites.sh
│   ├── common.sh
│   ├── create-new-feature.sh
│   ├── get-feature-paths.sh
│   ├── setup-plan.sh
│   └── update-agent-context.sh
├── specs/                        # Feature folders (one per spec)
│   └── <NNN‑short‑slug>/
│       ├── spec.md               # Feature specification
│       ├── plan.md               # Implementation plan
│       ├── tasks.md (optional)   # Task breakdown
│       ├── research.md (optional)
│       ├── data-model.md (optional)
│       ├── contracts/ (optional) # Contract files for integration
│       └── quickstart.md (optional)
├── templates/                    # Markdown scaffolding templates
│   ├── agent-file-template.md
│   ├── plan-template.md
│   ├── spec-template.md
│   └── tasks-template.md
└── .gemini/commands/            # CLI command specs (e.g., specify.toml)
```

### Key Directories

- **`specs/`** – Contains a folder per feature, named using the convention `NNN-short-slug` where `NNN` is the incremental spec number. Each folder holds the specification, plan, and any auxiliary documents.
- **`templates/`** – Provides Markdown templates used by the scripts to scaffold new specs, plans, and tasks.
- **`scripts/`** – Bash helpers that automate repetitive tasks such as creating a new feature branch, generating a plan, and validating prerequisites.
- **`memory/`** – Stores team agreements, the project constitution, and other reference material.
- **`AGENTS.md`** – Centralized guidelines for repository usage, coding style, and commit conventions.

---

## Getting Started

1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd <repo-directory>
   ```
2. **Ensure required tools are installed**
   - Bash 4+ (`#!/usr/bin/env bash`)
   - Git
   - Optional: `shellcheck` for linting scripts
3. **Run a quick lint of the scripts**
   ```bash
   bash -n scripts/*.sh
   # If you have shellcheck installed
   shellcheck scripts/*.sh
   ```

---

## Feature Workflow

The repository follows a **spec‑first** approach:

1. **Create a new feature** – This will create a Git branch and a corresponding folder under `specs/`.
   ```bash
   bash scripts/create-new-feature.sh "User signup flow"
   ```
   The script:
   - Generates a new branch named `NNN-user-signup-flow` (incrementing `NNN`).
   - Copies the spec, plan, and tasks templates into `specs/NNN-user-signup-flow/`.
   - Checks out the new branch.

2. **Write the specification** – Edit `specs/NNN‑user-signup-flow/spec.md` describing the feature, acceptance criteria, and any UI/UX mockups.

3. **Scaffold an implementation plan** – Once the spec is approved, generate a concrete plan:
   ```bash
   bash scripts/setup-plan.sh
   ```
   The script reads the spec and creates `plan.md` using `templates/plan-template.md`.

4. **Validate task prerequisites** – Before starting implementation, verify that all required documents are present:
   ```bash
   bash scripts/check-task-prerequisites.sh --json
   ```
   The output will list missing optional files (e.g., `contracts/`, `research.md`).

5. **Implement the feature** – Follow the tasks listed in `tasks.md` (or create one if missing). Commit changes using Conventional Commits:
   ```bash
   git add .
   git commit -m "feat(specs): implement user signup"
   ```

6. **Run tests & lint** – Ensure scripts remain valid and any added code passes tests.
   ```bash
   bash -n scripts/*.sh
   # Add project‑specific test commands here
   ```

7. **Open a Pull Request** – Follow the PR guidelines in `AGENTS.md` (title, description, sample command output, etc.).

---

## Scripts & Utilities

| Script | Purpose | Key Options |
|--------|---------|-------------|
| `create-new-feature.sh` | Creates a new feature branch and spec folder. | `"Feature description"` |
| `setup-plan.sh` | Generates a `plan.md` from the spec using the plan template. | None |
| `check-task-prerequisites.sh` | Checks that required/optional docs exist for the current spec. | `--json` for machine‑readable output |
| `get-feature-paths.sh` | Prints absolute paths for the current spec folder, plan, and tasks. | None |
| `update-agent-context.sh` | Updates agent context files for Claude, Gemini, or Copilot agents. | `claude|gemini|copilot` |
| `common.sh` | Shared helper functions used by the other scripts. | – |

All scripts adhere to the coding style defined in `AGENTS.md` (4‑space indentation, `set -e`, quoted variables, `[[ … ]]` tests, etc.).

---

## Templates

The `templates/` directory contains Markdown skeletons used by the scripts:

- **`spec-template.md`** – Outline for a feature specification (summary, goals, UI, API, acceptance criteria).
- **`plan-template.md`** – Structure for an implementation plan (architecture, steps, risks, rollout).
- **`tasks-template.md`** – Task breakdown format (title, description, owner, estimate, status).
- **`agent-file-template.md`** – Boilerplate for agent context files used by AI assistants.

Feel free to modify these templates to match your team's preferred documentation style, but keep the placeholders (`{{...}}`) intact so scripts can replace them correctly.

---

## Testing & Validation

1. **Script linting** – As shown earlier, run `bash -n` and optionally `shellcheck`.
2. **Specification validation** – There is currently no automated spec validator, but you can add one (e.g., a Markdown linter) and include it in the CI pipeline.
3. **CI Integration** – Recommended CI steps:
   - Lint all Bash scripts.
   - Verify that every spec folder contains at least `spec.md` and `plan.md`.
   - Run any project‑specific unit or integration tests.

---

## Contribution Guidelines

- **Branch naming** – Use the format `NNN-short-slug` (e.g., `005-payment-gateway`). The number should be sequential based on existing folders in `specs/`.
- **Commit messages** – Follow Conventional Commits (see `AGENTS.md`). Example:
  ```
  feat(specs): scaffold 006-notifications
  fix(scripts): correct path handling in get-feature-paths.sh
  docs: update constitution with new principle
  ```
- **Pull Request requirements**
  - One logical change per PR.
  - Include a clear description, reference to the related spec number, and a sample command output (e.g., `check-task-prerequisites.sh --json`).
  - Ensure all scripts pass lint checks.
- **Review process** – At least one reviewer must approve the PR. Reviewers should verify:
  - Specification completeness.
  - Alignment with the project constitution (`memory/constitution.md`).
  - No secret data or hard‑coded credentials.

---

## Versioning & Governance

The repository is governed by the **Constitution** located at `memory/constitution.md`. It defines core principles such as:
- Library‑first mindset
- CLI‑first interface
- Test‑first (TDD) enforcement
- Integration testing standards
- Observability and semantic versioning

Any changes to the constitution must be documented, approved, and reflected in the version header at the bottom of the file.

---

## License

Add your project’s license information here (e.g., MIT, Apache‑2.0). If the repository is intended for internal use, you may reference the appropriate corporate licensing policy.

---

*This README was generated automatically to provide a comprehensive overview of the repository. Keep it up‑to‑date as the project evolves.*
