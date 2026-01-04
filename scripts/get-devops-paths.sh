#!/usr/bin/env bash
# Get paths for DevOps assets
# Usage: ./get-devops-paths.sh

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)

echo "REPO_ROOT: $REPO_ROOT"
echo "OPS_DIR: $REPO_ROOT/ops"
echo "OPS_CONFIG: $REPO_ROOT/ops/config.yml"
echo "SECURITY_POLICY: $REPO_ROOT/ops/policies/security.md"
echo "GITHUB_WORKFLOW: $REPO_ROOT/.github/workflows/ci.yml"
echo "GITLAB_PIPELINE: $REPO_ROOT/.gitlab-ci.yml"
