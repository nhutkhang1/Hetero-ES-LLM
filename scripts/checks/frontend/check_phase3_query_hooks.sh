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

echo "=== HeteroES Phase 3.5 - TanStack Query Check ==="
echo

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"
HOOKS="$FRONTEND/src/hooks"
PROVIDERS="$FRONTEND/src/app/providers.tsx"
MAIN="$FRONTEND/src/main.tsx"

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
# Dependency
# --------------------------------------------------

echo
echo "--- TanStack Query dependency ---"

if (
  cd "$FRONTEND" &&
  npm ls @tanstack/react-query --depth=0 >/dev/null 2>&1
); then
  pass "@tanstack/react-query is installed"
else
  fail "@tanstack/react-query is missing"
fi

# --------------------------------------------------
# Provider
# --------------------------------------------------

echo
echo "--- Query provider ---"

if [[ -s "$PROVIDERS" ]]; then
  pass "src/app/providers.tsx exists"
else
  fail "src/app/providers.tsx is missing"
fi

if grep -Fq "QueryClient" "$PROVIDERS"; then
  pass "QueryClient is configured"
else
  fail "QueryClient not found"
fi

if grep -Fq "QueryClientProvider" "$PROVIDERS"; then
  pass "QueryClientProvider is configured"
else
  fail "QueryClientProvider not found"
fi

if grep -Fq "AppProviders" "$PROVIDERS"; then
  pass "AppProviders component exists"
else
  fail "AppProviders component missing"
fi

# --------------------------------------------------
# main.tsx integration
# --------------------------------------------------

echo
echo "--- main.tsx integration ---"

if grep -Fq "./app/providers" "$MAIN"; then
  pass "main.tsx imports AppProviders"
else
  fail "main.tsx does not import AppProviders"
fi

if grep -Fq "<AppProviders>" "$MAIN"; then
  pass "Application is wrapped with AppProviders"
else
  fail "AppProviders wrapper not found in main.tsx"
fi

# --------------------------------------------------
# Required hooks
# --------------------------------------------------

echo
echo "--- Query hooks ---"

required_hooks=(
  "useWorkers.ts"
  "useExperiments.ts"
  "useGenerations.ts"
  "useCandidates.ts"
)

for file in "${required_hooks[@]}"; do
  if [[ -s "$HOOKS/$file" ]]; then
    pass "$file exists"
  else
    fail "Missing or empty: $file"
  fi
done

# --------------------------------------------------
# useQuery usage
# --------------------------------------------------

echo
echo "--- useQuery usage ---"

for file in "${required_hooks[@]}"; do
  if grep -Fq "useQuery" "$HOOKS/$file"; then
    pass "$file uses useQuery"
  else
    fail "$file does not use useQuery"
  fi
done

# --------------------------------------------------
# API service integration
# --------------------------------------------------

echo
echo "--- API service integration ---"

if grep -Fq "getWorkers" "$HOOKS/useWorkers.ts"; then
  pass "useWorkers uses getWorkers"
else
  fail "useWorkers does not use getWorkers"
fi

if grep -Fq "getExperiments" "$HOOKS/useExperiments.ts"; then
  pass "useExperiments uses getExperiments"
else
  fail "useExperiments does not use getExperiments"
fi

if grep -Fq "getGenerations" "$HOOKS/useGenerations.ts"; then
  pass "useGenerations uses getGenerations"
else
  fail "useGenerations does not use getGenerations"
fi

if grep -Fq "getCandidates" "$HOOKS/useCandidates.ts"; then
  pass "useCandidates uses getCandidates"
else
  fail "useCandidates does not use getCandidates"
fi

# --------------------------------------------------
# Query keys
# --------------------------------------------------

echo
echo "--- Query keys ---"

if grep -Fq '["workers"]' "$HOOKS/useWorkers.ts"; then
  pass "Workers query key configured"
else
  fail "Workers query key missing"
fi

if grep -Fq '["experiments"]' "$HOOKS/useExperiments.ts"; then
  pass "Experiments query key configured"
else
  fail "Experiments query key missing"
fi

if grep -Fq '["generations", experimentId]' "$HOOKS/useGenerations.ts"; then
  pass "Generations query key includes experimentId"
else
  fail "Generations query key is incorrect"
fi

if grep -Fq '["candidates", generationId]' "$HOOKS/useCandidates.ts"; then
  pass "Candidates query key includes generationId"
else
  fail "Candidates query key is incorrect"
fi

# --------------------------------------------------
# Enabled guards
# --------------------------------------------------

echo
echo "--- Conditional queries ---"

if grep -Fq "enabled: Boolean(experimentId)" \
  "$HOOKS/useGenerations.ts"; then
  pass "Generations query has experimentId guard"
else
  fail "Generations query guard missing"
fi

if grep -Fq "enabled: Boolean(generationId)" \
  "$HOOKS/useCandidates.ts"; then
  pass "Candidates query has generationId guard"
else
  fail "Candidates query guard missing"
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
  echo "Phase 3.5 TanStack Query checks passed."
  exit 0
else
  echo
  echo "Phase 3.5 TanStack Query checks failed."
  exit 1
fi
