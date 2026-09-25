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

echo "=========================================="
echo " HeteroES Frontend - Phase 4 Final Check"
echo "=========================================="
echo

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"

pass "Git repository found: $REPO_ROOT"

# --------------------------------------------------
# Branch
# --------------------------------------------------

BRANCH="$(git -C "$REPO_ROOT" branch --show-current)"

if [[ "$BRANCH" == "feat/worker-cluster-ui" ]]; then
  pass "Current branch is feat/worker-cluster-ui"
else
  fail "Expected feat/worker-cluster-ui, found: $BRANCH"
fi

# --------------------------------------------------
# 4.1 Cluster Summary
# --------------------------------------------------

echo
echo "--- 4.1 Cluster Summary ---"

CLUSTER="$FRONTEND/src/components/workers/ClusterSummary.tsx"

if [[ -s "$CLUSTER" ]]; then
  pass "ClusterSummary.tsx exists"
else
  fail "ClusterSummary.tsx missing"
fi

if grep -Fq "totalWorkers" "$CLUSTER"; then
  pass "Total worker calculation exists"
else
  fail "Total worker calculation missing"
fi

if grep -Fq "onlineWorkers" "$CLUSTER"; then
  pass "Online worker calculation exists"
else
  fail "Online worker calculation missing"
fi

if grep -Fq "admittedWorkers" "$CLUSTER"; then
  pass "Admission summary exists"
else
  fail "Admission summary missing"
fi

if grep -Fq "totalVramMb" "$CLUSTER"; then
  pass "Total VRAM calculation exists"
else
  fail "Total VRAM calculation missing"
fi

# --------------------------------------------------
# 4.2 Worker List
# --------------------------------------------------

echo
echo "--- 4.2 Worker List ---"

worker_components=(
  "WorkerTable.tsx"
  "WorkerStatusBadge.tsx"
  "AdmissionBadge.tsx"
)

for file in "${worker_components[@]}"; do
  path="$FRONTEND/src/components/workers/$file"

  if [[ -s "$path" ]]; then
    pass "$file exists"
  else
    fail "$file missing"
  fi
done

TABLE="$FRONTEND/src/components/workers/WorkerTable.tsx"

if grep -Fq "WorkerStatusBadge" "$TABLE"; then
  pass "WorkerTable uses WorkerStatusBadge"
else
  fail "WorkerTable does not use WorkerStatusBadge"
fi

if grep -Fq "AdmissionBadge" "$TABLE"; then
  pass "WorkerTable uses AdmissionBadge"
else
  fail "WorkerTable does not use AdmissionBadge"
fi

if grep -Fq "safeChunkSize" "$TABLE"; then
  pass "WorkerTable displays safe chunk size"
else
  fail "Safe chunk size missing"
fi

if grep -Fq "throughputTokensPerSecond" "$TABLE"; then
  pass "WorkerTable displays throughput"
else
  fail "Worker throughput missing"
fi

# --------------------------------------------------
# 4.3 Worker Detail
# --------------------------------------------------

echo
echo "--- 4.3 Worker Detail ---"

DETAIL="$FRONTEND/src/pages/WorkerDetailPage.tsx"
HOOK="$FRONTEND/src/hooks/useWorker.ts"
API="$FRONTEND/src/api/workers.ts"
ROUTER="$FRONTEND/src/app/router.tsx"
HANDLERS="$FRONTEND/src/mocks/handlers.ts"

if [[ -s "$DETAIL" ]]; then
  pass "WorkerDetailPage.tsx exists"
else
  fail "WorkerDetailPage.tsx missing"
fi

if [[ -s "$HOOK" ]]; then
  pass "useWorker.ts exists"
else
  fail "useWorker.ts missing"
fi

if grep -Fq "getWorker" "$API"; then
  pass "Worker API contains getWorker"
else
  fail "getWorker API function missing"
fi

if grep -Fq "/workers/:workerId" "$ROUTER"; then
  pass "Worker detail route exists"
else
  fail "Worker detail route missing"
fi

if grep -Fq "/api/v1/workers/:workerId" "$HANDLERS"; then
  pass "Mock worker-detail endpoint exists"
else
  fail "Mock worker-detail endpoint missing"
fi

if grep -Fq "Worker not found" "$HANDLERS"; then
  pass "Worker 404 response exists"
else
  fail "Worker 404 response missing"
fi

if grep -Fq "retry: false" "$HOOK"; then
  pass "Worker detail disables retry for errors"
else
  fail "retry: false missing from useWorker"
fi

# --------------------------------------------------
# 4.4 Shared UI States
# --------------------------------------------------

echo
echo "--- 4.4 Shared UI States ---"

common_components=(
  "LoadingState.tsx"
  "ErrorState.tsx"
  "EmptyState.tsx"
)

for file in "${common_components[@]}"; do
  path="$FRONTEND/src/components/common/$file"

  if [[ -s "$path" ]]; then
    pass "$file exists"
  else
    fail "$file missing"
  fi
done

WORKERS_PAGE="$FRONTEND/src/pages/WorkersPage.tsx"

if grep -Fq "LoadingState" "$WORKERS_PAGE"; then
  pass "WorkersPage uses LoadingState"
else
  fail "WorkersPage does not use LoadingState"
fi

if grep -Fq "ErrorState" "$WORKERS_PAGE"; then
  pass "WorkersPage uses ErrorState"
else
  fail "WorkersPage does not use ErrorState"
fi

if grep -Fq "EmptyState" "$TABLE"; then
  pass "WorkerTable uses EmptyState"
else
  fail "WorkerTable does not use EmptyState"
fi

if grep -Fq "LoadingState" "$DETAIL"; then
  pass "WorkerDetailPage uses LoadingState"
else
  fail "WorkerDetailPage does not use LoadingState"
fi

if grep -Fq "ErrorState" "$DETAIL"; then
  pass "WorkerDetailPage uses ErrorState"
else
  fail "WorkerDetailPage does not use ErrorState"
fi

# --------------------------------------------------
# Architecture boundary
# --------------------------------------------------

echo
echo "--- Architecture Boundary ---"

if grep -R -q 'mocks/data' \
  "$FRONTEND/src/pages/WorkersPage.tsx" \
  "$FRONTEND/src/pages/WorkerDetailPage.tsx"; then
  fail "Worker pages import mock data directly"
else
  pass "Worker pages do not import mock data directly"
fi

if grep -R -q 'fetch(' \
  "$FRONTEND/src/pages/WorkersPage.tsx" \
  "$FRONTEND/src/pages/WorkerDetailPage.tsx"; then
  fail "Worker pages call fetch() directly"
else
  pass "Worker pages respect API/query boundary"
fi

# --------------------------------------------------
# Lint
# --------------------------------------------------

echo
echo "--- Final Lint ---"

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
echo "--- Final Build ---"

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
echo "--- Git Status ---"

git -C "$REPO_ROOT" status --short

# --------------------------------------------------
# Summary
# --------------------------------------------------

echo
echo "=========================================="
echo " Phase 4 Summary"
echo "=========================================="
echo "PASS: $PASS"
echo "FAIL: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "Phase 4 automated verification PASSED."
  echo
  echo "Manual browser verification:"
  echo "  /workers"
  echo "  /workers/worker-01"
  echo "  /workers/worker-02"
  echo "  /workers/not-exist"
  echo
  echo "Expected:"
  echo "  - Cluster summary renders correctly"
  echo "  - Worker capability table renders correctly"
  echo "  - Worker details return HTTP 200"
  echo "  - Unknown worker returns HTTP 404"
  echo "  - Loading/Error/Empty states behave correctly"
  exit 0
else
  echo
  echo "Phase 4 verification FAILED."
  exit 1
fi
