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

echo "=== HeteroES Phase 3.4 - API Service Check ==="
echo

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"
API_DIR="$FRONTEND/src/api"

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
# Required API files
# --------------------------------------------------

echo
echo "--- API service files ---"

required_files=(
  "client.ts"
  "workers.ts"
  "experiments.ts"
  "generations.ts"
  "candidates.ts"
)

for file in "${required_files[@]}"; do
  if [[ -s "$API_DIR/$file" ]]; then
    pass "$file exists and is not empty"
  else
    fail "Missing or empty: $file"
  fi
done

# --------------------------------------------------
# API client
# --------------------------------------------------

echo
echo "--- API client ---"

CLIENT="$API_DIR/client.ts"

if grep -Fq "VITE_API_BASE_URL" "$CLIENT"; then
  pass "client.ts supports VITE_API_BASE_URL"
else
  fail "VITE_API_BASE_URL not found in client.ts"
fi

if grep -Fq "apiGet" "$CLIENT"; then
  pass "apiGet helper exists"
else
  fail "apiGet helper missing"
fi

if grep -Fq "response.ok" "$CLIENT"; then
  pass "HTTP error handling exists"
else
  fail "response.ok check missing"
fi

if grep -Fq "fetch(" "$CLIENT"; then
  pass "API client uses fetch"
else
  fail "fetch() not found in client.ts"
fi

# --------------------------------------------------
# API service functions
# --------------------------------------------------

echo
echo "--- API service functions ---"

if grep -Fq "getWorkers" "$API_DIR/workers.ts" &&
   grep -Fq "/api/v1/workers" "$API_DIR/workers.ts"; then
  pass "Workers API service configured"
else
  fail "Workers API service is incomplete"
fi

if grep -Fq "getExperiments" "$API_DIR/experiments.ts" &&
   grep -Fq "/api/v1/experiments" "$API_DIR/experiments.ts"; then
  pass "Experiments API service configured"
else
  fail "Experiments API service is incomplete"
fi

if grep -Fq "getGenerations" "$API_DIR/generations.ts" &&
   grep -Fq "/api/v1/experiments/" "$API_DIR/generations.ts" &&
   grep -Fq "/generations" "$API_DIR/generations.ts"; then
  pass "Generations API service configured"
else
  fail "Generations API service is incomplete"
fi

if grep -Fq "getCandidates" "$API_DIR/candidates.ts" &&
   grep -Fq "/api/v1/generations/" "$API_DIR/candidates.ts" &&
   grep -Fq "/candidates" "$API_DIR/candidates.ts"; then
  pass "Candidates API service configured"
else
  fail "Candidates API service is incomplete"
fi

# --------------------------------------------------
# Domain type usage
# --------------------------------------------------

echo
echo "--- Domain type usage ---"

declare -A type_checks=(
  ["workers.ts"]="Worker"
  ["experiments.ts"]="Experiment"
  ["generations.ts"]="Generation"
  ["candidates.ts"]="Candidate"
)

for file in "${!type_checks[@]}"; do
  type="${type_checks[$file]}"

  if grep -Fq "$type" "$API_DIR/$file"; then
    pass "$file references $type"
  else
    fail "$file does not reference $type"
  fi
done

# --------------------------------------------------
# Prevent direct mock imports
# --------------------------------------------------

echo
echo "--- Architecture boundary ---"

if grep -R -q 'mocks/data' "$API_DIR"; then
  fail "API layer imports mock data directly"
else
  pass "API layer does not import mock data directly"
fi

# --------------------------------------------------
# Lint
# --------------------------------------------------

echo
echo "--- npm run lint ---"

if (
  cd "$FRONTEND" &&
  npm run lint -- --max-warnings=0
); then
  pass "Lint passed with zero warnings"
else
  fail "Lint failed or produced warnings"
fi

# --------------------------------------------------
# Build
# --------------------------------------------------

echo
echo "--- npm run build ---"

if (
  cd "$FRONTEND" &&
  npm run build
); then
  pass "Production build passed"
else
  fail "Production build failed"
fi

# --------------------------------------------------
# Summary
# --------------------------------------------------

echo
echo "=== Summary ==="
echo "PASS: $PASS"
echo "FAIL: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "Phase 3.4 API service checks passed."
  exit 0
else
  echo
  echo "Phase 3.4 API service checks failed."
  exit 1
fi
