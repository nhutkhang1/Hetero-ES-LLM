# 04 — Chẩn đoán hiện tại và kế hoạch tiếp theo

## 1. Chẩn đoán sơ bộ

Các điểm dưới đây dựa trên tiến độ đã ghi nhận, chưa thay thế việc kiểm tra repository.

### A. Kiến trúc frontend đang đi đúng hướng

Pattern hiện tại:

```text
Page -> custom hook -> API service -> HTTP -> MSW mock Coordinator
```

Phù hợp để sau này thay MSW bằng FastAPI Coordinator. Không refactor sang page import mock data trực tiếp.

### B. Phase 4 được tổ chức tương đối tốt

Worker UI đã tách summary, table, badges, detail page, shared loading/error/empty state và verification script. Pattern này nên được tái sử dụng cho Experiment/Generation/Candidate.

### C. Phase 5 có nguy cơ lệch giữa “đã hướng dẫn” và “đã code”

Dấu hiệu rõ nhất: kế hoạch 5.4 yêu cầu `src/components/candidates/`, nhưng người phát triển sau đó báo không tìm thấy thư mục này.

Việc đầu tiên của Codex phải là **audit Phase 5**, không phải ngay lập tức viết thêm 5.5.

### D. Candidate và Attempt cần làm rõ domain contract

Type Candidate hiện tại có:

```text
attemptId: string
```

ngay cả với candidate `PENDING`.

Trong khi Attempt type yêu cầu:

```text
workerId: string
leaseToken: string
```

Candidate `PENDING` có thể chưa có worker/lease. Cần ghi nhận câu hỏi kiến trúc:

> `attemptId` có thực sự tồn tại từ lúc Candidate được tạo, hay chỉ xuất hiện khi lease/attempt bắt đầu?

Nếu backend contract sau này quy định attempt chỉ sinh ra khi candidate được leased, frontend type có thể cần `attemptId?: string` hoặc tách currentAttempt khỏi Candidate. Chưa thay đổi type trước khi có quyết định kiến trúc.

### E. Mock data chưa phủ mọi trạng thái

Generation mock từng có `gen-001` và `gen-003`, không có `gen-002`. Điều này không nhất thiết sai nhưng cần xác minh là chủ ý.

Candidate mock từng có COMMITTED, RUNNING, PENDING; chưa thấy LEASED. Có thể thêm sau để test UI nếu cần, không bắt buộc hiện tại.

### F. Một số status đang là `string`

`Experiment.status`, `Generation.status`, `Attempt.status` đang là `string`, trong khi Candidate dùng union type. Đây là điểm type-safety có thể cải thiện sau, nhưng không nên chặn Phase 5 nếu chưa gây lỗi.

## 2. Việc Codex nên làm ngay

### Bước 1 — Audit repository

```bash
git status
git branch --show-current
git log --oneline --decorate --graph --all --max-count=80
find frontend/src -maxdepth 3 -type f | sort
```

### Bước 2 — Audit Phase 5

Kiểm tra 5.1 đến 5.5. Với mỗi mục, xác minh file, route, hook/API, mock handler, abstraction boundary, lint/build.

### Bước 3 — Khôi phục phần thiếu của 5.4 trước

Nếu thiếu một trong các phần sau thì hoàn thiện 5.4 trước:

```text
CandidateStatusBadge.tsx
CandidateTable.tsx
GenerationDetailPage.tsx
useGeneration.ts
generation detail route
generation detail mock handler
```

Không nhảy sang 5.5 khi 5.4 chưa chạy end-to-end.

### Bước 4 — Browser smoke test 5.4

```text
/experiments -> exp-001 -> gen-003 -> candidate table
```

Test thêm:

```text
/experiments/exp-001/generations/not-exist
```

phải hiển thị ErrorState và không loading vô hạn.

### Bước 5 — Sau đó mới làm 5.5

5.5 mới thêm candidate detail API/hook/page, attempt mock/API/hook/component và candidate link. Trước khi thiết kế Attempt cần quyết định xử lý candidate PENDING.

## 3. Acceptance criteria dự kiến cho Phase 5

Phase 5 chỉ DONE khi:
- `/experiments` hoạt động;
- click experiment -> detail;
- detail hiển thị generation list;
- click generation -> detail;
- detail hiển thị candidate list;
- click candidate -> detail;
- candidate detail hiển thị descriptor/lease/attempt hợp lệ;
- invalid experiment/generation/candidate hiển thị ErrorState;
- empty list hiển thị EmptyState;
- không page nào import mock data trực tiếp;
- không page nào gọi `fetch()` trực tiếp nếu service abstraction đã tồn tại;
- `npm run lint` pass;
- `npm run build` pass;
- có final verification script Phase 5;
- browser smoke test pass.

## 4. Sau Phase 5

```text
Phase 6 — Metrics / Failures / Events / Artifacts
Phase 7 — Real Coordinator API Integration / Testing / UX polish
```

Không nên làm UI polish lớn trước khi flow domain và API boundary ổn định.

## 5. Dạng đề xuất thay đổi mong muốn

Mỗi đề xuất của Codex nên có:

```text
Vấn đề
Bằng chứng từ code/Git
Ảnh hưởng
Thay đổi nhỏ nhất cần làm
File sẽ sửa
Lệnh kiểm tra
```

Tránh rewrite lớn nếu không cần.
