#!/usr/bin/env bash
# Normalize a raw prompt into intake artifacts and scaffold a feature spec
# Usage: ./normalize-prompt.sh --prompt "text"
#        ./normalize-prompt.sh --file path/to/prompt.txt
#
# This script reads ops/config.yml to auto-select language-specific templates
# and pre-fill clarifications based on project configuration.

set -e

PROMPT=""
PROMPT_FILE=""

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --prompt)
            PROMPT="$2"
            shift 2
            ;;
        --file)
            PROMPT_FILE="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 --prompt \"text\" | --file path/to/prompt.txt"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 1
            ;;
    esac
done

if [[ -n "$PROMPT_FILE" ]]; then
    if [[ ! -f "$PROMPT_FILE" ]]; then
        echo "ERROR: Prompt file not found: $PROMPT_FILE" >&2
        exit 1
    fi
    PROMPT="$(cat "$PROMPT_FILE")"
fi

if [[ -z "$PROMPT" ]]; then
    echo "ERROR: Prompt is required." >&2
    exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)

# Source common functions for ops/config.yml parsing
source "$REPO_ROOT/scripts/common.sh"

INTAKE_DIR="$REPO_ROOT/ops/intake"
TEMPLATE_CONFIG="$REPO_ROOT/ops/templates/ops-config-template.yml"
CONFIG_FILE="$REPO_ROOT/ops/config.yml"

mkdir -p "$INTAKE_DIR"

TIMESTAMP="$(date +%Y-%m-%d)"

# Load project configuration from ops/config.yml
OPS_LANGUAGE=$(get_ops_config "project.language")
OPS_FRAMEWORK=$(get_ops_config "project.framework")
OPS_TYPE=$(get_ops_config "project.type")
OPS_PROJECT_NAME=$(get_ops_config "project.name")

# Determine language-specific context
LANG_CONTEXT=""
case "$OPS_LANGUAGE" in
    python)
        LANG_CONTEXT="Python project detected. Using pytest, ruff, and pip conventions."
        ;;
    node|javascript|typescript)
        LANG_CONTEXT="Node.js project detected. Using npm/yarn, ESLint, and Jest conventions."
        ;;
    go)
        LANG_CONTEXT="Go project detected. Using go test, golangci-lint conventions."
        ;;
    rust)
        LANG_CONTEXT="Rust project detected. Using cargo test, clippy conventions."
        ;;
    java)
        LANG_CONTEXT="Java project detected. Using Maven/Gradle, JUnit conventions."
        ;;
    generic|*)
        LANG_CONTEXT="Generic/undefined language. Clarify language requirements."
        ;;
esac

cat > "$INTAKE_DIR/prompt.md" << EOF
# Prompt Intake

**Date**: $TIMESTAMP
**Source**: normalize-prompt.sh

## Project Context (from ops/config.yml)
- **Project**: ${OPS_PROJECT_NAME:-Unknown}
- **Language**: ${OPS_LANGUAGE:-generic}
- **Framework**: ${OPS_FRAMEWORK:-none}
- **Type**: ${OPS_TYPE:-library}
- **Note**: $LANG_CONTEXT

## Raw Prompt
${PROMPT}
EOF

# Generate clarifications with pre-filled answers from config
cat > "$INTAKE_DIR/clarifications.md" << EOF
# Prompt Clarifications

## Open Questions
- What is the primary project type (backend, frontend, mobile, infra, monorepo, library)?
- What languages or runtimes are required?
- What deployment target is expected (cloud, on-prem, edge)?
- What environments are required (dev, staging, prod)?
- What test strategy is expected (unit, integration, e2e)?
- Any latency, scale, or availability goals?
- Any compliance or security requirements?

## Answers (Pre-filled from ops/config.yml)
- **Project Type**: ${OPS_TYPE:-[NEEDS CLARIFICATION]}
- **Language**: ${OPS_LANGUAGE:-[NEEDS CLARIFICATION]}
- **Framework**: ${OPS_FRAMEWORK:-[NEEDS CLARIFICATION]}
- **Environments**: $(get_ops_config "environments" | grep -o 'name: [a-z]*' | sed 's/name: //' | tr '\n' ', ' || echo "[NEEDS CLARIFICATION]")
- **Test Command**: $(get_ops_config "commands.test")
- **Security Tools**: trivy (SAST/SCA), gitleaks (secrets) — per ops/policies/security.md
EOF

if [[ ! -f "$CONFIG_FILE" && -f "$TEMPLATE_CONFIG" ]]; then
    cp "$TEMPLATE_CONFIG" "$CONFIG_FILE"
    sed -i.bak "s/\\[PROJECT_NAME\\]/$(basename "$REPO_ROOT")/" "$CONFIG_FILE"
    rm "$CONFIG_FILE.bak"
fi

echo "--- Ops Configuration Detected ---"
echo "Language: ${OPS_LANGUAGE:-generic}"
echo "Framework: ${OPS_FRAMEWORK:-none}"
echo "Type: ${OPS_TYPE:-library}"
echo "----------------------------------"

FEATURE_JSON=$(bash "$REPO_ROOT/scripts/create-new-feature.sh" --json "$PROMPT")

FEATURE_JSON="$FEATURE_JSON" PROMPT_CONTENT="$PROMPT" python3 - << 'EOF'
import json
import os

data = json.loads(os.environ.get("FEATURE_JSON", ""))
spec_path = data.get("SPEC_FILE")
prompt = os.environ.get("PROMPT_CONTENT", "").strip()

with open(spec_path, "r") as f:
    content = f.read()

content = content.replace("$ARGUMENTS", prompt)

with open(spec_path, "w") as f:
    f.write(content)
EOF

if [[ -x "$REPO_ROOT/scripts/migrate-plan-paths.sh" ]]; then
    bash "$REPO_ROOT/scripts/migrate-plan-paths.sh"
fi

echo "Prompt normalized to $INTAKE_DIR"
