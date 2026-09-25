#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

pass() {
  echo "[PASS] $1"
  PASS=$((PASS + 1))
}

fail() {
  echo "[FAIL] $1"
  FAIL=$((FAIL + 1))
}

echo "========================================"
echo " HeteroES Frontend - Phase 3 Final Check"
echo "========================================"
echo

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"
CHECK_DIR="$REPO_ROOT/scripts/checks/frontend"

pass "Git repository found: $REPO_ROOT"

# --------------------------------------------------
# Branch
# --------------------------------------------------

BRANCH="$(git -C "$REPO_ROOT" branch --show-current)"

if [[ "$BRANCH" == "feat/mock-coordinator" ]]; then
  pass "Current branch is feat/mock-coordinator"
else
  fail "Expected feat/mock-coordinator, found: $BRANCH"
fi

# --------------------------------------------------
# Phase 3 verification scripts
# --------------------------------------------------

echo
echo "--- Phase 3 sub-phase checks ---"

checks=(
  "check_phase3_domain_types.sh"
  "check_phase3_mock_data.sh"
  "check_phase3_mock_coordinator.sh"
  "check_phase3_api_service.sh"
  "check_phase3_query_hooks.sh"
  "check_phase3_page_integration.sh"
)

for check in "${checks[@]}"; do
  echo
  echo ">>> Running $check"

  if [[ ! -f "$CHECK_DIR/$check" ]]; then
    fail "Missing verification script: $check"
    continue
  fi

  if bash "$CHECK_DIR/$check"; then
    pass "$check passed"
  else
    fail "$check failed"
  fi
done

# --------------------------------------------------
# Required Phase 3 directories
# --------------------------------------------------

echo
echo "--- Phase 3 architecture ---"

required_dirs=(
  "src/types"
  "src/mocks/data"
  "src/api"
  "src/hooks"
)

for dir in "${required_dirs[@]}"; do
  if [[ -d "$FRONTEND/$dir" ]]; then
    pass "$dir exists"
  else
    fail "Missing directory: $dir"
  fi
done

# --------------------------------------------------
# Critical files
# --------------------------------------------------

echo
echo "--- Critical integration files ---"

required_files=(
  "src/app/providers.tsx"
  "src/mocks/browser.ts"
  "src/mocks/handlers.ts"
  "public/mockServiceWorker.js"
)

for file in "${required_files[@]}"; do
  if [[ -s "$FRONTEND/$file" ]]; then
    pass "$file exists"
  else
    fail "Missing or empty: $file"
  fi
done

# --------------------------------------------------
# Dependency checks
# --------------------------------------------------

echo
echo "--- Dependencies ---"

if (
  cd "$FRONTEND" &&
  npm ls @tanstack/react-query --depth=0 >/dev/null 2>&1
); then
  pass "@tanstack/react-query installed"
else
  fail "@tanstack/react-query missing"
fi

if (
  cd "$FRONTEND" &&
  npm ls msw --depth=0 >/dev/null 2>&1
); then
  pass "msw installed"
else
  fail "msw missing"
fi

# --------------------------------------------------
# Final lint
# --------------------------------------------------

echo
echo "--- Final lint ---"

if (
  cd "$FRONTEND" &&
  npm run lint -- --max-warnings=0
); then
  pass "Final lint passed"
else
  fail "Final lint failed"
fi

# --------------------------------------------------
# Final production build
# --------------------------------------------------

echo
echo "--- Final production build ---"

if (
  cd "$FRONTEND" &&
  npm run build
); then
  pass "Final production build passed"
else
  fail "Final production build failed"
fi

# --------------------------------------------------
# Git status
# --------------------------------------------------

echo
echo "--- Git status ---"

git -C "$REPO_ROOT" status --short

# --------------------------------------------------
# Summary
# --------------------------------------------------

echo
echo "========================================"
echo " Phase 3 Summary"
echo "========================================"
echo "PASS: $PASS"
echo "FAIL: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "Phase 3 automated verification PASSED."
  echo
  echo "Manual browser verification:"
  echo "  1. Start: cd frontend && npm run dev"
  echo "  2. Open /workers"
  echo "  3. Open /experiments"
  echo "  4. Confirm MSW requests return HTTP 200"
  echo "  5. Confirm worker, experiment, generation and candidate data render"
  exit 0
else
  echo
  echo "Phase 3 verification FAILED."
  exit 1
fi
