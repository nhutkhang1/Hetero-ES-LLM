# 01 — Kiến trúc và biên giới hệ thống

## 1. Coordinator

Coordinator sở hữu:
- experiment state;
- generation state;
- candidate logical state;
- worker admission;
- scheduling;
- lease issuance;
- result validation;
- model-version publication;
- checkpoint / ledger coordination;
- metrics và event cần thiết cho UI.

Frontend không được thay Coordinator quyết định candidate hợp lệ hay không.

## 2. Worker

Worker có profile/capability như GPU name, VRAM, throughput, safe chunk size, heartbeat và admission status.

Admission status:
- `INELIGIBLE`
- `ELIGIBLE_BUT_NOT_BENEFICIAL`
- `ADMITTED_LIMITED`
- `ADMITTED`

## 3. Scheduler ID

- `B0_FASTEST`
- `B1_STATIC_WAVE`
- `B2_STATIC_PROPORTIONAL`
- `B3_GREEDY_DYNAMIC`
- `H0_FULL_SYSTEM`

Frontend chỉ hiển thị/quan sát policy do Coordinator công bố; không tự scheduling.

## 4. Candidate lifecycle

```text
PENDING -> LEASED -> RUNNING -> COMMITTED
```

Khi fail hoặc lease expiry, candidate có thể quay lại `PENDING`.

Stale result, duplicate result và wrong model version là result/attempt event, không tự động là terminal candidate state nếu domain contract không quy định.

## 5. Candidate descriptor

Các trường cốt lõi:
- `experimentId`
- `generationId`
- `candidateId`
- `attemptId`
- `modelVersion`
- `seed`
- `noiseRecipeHash`
- `batchIds`
- `generationConfigHash`
- `leaseToken`
- `leaseDeadline`

Frontend type hiện tại có thêm `workerId?` và `status`.

## 6. Attempt

Attempt đại diện cho một lần thực thi cụ thể của candidate.

Type frontend hiện tại:
- experimentId
- generationId
- candidateId
- attemptId
- workerId
- modelVersion
- leaseToken
- status
- startedAt?
- completedAt?
- errorType?

Quan hệ quan trọng:

```text
Candidate = logical work item
Attempt   = một lần execution cụ thể của Candidate
```

Không nên giả định candidate `PENDING` đã có một attempt thực tế chỉ vì type Candidate đang chứa `attemptId`.

## 7. Result contract ở mức thiết kế

Thiết kế dự kiến result có thể chứa:
- worker_id
- generation_id
- candidate_id
- attempt_id
- model_version
- lease_token
- status
- reward_sum
- prompt_count
- token_count
- timings
- restore_status
- error_type

Không tự thêm các field này vào frontend type chỉ vì tài liệu thiết kế có đề cập; chỉ thêm khi API contract cần và backend thống nhất.

## 8. Synchronization modes

- `FULL_SYNC_EVERY_GENERATION`
- `REPLAY_ONLY`
- `REPLAY_WITH_PERIODIC_RESYNC`

## 9. Timing categories

- load
- perturb
- rollout
- verifier
- restore
- update
- transfer/reload
- coordination

## 10. Artifact của một run

- config
- manifests
- events
- candidates
- workers
- generations
- checkpoints
- evaluation outputs

## 11. Frontend boundary

Hợp lệ:

```text
React component -> custom query hook -> API service -> Coordinator HTTP/JSON
```

Development hiện tại:

```text
Coordinator HTTP/JSON -> MSW handler -> mock data
```

Không hợp lệ:

```text
Page -> mock data trực tiếp
Page -> SQLite trực tiếp
Page -> Worker trực tiếp
Page -> PyTorch trực tiếp
Page -> Ray trực tiếp
```

## 12. UI scope

Bốn nhóm thông tin chính:
1. Cluster / admission.
2. Generation / candidate.
3. Timing / network / failure.
4. Artifact / config / model version.

Các page định hướng:
- Dashboard
- Workers
- Experiments
- Events
- Artifacts

Dashboard là supporting product shell; core correctness nằm ở Coordinator/runtime.
