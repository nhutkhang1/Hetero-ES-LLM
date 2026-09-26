# 05 — Prompt khởi động Codex

Có thể dùng prompt dưới đây sau khi đặt bộ tài liệu này vào repository.

```text
Hãy audit repository HeteroES hiện tại trước khi sửa code.

Trước tiên:
1. Đọc AGENTS.md và toàn bộ docs/codex/ theo thứ tự được chỉ định.
2. Chạy git status, git branch --show-current và git log --oneline --decorate --graph --all.
3. Kiểm tra cây file frontend/src và scripts/checks/frontend.
4. Đối chiếu code thực tế với docs/codex/02_TIEN_DO_FRONTEND.md.
5. Không coi một phase là DONE nếu Git/file/build không chứng minh được.
6. Không sửa code trong bước audit đầu tiên.

Sau audit, hãy báo cáo ngắn:
- branch hiện tại;
- working tree sạch hay không;
- Phase 1–4 có bằng chứng gì;
- Phase 5.1–5.5 mục nào DONE/PARTIAL/MISSING;
- các file hoặc route bị thiếu;
- lint/build hiện tại;
- chẩn đoán quan trọng nhất.

Đặc biệt kiểm tra xem Phase 5.4 đã có đầy đủ:
- CandidateStatusBadge.tsx
- CandidateTable.tsx
- GenerationDetailPage.tsx
- useGeneration.ts
- generation detail route
- mock generation-detail endpoint

Nếu Phase 5.4 chưa hoàn chỉnh, hãy đề xuất patch nhỏ nhất để hoàn thiện 5.4 trước khi tiếp tục 5.5.

Không thêm dependency mới, không thay kiến trúc, không tạo benchmark giả.
```
