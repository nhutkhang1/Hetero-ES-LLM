#!/usr/bin/env bash

# HeteroES - Phase 2 Frontend Shell Check
# Run from anywhere inside the Git repository.

set -u

PASS=0
FAIL=0
WARN=0

green="\033[32m"
red="\033[31m"
yellow="\033[33m"
reset="\033[0m"

pass() {
  echo -e "${green}[PASS]${reset} $1"
  PASS=$((PASS + 1))
}

fail() {
  echo -e "${red}[FAIL]${reset} $1"
  FAIL=$((FAIL + 1))
}

warn() {
  echo -e "${yellow}[WARN]${reset} $1"
  WARN=$((WARN + 1))
}

echo "=== HeteroES Phase 2 Check ==="
echo

# 1. Find repository root
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [[ -z "$REPO_ROOT" ]]; then
  echo "[FAIL] Not inside a Git repository."
  exit 1
fi

FRONTEND="$REPO_ROOT/frontend"

pass "Git repository found: $REPO_ROOT"

# 2. Check branch
BRANCH="$(git -C "$REPO_ROOT" branch --show-current)"

if [[ "$BRANCH" == "feat/frontend-shell" ]]; then
  pass "Current branch is feat/frontend-shell"
else
  warn "Current branch is '$BRANCH' (expected: feat/frontend-shell)"
fi

# 3. Check frontend directory
if [[ -d "$FRONTEND" ]]; then
  pass "frontend/ directory exists"
else
  fail "frontend/ directory not found"
  exit 1
fi

# 4. Required files
required_files=(
  "src/app/router.tsx"
  "src/components/layout/AppLayout.tsx"
  "src/pages/DashboardPage.tsx"
  "src/pages/WorkersPage.tsx"
  "src/pages/ExperimentsPage.tsx"
  "src/pages/EventsPage.tsx"
  "src/pages/ArtifactsPage.tsx"
  "src/pages/NotFoundPage.tsx"
  "src/main.tsx"
  "src/index.css"
  "package.json"
  "package-lock.json"
)

echo
echo "--- Required files ---"

for file in "${required_files[@]}"; do
  if [[ -f "$FRONTEND/$file" ]]; then
    pass "$file"
  else
    fail "Missing: $file"
  fi
done

# 5. React Router dependency
echo
echo "--- React Router ---"

if (
  cd "$FRONTEND" &&
  npm ls react-router --depth=0 >/dev/null 2>&1
); then
  pass "react-router is installed"
else
  fail "react-router is not installed"
fi

# 6. Basic route declarations
echo
echo "--- Routes ---"

ROUTER="$FRONTEND/src/app/router.tsx"

if [[ -f "$ROUTER" ]]; then
  routes=(
    "/dashboard"
    "/workers"
    "/experiments"
    "/events"
    "/artifacts"
  )

  for route in "${routes[@]}"; do
    if grep -Fq "$route" "$ROUTER"; then
      pass "Route declared: $route"
    else
      fail "Route missing: $route"
    fi
  done

  if grep -Eq 'path=["'\'']\*["'\'']' "$ROUTER"; then
    pass "404 wildcard route exists"
  else
    fail "404 wildcard route is missing"
  fi

  if grep -Fq "Navigate" "$ROUTER" && grep -Fq "/dashboard" "$ROUTER"; then
    pass "Root redirect to dashboard appears configured"
  else
    warn "Could not confirm root redirect to /dashboard"
  fi
else
  fail "Cannot inspect router.tsx"
fi

# 7. AppLayout essentials
echo
echo "--- App layout ---"

LAYOUT="$FRONTEND/src/components/layout/AppLayout.tsx"

if [[ -f "$LAYOUT" ]]; then
  if grep -Fq "NavLink" "$LAYOUT"; then
    pass "Sidebar navigation uses NavLink"
  else
    fail "NavLink not found in AppLayout"
  fi

  if grep -Fq "Outlet" "$LAYOUT"; then
    pass "AppLayout contains Outlet"
  else
    fail "Outlet not found in AppLayout"
  fi
fi

# 8. Check generated folders are ignored
echo
echo "--- Git ignore ---"

if git -C "$REPO_ROOT" check-ignore frontend/node_modules >/dev/null 2>&1; then
  pass "frontend/node_modules is ignored"
else
  fail "frontend/node_modules is NOT ignored"
fi

if git -C "$REPO_ROOT" check-ignore frontend/dist >/dev/null 2>&1; then
  pass "frontend/dist is ignored"
else
  fail "frontend/dist is NOT ignored"
fi

# 9. Lint
echo
echo "--- npm run lint ---"

if (
  cd "$FRONTEND" &&
  npm run lint
); then
  pass "Lint passed"
else
  fail "Lint failed"
fi

# 10. Production build
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

# 11. Git status
echo
echo "--- Git status ---"
git -C "$REPO_ROOT" status --short

echo
echo "=== Summary ==="
echo -e "${green}PASS:${reset} $PASS"
echo -e "${yellow}WARN:${reset} $WARN"
echo -e "${red}FAIL:${reset} $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo -e "${green}Phase 2 automated checks passed.${reset}"
  echo "Manual browser check remaining:"
  echo "  /dashboard /workers /experiments /events /artifacts /abc"
  exit 0
else
  echo
  echo -e "${red}Phase 2 is not ready yet.${reset}"
  exit 1
fi
