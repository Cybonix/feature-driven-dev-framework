# Repository Guidelines

## Project Structure & Module Organization
- `specs/NNN-short-slug/`: Feature folders matching branch names. Contains `spec.md`, `plan.md`, optional `tasks.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`.
- `templates/`: Markdown templates used to scaffold specs and plans.
- `scripts/`: Bash utilities (see commands below). Shared helpers live in `scripts/common.sh`.
- `memory/`: Team/process docs (e.g., `constitution.md`).
- `.gemini/commands/`: CLI command specs (e.g., `specify.toml`, `plan.toml`, `tasks.toml`).

## Build, Test, and Development Commands
- New feature (creates branch + folder): `bash scripts/create-new-feature.sh "User signup flow"`
- Scaffold implementation plan: `bash scripts/setup-plan.sh`
- Inspect required/optional docs: `bash scripts/check-task-prerequisites.sh --json`
- Resolve active paths: `bash scripts/get-feature-paths.sh`
- Update agent context files: `bash scripts/update-agent-context.sh claude|gemini|copilot`

## Coding Style & Naming Conventions
- Bash 4+ with `#!/usr/bin/env bash` and `set -e`.
- Indentation: 4 spaces. Quote variables; prefer `local` in functions; use `[[ ... ]]` and `"$(... )"`.
- Function names: `lower_snake_case`; script files: `kebab-case.sh`.
- Feature branches and spec folders: `NNN-short-slug` (e.g., `002-user-auth`). Scripts rely on this format.
- Markdown: keep headings concise; use provided templates in `templates/`.

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
- Scripts only create/copy within `specs/`; avoid destructive operations unless explicitly required.
