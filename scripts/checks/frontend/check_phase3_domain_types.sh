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

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"
TYPES="$FRONTEND/src/types"

echo "=== HeteroES Phase 3 - Domain Types Check ==="
echo

# Branch
BRANCH="$(git -C "$REPO_ROOT" branch --show-current)"

if [[ "$BRANCH" == "feat/mock-coordinator" ]]; then
  pass "Current branch is feat/mock-coordinator"
else
  fail "Expected feat/mock-coordinator, found: $BRANCH"
fi

# Required type files
required_files=(
  worker.ts
  experiment.ts
  generation.ts
  candidate.ts
  attempt.ts
  event.ts
  artifact.ts
  metric.ts
)

echo
echo "--- Domain type files ---"

for file in "${required_files[@]}"; do
  if [[ -f "$TYPES/$file" ]]; then
    pass "$file exists"
  else
    fail "Missing: $file"
  fi
done

# Detect accidental nested directory
if [[ -d "$TYPES/src" ]]; then
  fail "Unexpected nested directory: src/types/src"
else
  pass "No nested src/types/src directory"
fi

# Dependencies
echo
echo "--- Phase 3 dependencies ---"

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

# Lint
echo
echo "--- Lint ---"

if (cd "$FRONTEND" && npm run lint); then
  pass "Lint passed"
else
  fail "Lint failed"
fi

# Build
echo
echo "--- Build ---"

if (cd "$FRONTEND" && npm run build); then
  pass "Production build passed"
else
  fail "Production build failed"
fi

echo
echo "=== Summary ==="
echo "PASS: $PASS"
echo "FAIL: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
  echo "Phase 3 domain type checks passed."
  exit 0
else
  echo "Phase 3 domain type checks failed."
  exit 1
fi
