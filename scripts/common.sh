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

# ============================================================================
# PLATFORM DETECTION FUNCTIONS
# ============================================================================

# Get the platform category from project type
# Returns: mobile | frontend | backend | generic
get_platform_type() {
    local repo_root="${1:-$(get_repo_root)}"
    local project_type=$(get_ops_config "project.type" "$repo_root")

    case "$project_type" in
        android|ios|react-native|flutter)
            echo "mobile"
            ;;
        frontend|pwa)
            echo "frontend"
            ;;
        service|library|cli)
            echo "backend"
            ;;
        *)
            echo "generic"
            ;;
    esac
}

# Check if project is a mobile project
is_mobile_project() {
    local platform=$(get_platform_type "$1")
    [[ "$platform" == "mobile" ]]
}

# Check if project is a frontend project
is_frontend_project() {
    local platform=$(get_platform_type "$1")
    [[ "$platform" == "frontend" ]]
}

# Get mobile-specific configuration
# Usage: get_mobile_config "target_sdk" -> returns "34"
get_mobile_config() {
    local key="$1"
    local repo_root="${2:-$(get_repo_root)}"
    get_ops_config "project.platform.$key" "$repo_root"
}

# Get the appropriate CI template filename based on project type
get_ci_template() {
    local repo_root="${1:-$(get_repo_root)}"
    local project_type=$(get_ops_config "project.type" "$repo_root")

    case "$project_type" in
        android)
            echo "android-ci.yml"
            ;;
        ios)
            echo "ios-ci.yml"
            ;;
        flutter)
            echo "flutter-ci.yml"
            ;;
        react-native)
            echo "react-native-ci.yml"
            ;;
        frontend|pwa)
            echo "frontend-ci.yml"
            ;;
        *)
            echo "ci-template.yml"
            ;;
    esac
}

# Get platform-specific default commands
# Usage: get_platform_default_command "build" -> returns appropriate build command
get_platform_default_command() {
    local task_name="$1"
    local repo_root="${2:-$(get_repo_root)}"
    local project_type=$(get_ops_config "project.type" "$repo_root")
    local language=$(get_ops_config "project.language" "$repo_root")

    case "$project_type" in
        android)
            case "$task_name" in
                setup) echo "./gradlew dependencies" ;;
                lint) echo "./gradlew lint" ;;
                test) echo "./gradlew test" ;;
                build) echo "./gradlew assembleDebug" ;;
                build_android) echo "./gradlew assembleRelease bundleRelease" ;;
                start) echo "./gradlew installDebug" ;;
                *) echo "" ;;
            esac
            ;;
        ios)
            case "$task_name" in
                setup) echo "pod install || swift package resolve" ;;
                lint) echo "swiftlint lint --strict" ;;
                test) echo "xcodebuild test -scheme App -destination 'platform=iOS Simulator,name=iPhone 15'" ;;
                build) echo "xcodebuild build -scheme App -configuration Debug" ;;
                build_ios) echo "xcodebuild archive -scheme App -archivePath build/App.xcarchive" ;;
                start) echo "open -a Simulator" ;;
                *) echo "" ;;
            esac
            ;;
        flutter)
            case "$task_name" in
                setup) echo "flutter pub get" ;;
                lint) echo "flutter analyze" ;;
                test) echo "flutter test --coverage" ;;
                build) echo "flutter build apk --debug" ;;
                build_android) echo "flutter build apk --release && flutter build appbundle --release" ;;
                build_ios) echo "flutter build ios --release" ;;
                start) echo "flutter run" ;;
                *) echo "" ;;
            esac
            ;;
        react-native)
            case "$task_name" in
                setup) echo "npm ci && cd ios && pod install" ;;
                lint) echo "npm run lint" ;;
                test) echo "npm test -- --coverage" ;;
                build) echo "npm run build" ;;
                build_android) echo "cd android && ./gradlew assembleRelease" ;;
                build_ios) echo "cd ios && xcodebuild archive -scheme App -archivePath ../build/App.xcarchive" ;;
                start) echo "npm start" ;;
                *) echo "" ;;
            esac
            ;;
        frontend|pwa)
            case "$task_name" in
                setup) echo "npm ci" ;;
                lint) echo "npm run lint" ;;
                test) echo "npm test -- --coverage" ;;
                build) echo "npm run build" ;;
                start) echo "npm run dev" ;;
                lighthouse) echo "npx lighthouse http://localhost:3000 --output json" ;;
                bundle_analyze) echo "npm run build -- --analyze" ;;
                visual_test) echo "npx playwright test --project=visual" ;;
                e2e) echo "npx playwright test" ;;
                *) echo "" ;;
            esac
            ;;
        *)
            # Generic/backend defaults based on language
            case "$language" in
                python)
                    case "$task_name" in
                        setup) echo "pip install -e '.[dev]'" ;;
                        lint) echo "ruff check ." ;;
                        test) echo "pytest" ;;
                        build) echo "python -m build" ;;
                        *) echo "" ;;
                    esac
                    ;;
                node|typescript)
                    case "$task_name" in
                        setup) echo "npm ci" ;;
                        lint) echo "npm run lint" ;;
                        test) echo "npm test" ;;
                        build) echo "npm run build" ;;
                        start) echo "npm start" ;;
                        *) echo "" ;;
                    esac
                    ;;
                go)
                    case "$task_name" in
                        setup) echo "go mod download" ;;
                        lint) echo "golangci-lint run" ;;
                        test) echo "go test ./..." ;;
                        build) echo "go build ./..." ;;
                        *) echo "" ;;
                    esac
                    ;;
                rust)
                    case "$task_name" in
                        setup) echo "cargo fetch" ;;
                        lint) echo "cargo clippy" ;;
                        test) echo "cargo test" ;;
                        build) echo "cargo build --release" ;;
                        *) echo "" ;;
                    esac
                    ;;
                *)
                    echo ""
                    ;;
            esac
            ;;
    esac
}

# Print platform information
print_platform_info() {
    local repo_root="${1:-$(get_repo_root)}"
    local project_type=$(get_ops_config "project.type" "$repo_root")
    local platform=$(get_platform_type "$repo_root")
    local language=$(get_ops_config "project.language" "$repo_root")
    local framework=$(get_ops_config "project.framework" "$repo_root")

    echo "Platform Information:"
    echo "  Type: $project_type"
    echo "  Category: $platform"
    echo "  Language: $language"
    echo "  Framework: $framework"

    if is_mobile_project "$repo_root"; then
        local target_sdk=$(get_mobile_config "target_sdk" "$repo_root")
        local min_sdk=$(get_mobile_config "min_sdk" "$repo_root")
        local deployment_target=$(get_mobile_config "deployment_target" "$repo_root")
        local bundle_id=$(get_mobile_config "bundle_id" "$repo_root")

        echo "  Mobile Config:"
        [[ -n "$target_sdk" ]] && echo "    Target SDK: $target_sdk"
        [[ -n "$min_sdk" ]] && echo "    Min SDK: $min_sdk"
        [[ -n "$deployment_target" ]] && echo "    iOS Deployment Target: $deployment_target"
        [[ -n "$bundle_id" ]] && echo "    Bundle ID: $bundle_id"
    fi

    echo "  CI Template: $(get_ci_template "$repo_root")"
}
