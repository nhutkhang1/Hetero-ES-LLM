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

echo "=== HeteroES Phase 3.3 - Mock Coordinator Check ==="
echo

# --------------------------------------------------
# Locate repository
# --------------------------------------------------

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"
MOCKS="$FRONTEND/src/mocks"

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
# Required files
# --------------------------------------------------

echo
echo "--- Required MSW files ---"

required_files=(
  "$MOCKS/browser.ts"
  "$MOCKS/handlers.ts"
  "$FRONTEND/public/mockServiceWorker.js"
  "$FRONTEND/src/main.tsx"
)

for file in "${required_files[@]}"; do
  if [[ -s "$file" ]]; then
    pass "${file#$REPO_ROOT/} exists"
  else
    fail "Missing or empty: ${file#$REPO_ROOT/}"
  fi
done

# --------------------------------------------------
# MSW dependency
# --------------------------------------------------

echo
echo "--- MSW dependency ---"

if (
  cd "$FRONTEND" &&
  npm ls msw --depth=0 >/dev/null 2>&1
); then
  pass "msw is installed"
else
  fail "msw dependency is missing"
fi

# --------------------------------------------------
# browser.ts
# --------------------------------------------------

echo
echo "--- MSW browser setup ---"

BROWSER="$MOCKS/browser.ts"

if grep -Fq "setupWorker" "$BROWSER"; then
  pass "browser.ts uses setupWorker"
else
  fail "browser.ts does not use setupWorker"
fi

if grep -Fq "handlers" "$BROWSER"; then
  pass "browser.ts registers handlers"
else
  fail "browser.ts does not register handlers"
fi

# --------------------------------------------------
# handlers.ts
# --------------------------------------------------

echo
echo "--- Mock Coordinator handlers ---"

HANDLERS="$MOCKS/handlers.ts"

routes=(
  "/api/v1/workers"
  "/api/v1/experiments"
  "/api/v1/experiments/:experimentId/generations"
  "/api/v1/generations/:generationId/candidates"
)

for route in "${routes[@]}"; do
  if grep -Fq "$route" "$HANDLERS"; then
    pass "Handler exists: GET $route"
  else
    fail "Missing handler: GET $route"
  fi
done

# --------------------------------------------------
# Mock data references
# --------------------------------------------------

echo
echo "--- Handler data sources ---"

mock_exports=(
  "mockWorkers"
  "mockExperiments"
  "mockGenerations"
  "mockCandidates"
)

for mock in "${mock_exports[@]}"; do
  if grep -Fq "$mock" "$HANDLERS"; then
    pass "handlers.ts references $mock"
  else
    fail "handlers.ts does not reference $mock"
  fi
done

# --------------------------------------------------
# main.tsx integration
# --------------------------------------------------

echo
echo "--- main.tsx integration ---"

MAIN="$FRONTEND/src/main.tsx"

if grep -Fq "import.meta.env.DEV" "$MAIN"; then
  pass "MSW is restricted to development mode"
else
  fail "Development-mode guard not found"
fi

if grep -Fq "./mocks/browser" "$MAIN"; then
  pass "main.tsx loads mocks/browser"
else
  fail "main.tsx does not load mocks/browser"
fi

if grep -Fq "worker.start" "$MAIN"; then
  pass "main.tsx starts the MSW worker"
else
  fail "worker.start() not found in main.tsx"
fi

# --------------------------------------------------
# ESLint generated-worker ignore
# --------------------------------------------------

echo
echo "--- ESLint configuration ---"

ESLINT_CONFIG="$FRONTEND/eslint.config.js"

if grep -Fq "public/mockServiceWorker.js" "$ESLINT_CONFIG"; then
  pass "Generated MSW worker is ignored by ESLint"
else
  fail "public/mockServiceWorker.js is not ignored by ESLint"
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
# Git status
# --------------------------------------------------

echo
echo "--- Git status ---"
git -C "$REPO_ROOT" status --short

# --------------------------------------------------
# Summary
# --------------------------------------------------

echo
echo "=== Summary ==="
echo "PASS: $PASS"
echo "FAIL: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "Phase 3.3 automated checks passed."
  echo
  echo "Manual browser verification:"
  echo '  fetch("/api/v1/workers").then(r => r.json()).then(console.log)'
  echo '  fetch("/api/v1/experiments").then(r => r.json()).then(console.log)'
  echo
  echo "Expected:"
  echo "  - MSW logs GET requests"
  echo "  - HTTP 200 OK"
  echo "  - Mock JSON is returned"
  exit 0
else
  echo
  echo "Phase 3.3 checks failed."
  exit 1
fi
