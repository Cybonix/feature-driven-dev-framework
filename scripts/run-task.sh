#!/usr/bin/env bash
# Command Resolver: Abstract the underlying toolchain from agents
#
# Usage: ./run-task.sh <task-name> [additional-args]
#        ./run-task.sh test
#        ./run-task.sh lint --fix
#        ./run-task.sh build --release
#        ./run-task.sh --list    # Show all available commands
#
# This script reads ops/config.yml and executes the command defined for
# the given task name. Agents use this to interact with the project
# without needing to know if it's npm, cargo, gradle, etc.

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
source "$REPO_ROOT/scripts/common.sh"

CONFIG_FILE="$REPO_ROOT/ops/config.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 <task-name> [additional-args]"
    echo ""
    echo "Available tasks (from ops/config.yml):"
    list_commands
    echo ""
    echo "Options:"
    echo "  --list          Show all available commands"
    echo "  --dry-run       Show what would be executed without running"
    echo "  --platform-info Show platform detection information"
    echo "  --help, -h      Show this help message"
}

list_commands() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "  (No ops/config.yml found)"
        return 1
    fi

    python3 - "$CONFIG_FILE" << 'PYEOF'
import sys
import yaml

try:
    with open(sys.argv[1], 'r') as f:
        config = yaml.safe_load(f)

    commands = config.get('commands', {})
    if commands:
        for name, cmd in commands.items():
            print(f"  {name:12} -> {cmd}")
    else:
        print("  (No commands defined)")
except Exception as e:
    print(f"  Error reading config: {e}")
PYEOF
}

get_command() {
    local task_name="$1"
    local cmd=$(get_ops_config "commands.$task_name")

    # If command is not defined or is a placeholder, try platform defaults
    if [[ -z "$cmd" ]] || [[ "$cmd" == echo* && "$cmd" == *"No"*"defined"* ]]; then
        local platform_cmd=$(get_platform_default_command "$task_name")
        if [[ -n "$platform_cmd" ]]; then
            echo "$platform_cmd"
            return 0
        fi
    fi

    echo "$cmd"
}

# Parse arguments
DRY_RUN=false
TASK_NAME=""
EXTRA_ARGS=""

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --list)
            echo "Available commands:"
            list_commands
            exit 0
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --platform-info)
            print_platform_info
            exit 0
            ;;
        --help|-h)
            print_usage
            exit 0
            ;;
        -*)
            # Pass through other flags as extra args
            EXTRA_ARGS="$EXTRA_ARGS $1"
            shift
            ;;
        *)
            if [[ -z "$TASK_NAME" ]]; then
                TASK_NAME="$1"
            else
                EXTRA_ARGS="$EXTRA_ARGS $1"
            fi
            shift
            ;;
    esac
done

# Validate task name
if [[ -z "$TASK_NAME" ]]; then
    echo -e "${RED}ERROR: No task name provided.${NC}" >&2
    print_usage
    exit 1
fi

# Check config exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo -e "${RED}ERROR: ops/config.yml not found.${NC}" >&2
    echo "Run 'scripts/setup-devops.sh' to initialize the ops configuration."
    exit 1
fi

# Get the command for this task
COMMAND=$(get_command "$TASK_NAME")

if [[ -z "$COMMAND" ]]; then
    echo -e "${RED}ERROR: Unknown task '$TASK_NAME'.${NC}" >&2
    echo ""
    echo "Available tasks:"
    list_commands
    exit 1
fi

# Check if it's a placeholder command
if [[ "$COMMAND" == echo* && "$COMMAND" == *"No"*"defined"* ]]; then
    echo -e "${YELLOW}WARNING: Task '$TASK_NAME' has a placeholder command.${NC}"
    echo "Update ops/config.yml to define the actual command for your project."
    echo ""
    echo "Current: $COMMAND"
    exit 1
fi

# Append extra args if any
if [[ -n "$EXTRA_ARGS" ]]; then
    COMMAND="$COMMAND$EXTRA_ARGS"
fi

# Execute or dry-run
echo -e "${BLUE}=== Running task: $TASK_NAME ===${NC}"
echo -e "Command: ${GREEN}$COMMAND${NC}"
echo ""

if $DRY_RUN; then
    echo -e "${YELLOW}[DRY-RUN] Would execute: $COMMAND${NC}"
    exit 0
fi

# Run the command from repo root
cd "$REPO_ROOT"
eval "$COMMAND"
EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
    echo ""
    echo -e "${GREEN}=== Task '$TASK_NAME' completed successfully ===${NC}"
else
    echo ""
    echo -e "${RED}=== Task '$TASK_NAME' failed with exit code $EXIT_CODE ===${NC}"
fi

exit $EXIT_CODE
