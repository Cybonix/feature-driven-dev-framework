#!/usr/bin/env bash
# Check for required DevOps artifacts and content compliance
# Usage: ./check-devops-compliance.sh [--json]

set -e

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) echo "Usage: $0 [--json]"; exit 0 ;;
    esac
done

REPO_ROOT=$(git rev-parse --show-toplevel)

# Required Files
CONFIG_FILE="$REPO_ROOT/ops/config.yml"
SECURITY_POLICY="$REPO_ROOT/ops/policies/security.md"
GITHUB_WORKFLOW="$REPO_ROOT/.github/workflows/ci.yml"
GITLAB_PIPELINE="$REPO_ROOT/.gitlab-ci.yml"

missing=()
content_issues=()

# 1. Existence Checks
[[ -f "$CONFIG_FILE" ]] || missing+=("ops/config.yml")
[[ -f "$SECURITY_POLICY" ]] || missing+=("ops/policies/security.md")

# Check for at least one pipeline (GitHub or GitLab) - strict mode usually requires one.
# For this framework, we check that the *templates* exist in ops/pipelines if we haven't set up the root yet,
# but if this script is checking the *project state*, it should check the root files.
# Let's check the templates first as this is the framework repo.
[[ -f "$REPO_ROOT/ops/pipelines/github/ci-template.yml" ]] || missing+=("ops/pipelines/github/ci-template.yml")

# 2. Content Checks (Grepping for key configuration)
if [[ -f "$CONFIG_FILE" ]]; then
    if ! grep -q "security:" "$CONFIG_FILE"; then
        content_issues+=("ops/config.yml missing 'security' section")
    fi
    if ! grep -q "environments:" "$CONFIG_FILE"; then
        content_issues+=("ops/config.yml missing 'environments' section")
    fi
fi

if [[ -f "$SECURITY_POLICY" ]]; then
    if ! grep -q "trivy" "$SECURITY_POLICY"; then
        content_issues+=("ops/policies/security.md missing 'trivy' requirement")
    fi
    if ! grep -q "gitleaks" "$SECURITY_POLICY"; then
        content_issues+=("ops/policies/security.md missing 'gitleaks' requirement")
    fi
fi

# Reporting
if $JSON_MODE; then
    json_missing=$(printf '"%s",' "${missing[@]}")
    json_missing="[${json_missing%,}]"
    json_issues=$(printf '"%s",' "${content_issues[@]}")
    json_issues="[${json_issues%,}]"
    printf '{"missing":%s, "content_issues":%s}\n' "$json_missing" "$json_issues"
else
    failed=false
    if [[ "${#missing[@]}" -ne 0 ]]; then
        echo "❌ Missing required DevOps artifacts:"
        for item in "${missing[@]}"; do
            echo "  - $item"
        done
        failed=true
    fi

    if [[ "${#content_issues[@]}" -ne 0 ]]; then
        echo "⚠️  Content compliance issues:"
        for item in "${content_issues[@]}"; do
            echo "  - $item"
        done
        failed=true
    fi

    if [ "$failed" = false ]; then
        echo "✅ All DevOps compliance checks passed."
    else
        exit 1
    fi
fi