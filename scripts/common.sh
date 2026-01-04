#!/usr/bin/env bash
# Common functions and variables for all scripts

# Get repository root
get_repo_root() {
    git rev-parse --show-toplevel
}

# Parse a value from ops/config.yml
# Usage: get_ops_config "project.language" -> returns "python"
#        get_ops_config "commands.test" -> returns the test command
get_ops_config() {
    local key="$1"
    local repo_root="${2:-$(get_repo_root)}"
    local config_file="$repo_root/ops/config.yml"

    if [[ ! -f "$config_file" ]]; then
        echo ""
        return 1
    fi

    # Use yq if available (preferred), otherwise fallback to Python
    if command -v yq &> /dev/null; then
        yq -r ".$key // empty" "$config_file" 2>/dev/null
    elif command -v python3 &> /dev/null; then
        python3 - "$config_file" "$key" << 'PYEOF'
import sys
import yaml

config_file = sys.argv[1]
key_path = sys.argv[2]

try:
    with open(config_file, 'r') as f:
        config = yaml.safe_load(f)

    # Navigate nested keys (e.g., "project.language")
    value = config
    for part in key_path.split('.'):
        if isinstance(value, dict):
            value = value.get(part)
        else:
            value = None
            break

    if value is not None:
        print(value)
except Exception:
    pass
PYEOF
    else
        # Fallback: simple grep for top-level keys
        grep "^${key}:" "$config_file" 2>/dev/null | sed 's/^[^:]*: *//' | tr -d '"'
    fi
}

# Get the full ops config as environment variables
# Usage: eval $(export_ops_config)
export_ops_config() {
    local repo_root="${1:-$(get_repo_root)}"
    local config_file="$repo_root/ops/config.yml"

    if [[ ! -f "$config_file" ]]; then
        return 1
    fi

    python3 - "$config_file" << 'PYEOF'
import sys
import yaml
import os

config_file = sys.argv[1]

try:
    with open(config_file, 'r') as f:
        config = yaml.safe_load(f)

    # Export project settings
    project = config.get('project', {})
    print(f"OPS_PROJECT_NAME='{project.get('name', '')}'")
    print(f"OPS_PROJECT_LANGUAGE='{project.get('language', 'generic')}'")
    print(f"OPS_PROJECT_FRAMEWORK='{project.get('framework', 'none')}'")
    print(f"OPS_PROJECT_TYPE='{project.get('type', 'library')}'")

    # Export commands
    commands = config.get('commands', {})
    for cmd_name, cmd_value in commands.items():
        safe_name = cmd_name.upper().replace('-', '_')
        print(f"OPS_CMD_{safe_name}='{cmd_value}'")

except Exception as e:
    print(f"# Error: {e}", file=sys.stderr)
PYEOF
}

# Get current branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Check if current branch is a feature branch
# Returns 0 if valid, 1 if not
check_feature_branch() {
    local branch="$1"
    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch"
        echo "Feature branches should be named like: 001-feature-name"
        return 1
    fi
    return 0
}

# Get feature directory path
get_feature_dir() {
    local repo_root="$1"
    local branch="$2"
    echo "$repo_root/framework/specs/$branch"
}

# Get all standard paths for a feature
# Usage: eval $(get_feature_paths)
# Sets: REPO_ROOT, CURRENT_BRANCH, FEATURE_DIR, FEATURE_SPEC, IMPL_PLAN, TASKS
get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local feature_dir=$(get_feature_dir "$repo_root" "$current_branch")
    
    echo "REPO_ROOT='$repo_root'"
    echo "CURRENT_BRANCH='$current_branch'"
    echo "FEATURE_DIR='$feature_dir'"
    echo "FEATURE_SPEC='$feature_dir/spec.md'"
    echo "IMPL_PLAN='$feature_dir/plan.md'"
    echo "TASKS='$feature_dir/tasks.md'"
    echo "RESEARCH='$feature_dir/research.md'"
    echo "DATA_MODEL='$feature_dir/data-model.md'"
    echo "QUICKSTART='$feature_dir/quickstart.md'"
    echo "CONTRACTS_DIR='$feature_dir/contracts'"
}

# Check if a file exists and report
check_file() {
    local file="$1"
    local description="$2"
    if [[ -f "$file" ]]; then
        echo "  ✓ $description"
        return 0
    else
        echo "  ✗ $description"
        return 1
    fi
}

# Check if a directory exists and has files
check_dir() {
    local dir="$1"
    local description="$2"
    if [[ -d "$dir" ]] && [[ -n "$(ls -A "$dir" 2>/dev/null)" ]]; then
        echo "  ✓ $description"
        return 0
    else
        echo "  ✗ $description"
        return 1
    fi
}
