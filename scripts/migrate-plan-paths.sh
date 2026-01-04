#!/usr/bin/env bash
# Migrate legacy plan.md path references to framework paths
# Usage: ./migrate-plan-paths.sh

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
SPEC_ROOT="$REPO_ROOT/framework/specs"

if [[ ! -d "$SPEC_ROOT" ]]; then
    echo "ERROR: Expected specs at $SPEC_ROOT" >&2
    exit 1
fi

while IFS= read -r -d '' plan_file; do
    PLAN_FILE="$plan_file" python3 - << 'EOF'
import os
import re

path = os.environ["PLAN_FILE"]
with open(path, "r") as f:
    content = f.read()

content = content.replace("/framework/framework/", "/framework/")
content = re.sub(r'(?<!/framework)/specs/', "/framework/specs/", content)
content = re.sub(r'(?<!/framework)/templates/', "/framework/templates/", content)

with open(path, "w") as f:
    f.write(content)
EOF
done < <(find "$SPEC_ROOT" -name plan.md -print0)

echo "Plan path migration complete."
