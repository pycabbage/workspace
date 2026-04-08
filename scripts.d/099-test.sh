#!/bin/bash

set -euo pipefail

echo Test v2

declare -A tests
declare -A test_categories
declare -a test_order

declare_test() {
  local category="$1"
  local description="$2"
  local expression="$3"
  tests["$description"]="$expression"
  test_categories["$description"]="$category"
  test_order+=("$description")
}

run_tests() {
  local failed=0
  local current_category=""
  for description in "${test_order[@]}"; do
    local category="${test_categories[$description]}"
    if [ "$category" != "$current_category" ]; then
      echo ""
      echo "▶ $category"
      current_category="$category"
    fi
    if eval "${tests[$description]}"; then
      echo "  ✅ PASS: $description"
    else
      echo "  ❌ FAIL: $description"
      echo "     expression: ${tests[$description]}"
      failed=1
    fi
  done
  echo ""
  [ $failed -eq 0 ] || exit 1
}


declare_test "User" "Check NONROOT_USER"  '[ "$(id -un)" = "$BAKE_NONROOT_USER" ]'
declare_test "User" "Check NONROOT_GROUP" '[ "$(id -gn)" = "$BAKE_NONROOT_GROUP" ]'
declare_test "User" "Check NONROOT_UID"   '[ "$(id -u)" = "$BAKE_NONROOT_UID" ]'
declare_test "User" "Check NONROOT_GID"   '[ "$(id -g)" = "$BAKE_NONROOT_GID" ]'
declare_test "User" "Check home directory exists" '[ -d "/home/$BAKE_NONROOT_USER" ]'

declare_test "pnpm" "Check pnpm exists" 'command -v pnpm > /dev/null'
declare_test "pnpm" "Check PNPM_HOME environment variable" '[ -n "$PNPM_HOME" ]'
declare_test "pnpm" "Check PNPM_HOME in PATH" 'echo "$PATH" | grep -q "$PNPM_HOME"'


run_tests
