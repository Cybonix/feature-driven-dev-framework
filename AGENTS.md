# Repository Guidelines

## Project Structure & Module Organization
- `ops/`: Global DevOps assets (pipelines, policies, observability, release rules, runbooks, intake).
- `framework/specs/NNN-short-slug/`: Feature folders matching branch names. Contains `spec.md`, `plan.md`, optional `tasks.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`.
- `framework/templates/`: Markdown templates used to scaffold specs and plans.
- `scripts/`: Bash utilities (see commands below). Shared helpers live in `scripts/common.sh`.
- `memory/`: Team/process docs (e.g., `constitution.md`).
- `.gemini/commands/`: CLI command specs (e.g., `specify.toml`, `plan.toml`, `tasks.toml`).

## Build, Test, and Development Commands

### Core Framework Commands
- Normalize prompt intake (creates branch + intake artifacts): `bash scripts/normalize-prompt.sh --prompt "User signup flow"`
- New feature (creates branch + folder): `bash scripts/create-new-feature.sh "User signup flow"`
- Scaffold implementation plan: `bash scripts/setup-plan.sh`
- Inspect required/optional docs: `bash scripts/check-task-prerequisites.sh --json`
- Resolve active paths: `bash scripts/get-feature-paths.sh`
- Migrate plan path references: `bash scripts/migrate-plan-paths.sh`
- Update agent context files: `bash scripts/update-agent-context.sh claude|gemini|copilot`

### Ops Integration Commands
- **Run any task** (abstracted toolchain): `bash scripts/run-task.sh <task>` (e.g., `run-task.sh test`, `run-task.sh lint`)
- List available tasks: `bash scripts/run-task.sh --list`
- Dry-run a task: `bash scripts/run-task.sh <task> --dry-run`
- Scaffold DevOps assets: `bash scripts/setup-devops.sh`
- Validate DevOps compliance: `bash scripts/check-devops-compliance.sh --json`
- Resolve DevOps paths: `bash scripts/get-devops-paths.sh`

### ops/config.yml Integration
The `ops/config.yml` file is the central configuration that agents should read. It contains:
- **project**: language, framework, type
- **commands**: setup, lint, test, build, start (mapped to actual toolchain commands)
- **environments**: development, staging, production with deploy strategies
- **security**: SAST/SCA (trivy), secrets detection (gitleaks) gates

Scripts automatically read this config via `scripts/common.sh`:
```bash
source scripts/common.sh
get_ops_config "project.language"    # -> "python"
get_ops_config "commands.test"       # -> "pytest"
eval $(export_ops_config)            # -> exports OPS_PROJECT_LANGUAGE, OPS_CMD_TEST, etc.
```

## Coding Style & Naming Conventions
- Bash 4+ with `#!/usr/bin/env bash` and `set -e`.
- Indentation: 4 spaces. Quote variables; prefer `local` in functions; use `[[ ... ]]` and `"$(... )"`.
- Function names: `lower_snake_case`; script files: `kebab-case.sh`.
- Feature branches and spec folders: `NNN-short-slug` (e.g., `002-user-auth`). Scripts rely on this format.
- Markdown: keep headings concise; use provided templates in `framework/templates/`.

## Testing Guidelines
- Lint/validate scripts: `bash -n scripts/*.sh` and (if available) `shellcheck scripts/*.sh`.
- Prefer idempotent scripts and dry outputs (`--json`) to verify behavior without side effects.
- When adding a new script, include usage header and a minimal example.

## Commit & Pull Request Guidelines
- Use Conventional Commits: `feat(specs): scaffold 003-billing` `fix(scripts): handle missing plan` `docs: update constitution`.
- One logical change per PR. Include a clear description, linked issue (if any), and sample command output (e.g., `check-task-prerequisites.sh --json`).
- If changing `scripts/`, describe expected inputs/outputs and branch assumptions.

## Security & Configuration Tips
- Scripts assume Git is available and you are on a feature branch. Avoid storing secrets in specs or templates.
- Scripts only create/copy within `framework/specs/` or `ops/`; avoid destructive operations unless explicitly required.
