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

echo "=== HeteroES Phase 3.6 - Page Integration Check ==="
echo

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"
PAGES="$FRONTEND/src/pages"

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
# Required pages
# --------------------------------------------------

echo
echo "--- Required pages ---"

required_pages=(
  "WorkersPage.tsx"
  "ExperimentsPage.tsx"
)

for file in "${required_pages[@]}"; do
  if [[ -s "$PAGES/$file" ]]; then
    pass "$file exists"
  else
    fail "Missing or empty: $file"
  fi
done

# --------------------------------------------------
# WorkersPage integration
# --------------------------------------------------

echo
echo "--- WorkersPage integration ---"

WORKERS_PAGE="$PAGES/WorkersPage.tsx"

if grep -Fq "useWorkers" "$WORKERS_PAGE"; then
  pass "WorkersPage uses useWorkers"
else
  fail "WorkersPage does not use useWorkers"
fi

if grep -Fq "isPending" "$WORKERS_PAGE"; then
  pass "WorkersPage handles loading state"
else
  fail "WorkersPage loading state missing"
fi

if grep -Fq "isError" "$WORKERS_PAGE"; then
  pass "WorkersPage handles error state"
else
  fail "WorkersPage error state missing"
fi

if grep -Fq "workers.map" "$WORKERS_PAGE"; then
  pass "WorkersPage renders worker data"
else
  fail "WorkersPage does not render worker data"
fi

if grep -Fq "worker.profile.gpuName" "$WORKERS_PAGE"; then
  pass "WorkersPage renders GPU profile"
else
  fail "WorkersPage GPU profile rendering missing"
fi

# --------------------------------------------------
# ExperimentsPage integration
# --------------------------------------------------

echo
echo "--- ExperimentsPage integration ---"

EXPERIMENTS_PAGE="$PAGES/ExperimentsPage.tsx"

if grep -Fq "useExperiments" "$EXPERIMENTS_PAGE"; then
  pass "ExperimentsPage uses useExperiments"
else
  fail "ExperimentsPage does not use useExperiments"
fi

if grep -Fq "useGenerations" "$EXPERIMENTS_PAGE"; then
  pass "ExperimentsPage uses useGenerations"
else
  fail "ExperimentsPage does not use useGenerations"
fi

if grep -Fq "useCandidates" "$EXPERIMENTS_PAGE"; then
  pass "ExperimentsPage uses useCandidates"
else
  fail "ExperimentsPage does not use useCandidates"
fi

if grep -Fq "experimentsQuery.isPending" "$EXPERIMENTS_PAGE"; then
  pass "ExperimentsPage handles experiment loading"
else
  fail "ExperimentsPage experiment loading state missing"
fi

if grep -Fq "experimentsQuery.isError" "$EXPERIMENTS_PAGE"; then
  pass "ExperimentsPage handles experiment errors"
else
  fail "ExperimentsPage experiment error state missing"
fi

if grep -Fq "generationsQuery" "$EXPERIMENTS_PAGE"; then
  pass "ExperimentsPage handles generation query"
else
  fail "Generation query integration missing"
fi

if grep -Fq "candidatesQuery" "$EXPERIMENTS_PAGE"; then
  pass "ExperimentsPage handles candidate query"
else
  fail "Candidate query integration missing"
fi

# --------------------------------------------------
# Architecture boundary
# --------------------------------------------------

echo
echo "--- Architecture boundary ---"

if grep -R -q 'mocks/data' "$PAGES/WorkersPage.tsx" "$PAGES/ExperimentsPage.tsx"; then
  fail "Pages import mock data directly"
else
  pass "Pages do not import mock data directly"
fi

if grep -R -q 'fetch(' "$PAGES/WorkersPage.tsx" "$PAGES/ExperimentsPage.tsx"; then
  fail "Pages call fetch() directly"
else
  pass "Pages do not call fetch() directly"
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
  echo "Phase 3.6 page integration checks passed."
  echo
  echo "Manual browser verification remaining:"
  echo "  /workers"
  echo "  /experiments"
  echo
  echo "Expected:"
  echo "  - Workers page renders mock worker data"
  echo "  - Experiments page renders experiments, generations, and candidates"
  echo "  - MSW requests return HTTP 200"
  exit 0
else
  echo
  echo "Phase 3.6 page integration checks failed."
  exit 1
fi
