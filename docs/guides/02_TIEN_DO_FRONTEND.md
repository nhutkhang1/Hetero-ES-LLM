# 02 — Tiến độ frontend

> Đây là bản tổng hợp theo quá trình phát triển đã ghi nhận. Codex phải đối chiếu với Git và code hiện tại trước khi coi là sự thật cuối cùng.

## Phase 1 — Frontend Bootstrap

Trạng thái ghi nhận: **Hoàn thành và đã merge**.

Nội dung: Vite, React, TypeScript, ESLint, `.nvmrc`, lint/build.

Squash commit đã ghi nhận:

```text
f30b1eb chore(frontend): scaffold React TypeScript application (#1)
```

## Phase 2 — Application Shell + Routing

Trạng thái ghi nhận: **Hoàn thành và đã merge**.

Các route:

```text
/ -> /dashboard
/dashboard
/workers
/experiments
/events
/artifacts
* -> 404
```

File chính: `src/app/router.tsx`, `src/components/layout/AppLayout.tsx`, các page tương ứng.

Squash commit:

```text
0d2f2ce feat(frontend): add application shell and routing (#2)
```

## Phase 3 — Data Architecture + Mock Coordinator

Trạng thái ghi nhận: **Hoàn thành và đã merge**.

Mục tiêu:
- domain types;
- mock data;
- mock Coordinator bằng MSW;
- API service;
- TanStack Query hooks;
- chứng minh page -> query -> service -> HTTP -> MSW flow.

Domain type chính: Worker, Experiment, Generation, Candidate, Attempt, Event, Artifact, Metric.

Endpoint mock ban đầu:

```text
GET /api/v1/workers
GET /api/v1/experiments
GET /api/v1/experiments/:experimentId/generations
GET /api/v1/generations/:generationId/candidates
```

Service/hook chính:

```text
getWorkers / useWorkers
getExperiments / useExperiments
getGenerations / useGenerations
getCandidates / useCandidates
```

MSW chỉ bật ở development.

Squash commit:

```text
0ffbdea feat(frontend): add coordinator data architecture (#3)
```

## Phase 4 — Workers / Cluster UI

Trạng thái ghi nhận: **Hoàn thành và đã merge vào develop**.

Sub-phase:

```text
4.1 Cluster Summary
4.2 Worker List
4.3 Worker Detail
4.4 Shared UI States
4.5 Final Verification
```

Feature-branch commits từng ghi nhận:

```text
81ee408 feat(frontend): add cluster worker summary
560b0ff feat(frontend): add worker table and css for it
5116f2a feat(frontend): add worker detail view
23ff2a2 refactor(frontend): add shared worker UI states
e929681 test(frontend): add phase 4 worker cluster verification
```

Thành phần chính dự kiến:

```text
src/components/workers/
  ClusterSummary.tsx
  WorkerTable.tsx
  WorkerStatusBadge.tsx
  AdmissionBadge.tsx
src/pages/
  WorkersPage.tsx
  WorkerDetailPage.tsx
src/components/common/
  LoadingState.tsx
  ErrorState.tsx
  EmptyState.tsx
src/hooks/
  useWorkers.ts
  useWorker.ts
```

Route:

```text
/workers
/workers/:workerId
```

Mock API detail:

```text
GET /api/v1/workers/:workerId
```

Verification script dự kiến:

```text
scripts/checks/frontend/check_phase4.sh
```

## Phase 5 — Experiment / Generation / Candidate UI

Trạng thái: **Đang thực hiện**.

Branch dự kiến:

```text
feat/experiment-monitoring-ui
```

### 5.1 Experiment List + Summary

Đã được triển khai theo quá trình làm việc.

Dự kiến có:

```text
src/components/experiments/
  ExperimentSummary.tsx
  ExperimentTable.tsx
  ExperimentStatusBadge.tsx
```

`ExperimentsPage` dùng `useExperiments()`.

### 5.2 Experiment Detail

Đã được triển khai theo quá trình làm việc.

Dự kiến có:

```text
src/pages/ExperimentDetailPage.tsx
src/hooks/useExperiment.ts
```

Route:

```text
/experiments/:experimentId
```

Mock API:

```text
GET /api/v1/experiments/:experimentId
```

### 5.3 Generation List + Progress

Đã được triển khai và UI đã được kiểm tra bằng browser.

Dự kiến có:

```text
src/components/generations/
  GenerationStatusBadge.tsx
  GenerationProgress.tsx
  GenerationTable.tsx
```

`ExperimentDetailPage` gọi `useExperiment(experimentId)` và `useGenerations(experimentId)`. Cả hai hook phải được gọi trước conditional return.

UI từng hiển thị:
- gen-001: 16/16 = 100%
- gen-003: 11/16 ≈ 69%

### 5.4 Candidate List + Status

**Cần xác minh lại.**

Theo kế hoạch phải có:

```text
src/components/candidates/
  CandidateStatusBadge.tsx
  CandidateTable.tsx
src/pages/
  GenerationDetailPage.tsx
src/hooks/
  useGeneration.ts
```

Route dự kiến:

```text
/experiments/:experimentId/generations/:generationId
```

Mock API detail generation:

```text
GET /api/v1/experiments/:experimentId/generations/:generationId
```

`GenerationDetailPage` dùng `useGeneration(experimentId, generationId)` và `useCandidates(generationId)`.

Tuy nhiên lần kiểm tra gần nhất, người phát triển báo không thấy `src/components/candidates/`. Vì vậy không được coi 5.4 là hoàn thành cho đến khi Codex kiểm tra repository.

Lệnh xác minh:

```bash
find frontend/src/components -maxdepth 2 -type f | sort
find frontend/src/pages -maxdepth 1 -type f | sort
grep -R "GenerationDetailPage\|CandidateTable\|CandidateStatusBadge" frontend/src
```

### 5.5 Candidate / Attempt Detail

Trạng thái ghi nhận: **chưa xác nhận hoàn thành**.

Thiết kế dự kiến:

```text
src/pages/CandidateDetailPage.tsx
src/components/attempts/AttemptDetail.tsx
src/hooks/useCandidate.ts
src/hooks/useAttempt.ts
src/api/attempts.ts
src/mocks/data/attempts.ts
```

Route dự kiến:

```text
/experiments/:experimentId/generations/:generationId/candidates/:candidateId
```

Đây mới là hướng triển khai được đề xuất. Codex phải kiểm tra thực tế trước khi kết luận.

### 5.6 Shared states / presentation

Chưa xác nhận bắt đầu.

### 5.7 Final Verification

Chưa thực hiện.

## Phase 6 — Metrics / Failures / Events / Artifacts

Chưa thực hiện.

Mục tiêu dự kiến: timing, network, sync metrics, failure/event views, artifact/config/model-version views.

## Phase 7 — Real API Integration + Testing + Polish

Chưa thực hiện.

Mục tiêu dự kiến: thay MSW bằng Coordinator API thật, kiểm thử sâu hơn, UI/UX polish, component/integration tests nếu phù hợp, xử lý lỗi/loading tốt hơn.

## Lưu ý về script check

Các shell script trong `scripts/checks/frontend/` là milestone verification scripts, không phải unit test framework. Không gọi chúng là Vitest/Jest/component tests nếu repository chưa cài các framework đó.
