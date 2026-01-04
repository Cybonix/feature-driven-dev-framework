# Feature-Driven Development Framework

A comprehensive framework for **feature-driven development** with integrated **DevOps automation** and **AI agent support**. This framework bridges the gap between specification, implementation, and operations—enabling both human developers and AI agents (Claude Code, Gemini CLI, GitHub Copilot) to work seamlessly with a unified configuration.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Ops Configuration](#ops-configuration)
- [Feature Workflow](#feature-workflow)
- [Agentic Workflow](#agentic-workflow)
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
├── AGENTS.md                     # Repository guidelines for AI agents
├── CLAUDE.md / GEMINI.md         # Agent-specific context files (auto-generated)
│
├── ops/                          # DevOps Foundation (Agent-Ready)
│   ├── config.yml                # Central configuration (language, commands, security)
│   ├── intake/                   # Prompt intake artifacts
│   ├── pipelines/                # CI/CD templates
│   │   ├── github/
│   │   │   ├── ci-template.yml       # Generic CI
│   │   │   ├── android-ci.yml        # Android builds
│   │   │   ├── ios-ci.yml            # iOS builds
│   │   │   ├── flutter-ci.yml        # Flutter cross-platform
│   │   │   ├── react-native-ci.yml   # React Native + EAS
│   │   │   └── frontend-ci.yml       # Enhanced frontend (Lighthouse, etc.)
│   │   └── gitlab/
│   │       ├── ci-template.yml
│   │       ├── android-ci.yml
│   │       ├── ios-ci.yml
│   │       ├── flutter-ci.yml
│   │       ├── react-native-ci.yml
│   │       └── frontend-ci.yml
│   ├── policies/                 # Security baselines (trivy, gitleaks mandated)
│   │   └── security.md
│   ├── observability/            # Logging/metrics/tracing standards
│   ├── release/                  # Release and versioning policies
│   ├── runbooks/                 # Incident and rollback templates
│   └── templates/                # Ops config templates
│
├── framework/                    # Feature-Driven Development
│   ├── specs/                    # Feature folders (one per spec)
│   │   └── <NNN-short-slug>/
│   │       ├── spec.md           # Feature specification
│   │       ├── plan.md           # Implementation plan
│   │       ├── tasks.md          # Task breakdown (optional)
│   │       ├── research.md       # Research notes (optional)
│   │       ├── data-model.md     # Data model (optional)
│   │       ├── contracts/        # API contracts (optional)
│   │       └── quickstart.md     # Quick start guide (optional)
│   ├── plans/                    # Implementation plans (optional grouping)
│   ├── tasks/                    # Task lists (optional grouping)
│   └── templates/                # Markdown scaffolding templates
│
├── scripts/                      # Automation Bridge
│   ├── common.sh                 # Shared functions + ops config parsing
│   ├── run-task.sh               # Command resolver (abstracts toolchain)
│   ├── normalize-prompt.sh       # Prompt intake with ops context
│   ├── create-new-feature.sh     # Feature branch scaffolding
│   ├── setup-plan.sh             # Plan generation
│   ├── update-agent-context.sh   # Inject ops config into agent files
│   ├── check-devops-compliance.sh
│   └── ...
│
├── memory/                       # Team/process documentation
│   └── constitution.md           # Core principles and governance
│
└── .gemini/commands/             # Gemini CLI command specs
```

### Key Directories

| Directory | Purpose |
|-----------|---------|
| **`ops/`** | DevOps foundation: central config, pipelines, security policies, runbooks |
| **`ops/config.yml`** | **Central configuration** read by all scripts and agents |
| **`framework/`** | Feature-driven development: specs, plans, tasks |
| **`framework/specs/`** | Feature folders using `NNN-short-slug` naming convention |
| **`scripts/`** | Automation bridge between framework and ops |
| **`memory/`** | Team governance and constitution |
| **`AGENTS.md`** | Repository guidelines for AI agents |

---

## Getting Started

### 1. Clone and Setup

```bash
git clone <repo-url>
cd <repo-directory>
```

### 2. Prerequisites

- **Bash 4+** (`#!/usr/bin/env bash`)
- **Git**
- **Python 3** with PyYAML (`pip install pyyaml`) — for config parsing
- Optional: `yq` for faster YAML parsing
- Optional: `shellcheck` for script linting

### 3. Initialize DevOps Foundation

```bash
# Scaffold DevOps assets (pipelines, policies, config)
bash scripts/setup-devops.sh

# Verify compliance
bash scripts/check-devops-compliance.sh
```

### 4. Configure Your Project

Edit `ops/config.yml` to match your project:

```yaml
project:
    name: "my-project"
    language: "python"      # python, node, go, rust, java, generic
    framework: "fastapi"    # django, react, none, etc.
    type: "service"         # service, library, cli, frontend

commands:
    setup: "pip install -e .[dev]"
    lint: "ruff check ."
    test: "pytest"
    build: "python -m build"
    start: "uvicorn main:app"
```

### 5. Validate Setup

```bash
# List available commands from config
bash scripts/run-task.sh --list

# Run a task (abstracted from underlying toolchain)
bash scripts/run-task.sh test
```

---

## Mobile Platform Support

This framework provides comprehensive support for mobile application development with native and cross-platform options.

### Supported Platforms

| Platform | Language | Build System | CI/CD Template |
|----------|----------|--------------|----------------|
| **Android** | Kotlin/Java | Gradle | `ops/pipelines/github/android-ci.yml` |
| **iOS** | Swift | Xcode | `ops/pipelines/github/ios-ci.yml` |
| **Flutter** | Dart | Flutter CLI | `ops/pipelines/github/flutter-ci.yml` |
| **React Native** | TypeScript | Metro + EAS | `ops/pipelines/github/react-native-ci.yml` |

### Mobile Configuration Example

```yaml
project:
    name: "my-mobile-app"
    language: "kotlin"           # kotlin | swift | dart
    framework: "compose"         # compose | swiftui | flutter
    type: "android"              # android | ios | flutter | react-native

platform:
    min_sdk: 24                  # Android API level or iOS version
    target_sdk: 34
    bundle_id: "com.company.app"
    signing:
        debug: true
        release: false           # Enable when ready for store deployment

commands:
    setup: "./gradlew dependencies"
    lint: "./gradlew lint"
    test: "./gradlew test"
    build_android: "./gradlew assembleDebug"
    build_release: "./gradlew bundleRelease"
```

### Mobile Security Scanning

All mobile pipelines include MobSF (Mobile Security Framework) scanning:
- Static analysis of APK/IPA files
- OWASP Mobile Top 10 compliance checks
- Hardcoded secrets detection
- Insecure permissions identification

---

## Enhanced Frontend Support

The framework supports modern frontend frameworks with enhanced CI/CD capabilities.

### Supported Frameworks

| Framework | Rendering | CI Features |
|-----------|-----------|-------------|
| **React/Next.js** | CSR/SSR/SSG | Lighthouse, bundle analysis, visual regression |
| **Vue/Nuxt** | CSR/SSR/SSG | Lighthouse, bundle analysis, visual regression |
| **Angular** | CSR/SSR | Lighthouse, bundle analysis, accessibility |
| **Svelte/SvelteKit** | CSR/SSR | Lighthouse, bundle analysis, visual regression |
| **Remix** | SSR | Lighthouse, bundle analysis |

### Frontend Configuration Example

```yaml
project:
    name: "my-frontend-app"
    language: "node"
    framework: "next"            # next | nuxt | react | vue | angular | svelte | remix
    type: "frontend"             # frontend | pwa

commands:
    setup: "npm ci"
    lint: "npm run lint"
    test: "npm test"
    build: "npm run build"
    e2e: "npx playwright test"
    lighthouse: "npx lhci autorun"
    bundle_analyze: "npm run analyze"
    visual_test: "npx playwright test --project=visual"

security:
    dependency_audit:
        tool: "npm"
        args: "audit --audit-level=high"
        fail_on: "high,critical"
```

### Frontend CI/CD Features

The enhanced frontend pipeline (`ops/pipelines/github/frontend-ci.yml`) includes:

- **Lighthouse CI**: Performance scoring with configurable thresholds
- **Bundle Analysis**: Track bundle size changes across PRs
- **Visual Regression**: Screenshot comparison with Playwright
- **Browser Compatibility**: Test matrix across Chromium, Firefox, WebKit
- **Accessibility Testing**: Automated axe-core checks
- **PWA Validation**: Service worker and manifest verification

---

## Ops Configuration

The `ops/config.yml` file is the **single source of truth** for project configuration. All scripts and AI agents read this file to understand how to interact with the project.

### Configuration Schema

```yaml
# Project metadata
project:
    name: "project-name"
    language: "python"       # python | node | go | rust | java | generic
    framework: "none"        # django | fastapi | react | express | none
    type: "library"          # service | library | cli | frontend

# Environment definitions (for deployment strategies)
environments:
    - name: "development"
      branch: "feature/*"
      deploy_strategy: "ephemeral"
    - name: "production"
      branch: "main"
      deploy_strategy: "rolling"

# Command registry (agents use run-task.sh to execute these)
commands:
    setup: "pip install -e .[dev]"
    lint: "ruff check ."
    test: "pytest"
    build: "python -m build"
    start: "python -m myapp"

# Security gates (enforced by CI)
security:
    sast:
        tool: "trivy"
        args: "fs ."
        fail_on: "high,critical"
    secrets:
        tool: "gitleaks"
        args: "detect --no-git"
        fail_on: "any"
```

### Using the Configuration

**From scripts:**
```bash
source scripts/common.sh

# Get a single value
get_ops_config "project.language"    # -> "python"
get_ops_config "commands.test"       # -> "pytest"

# Export all as environment variables
eval $(export_ops_config)
echo $OPS_PROJECT_LANGUAGE           # -> "python"
echo $OPS_CMD_TEST                   # -> "pytest"
```

**Run tasks without knowing the toolchain:**
```bash
# Instead of remembering: npm test vs pytest vs cargo test
bash scripts/run-task.sh test

# Works for any configured command
bash scripts/run-task.sh lint
bash scripts/run-task.sh build
```

---

## Feature Workflow

The repository follows a **spec-first** approach:

1. **Normalize the prompt** – Capture the raw prompt and generate intake artifacts.
   ```bash
   bash scripts/normalize-prompt.sh --prompt "User signup flow"
   ```
   The script:
   - Writes `ops/intake/prompt.md` and `ops/intake/clarifications.md`.
   - Scaffolds `ops/config.yml` if missing.
   - Creates a new feature branch and spec folder.

2. **Create a new feature** (optional) – This creates a Git branch and a corresponding folder under `framework/specs/`.
   ```bash
   bash scripts/create-new-feature.sh "User signup flow"
   ```
   The script:
   - Generates a new branch named `NNN-user-signup-flow` (incrementing `NNN`).
   - Copies the spec, plan, and tasks templates into `framework/specs/NNN-user-signup-flow/`.
   - Checks out the new branch.

3. **Write the specification** – Edit `framework/specs/NNN‑user-signup-flow/spec.md` describing the feature, acceptance criteria, and any UI/UX mockups.

3. **Scaffold an implementation plan** – Once the spec is approved, generate a concrete plan:
   ```bash
   bash scripts/setup-plan.sh
   ```
   The script reads the spec and creates `plan.md` using `framework/templates/plan-template.md`.

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

6. **Run tests & lint** – Use the command resolver to run project tasks:
   ```bash
   # Run tests (uses command from ops/config.yml)
   bash scripts/run-task.sh test

   # Run linting
   bash scripts/run-task.sh lint

   # Validate scripts
   bash -n scripts/*.sh
   ```

7. **Open a Pull Request** – Follow the PR guidelines in `AGENTS.md` (title, description, sample command output, etc.).

---

## Agentic Workflow

This framework is designed to work seamlessly with AI coding agents. The `ops/config.yml` configuration and standardized scripts provide a consistent interface that agents can understand and use.

### Supported Agents

| Agent | Context File | Update Command |
|-------|--------------|----------------|
| **Claude Code** | `CLAUDE.md` | `bash scripts/update-agent-context.sh claude` |
| **Gemini CLI** | `GEMINI.md` | `bash scripts/update-agent-context.sh gemini` |
| **GitHub Copilot** | `.github/copilot-instructions.md` | `bash scripts/update-agent-context.sh copilot` |

### How Agents Use This Framework

1. **Read project config** – Agents read `ops/config.yml` to understand the project:
   - Language and framework
   - Available commands (test, lint, build, etc.)
   - Security requirements

2. **Execute tasks via command resolver** – Instead of guessing `npm test` vs `pytest`:
   ```bash
   bash scripts/run-task.sh test    # Runs whatever is configured
   bash scripts/run-task.sh lint    # Language-agnostic
   ```

3. **Automatic context injection** – When a feature plan is created, `update-agent-context.sh` automatically injects:
   - Project language/framework
   - Available commands
   - Environment definitions
   - Security gates

### Agent Context Auto-Population

When you run `scripts/update-agent-context.sh`, it reads `ops/config.yml` and injects a block like this into agent context files:

```markdown
## Ops Configuration

### Project
- **Language**: python
- **Framework**: fastapi
- **Type**: service

### Commands (use `scripts/run-task.sh <task>`)
```
setup: pip install -e .[dev]
lint: ruff check .
test: pytest
```

### Security Gates (enforced by CI)
- SAST: `trivy` - fails on high,critical
- Secrets: `gitleaks` - fails on any
```

### Prompt Intake with Ops Context

When using `normalize-prompt.sh`, the script automatically reads `ops/config.yml` and:
- Pre-fills clarifications with known project settings
- Provides language-specific context to the intake artifacts
- Displays detected configuration:

```bash
$ bash scripts/normalize-prompt.sh --prompt "Add user authentication"
--- Ops Configuration Detected ---
Language: python
Framework: fastapi
Type: service
----------------------------------
Prompt normalized to ops/intake
```

---

## Scripts & Utilities

### Core Framework Scripts

| Script | Purpose | Key Options |
|--------|---------|-------------|
| `normalize-prompt.sh` | Captures prompt intake with ops context, scaffolds feature spec | `--prompt` or `--file` |
| `create-new-feature.sh` | Creates a new feature branch and spec folder | `"Feature description"` |
| `setup-plan.sh` | Generates `plan.md` from the spec template | None |
| `check-task-prerequisites.sh` | Validates required/optional docs for current spec | `--json` |
| `get-feature-paths.sh` | Prints absolute paths for spec folder, plan, tasks | None |
| `migrate-plan-paths.sh` | Updates legacy plan.md path references | None |
| `update-agent-context.sh` | Injects ops config into agent context files | `claude\|gemini\|copilot` |

### Ops Integration Scripts

| Script | Purpose | Key Options |
|--------|---------|-------------|
| **`run-task.sh`** | **Command resolver** - runs tasks from ops/config.yml | `<task>`, `--list`, `--dry-run` |
| `setup-devops.sh` | Scaffolds DevOps config and CI/CD pipeline files | None |
| `check-devops-compliance.sh` | Validates required DevOps artifacts | `--json` |
| `get-devops-paths.sh` | Prints absolute paths for DevOps assets | None |

### Shared Utilities

| Script | Purpose |
|--------|---------|
| `common.sh` | Shared functions: `get_ops_config()`, `export_ops_config()`, path helpers |

All scripts adhere to the coding style defined in `AGENTS.md` (4-space indentation, `set -e`, quoted variables, `[[ … ]]` tests).

---

## Templates

The `framework/templates/` directory contains Markdown skeletons used by the scripts:

- **`spec-template.md`** – Outline for a feature specification (summary, goals, UI, API, acceptance criteria).
- **`plan-template.md`** – Structure for an implementation plan (architecture, steps, risks, rollout).
- **`tasks-template.md`** – Task breakdown format (title, description, owner, estimate, status).
- **`agent-file-template.md`** – Boilerplate for agent context files used by AI assistants.

Feel free to modify these templates to match your team's preferred documentation style, but keep the placeholders (`{{...}}`) intact so scripts can replace them correctly.

---

## Testing & Validation

### Quick Validation

```bash
# 1. Validate all scripts
bash -n scripts/*.sh

# 2. Check DevOps compliance
bash scripts/check-devops-compliance.sh

# 3. List available tasks
bash scripts/run-task.sh --list

# 4. Run project tests (if configured)
bash scripts/run-task.sh test

# 5. Run linting (if configured)
bash scripts/run-task.sh lint
```

### CI Integration

Recommended CI pipeline steps:

1. **Lint Bash scripts**: `bash -n scripts/*.sh && shellcheck scripts/*.sh`
2. **DevOps compliance**: `bash scripts/check-devops-compliance.sh`
3. **Security scans** (per `ops/policies/security.md`):
   - `gitleaks detect --no-git` (secrets)
   - `trivy fs .` (SAST/SCA)
4. **Run project tests**: `bash scripts/run-task.sh test`
5. **Run project lint**: `bash scripts/run-task.sh lint`

See `ops/pipelines/github/ci-template.yml` and `ops/pipelines/gitlab/ci-template.yml` for ready-to-use pipeline definitions.

---

## Contribution Guidelines

- **Branch naming** – Use the format `NNN-short-slug` (e.g., `005-payment-gateway`). The number should be sequential based on existing folders in `framework/specs/`.
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
