# Bộ ngữ cảnh dành cho Codex — HeteroES

Thư mục này cung cấp ngữ cảnh bền vững để coding agent có thể đọc codebase mà không phụ thuộc vào lịch sử hội thoại ngoài repository.

## Các tài liệu

- `00_TONG_QUAN_DU_AN.md`: mục tiêu hệ thống, phạm vi, phần cứng, stack và ý nghĩa của HeteroES.
- `01_KIEN_TRUC_VA_BIEN_GIOI.md`: Coordinator/Worker, state machine, API boundary và vai trò frontend.
- `02_TIEN_DO_FRONTEND.md`: các phase frontend đã làm và trạng thái Phase 5.
- `03_HUONG_DAN_DOC_GIT_LOG.md`: cách dùng Git để xác minh tiến độ.
- `04_CHAN_DOAN_VA_KE_HOACH_TIEP_THEO.md`: điểm cần kiểm tra, rủi ro và thứ tự công việc tiếp theo.
- `05_PROMPT_KHOI_DONG_CODEX.md`: prompt đề xuất để Codex bắt đầu audit.

## Nguồn sự thật

Khi có mâu thuẫn, ưu tiên:

1. Code đang checkout + test/check thực tế.
2. Git history và PR/squash commits.
3. Tài liệu thiết kế v3 trong repository.
4. Các file trong `docs/codex/`.
5. Giả định của agent.

Nếu tài liệu nói “đã hoàn thành” nhưng file cần thiết không tồn tại hoặc lint/build thất bại, xem phase đó là chưa hoàn thành.
