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
MOCK_DATA="$FRONTEND/src/mocks/data"

echo "=== HeteroES Phase 3 - Mock Data Check ==="
echo

# Branch
BRANCH="$(git -C "$REPO_ROOT" branch --show-current)"

if [[ "$BRANCH" == "feat/mock-coordinator" ]]; then
  pass "Current branch is feat/mock-coordinator"
else
  fail "Expected feat/mock-coordinator, found: $BRANCH"
fi

# Required files
echo
echo "--- Mock data files ---"

required_files=(
  "workers.ts"
  "experiments.ts"
  "generations.ts"
  "candidates.ts"
)

for file in "${required_files[@]}"; do
  if [[ -s "$MOCK_DATA/$file" ]]; then
    pass "$file exists and is not empty"
  else
    fail "Missing or empty: $file"
  fi
done

# Ensure mock data is not ignored by Git
echo
echo "--- Git ignore ---"

if git -C "$REPO_ROOT" check-ignore \
  frontend/src/mocks/data/workers.ts >/dev/null 2>&1; then
  fail "frontend/src/mocks/data is still ignored"
else
  pass "frontend/src/mocks/data is trackable"
fi

# Expected exports
echo
echo "--- Mock exports ---"

declare -A exports=(
  ["workers.ts"]="mockWorkers"
  ["experiments.ts"]="mockExperiments"
  ["generations.ts"]="mockGenerations"
  ["candidates.ts"]="mockCandidates"
)

for file in "${!exports[@]}"; do
  expected="${exports[$file]}"

  if grep -Fq "$expected" "$MOCK_DATA/$file"; then
    pass "$file exports $expected"
  else
    fail "$file does not contain $expected"
  fi
done

# Domain type usage
echo
echo "--- Type usage ---"

declare -A types=(
  ["workers.ts"]="Worker"
  ["experiments.ts"]="Experiment"
  ["generations.ts"]="Generation"
  ["candidates.ts"]="Candidate"
)

for file in "${!types[@]}"; do
  expected="${types[$file]}"

  if grep -Fq "$expected" "$MOCK_DATA/$file"; then
    pass "$file references $expected"
  else
    fail "$file does not reference $expected"
  fi
done

# Lint
echo
echo "--- npm run lint ---"

if (cd "$FRONTEND" && npm run lint); then
  pass "Lint passed"
else
  fail "Lint failed"
fi

# Build
echo
echo "--- npm run build ---"

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
  echo
  echo "Phase 3 mock data checks passed."
  exit 0
else
  echo
  echo "Phase 3 mock data checks failed."
  exit 1
fi
