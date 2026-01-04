#!/usr/bin/env bash
# Scaffold DevOps assets and CI/CD pipelines
# Usage: ./setup-devops.sh

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
CONFIG_TEMPLATE="$REPO_ROOT/ops/templates/ops-config-template.yml"
CONFIG_FILE="$REPO_ROOT/ops/config.yml"

GITHUB_TEMPLATE="$REPO_ROOT/ops/pipelines/github/ci-template.yml"
GITHUB_WORKFLOW_DIR="$REPO_ROOT/.github/workflows"
GITHUB_WORKFLOW_FILE="$GITHUB_WORKFLOW_DIR/ci.yml"

GITLAB_TEMPLATE="$REPO_ROOT/ops/pipelines/gitlab/ci-template.yml"
GITLAB_FILE="$REPO_ROOT/.gitlab-ci.yml"

mkdir -p "$GITHUB_WORKFLOW_DIR"

if [[ ! -f "$CONFIG_FILE" && -f "$CONFIG_TEMPLATE" ]]; then
    cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
    sed -i.bak "s/\\[PROJECT_NAME\\]/$(basename "$REPO_ROOT")/" "$CONFIG_FILE"
    rm "$CONFIG_FILE.bak"
fi

if [[ -f "$GITHUB_TEMPLATE" && ! -f "$GITHUB_WORKFLOW_FILE" ]]; then
    cp "$GITHUB_TEMPLATE" "$GITHUB_WORKFLOW_FILE"
fi

if [[ -f "$GITLAB_TEMPLATE" && ! -f "$GITLAB_FILE" ]]; then
    cp "$GITLAB_TEMPLATE" "$GITLAB_FILE"
fi

echo "DevOps scaffolding complete."
