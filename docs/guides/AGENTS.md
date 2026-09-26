# Hướng dẫn cho Codex — HeteroES

## Mục đích

Đây là điểm vào ngắn gọn để Codex hiểu cách đọc và làm việc với repository HeteroES. Không xem file này là tài liệu kiến trúc đầy đủ. Trước khi sửa code, hãy đọc các tài liệu trong `docs/codex/`.

## Thứ tự đọc bắt buộc

1. `docs/codex/README.md`
2. `docs/codex/00_TONG_QUAN_DU_AN.md`
3. `docs/codex/01_KIEN_TRUC_VA_BIEN_GIOI.md`
4. `docs/codex/02_TIEN_DO_FRONTEND.md`
5. `docs/codex/03_HUONG_DAN_DOC_GIT_LOG.md`
6. `docs/codex/04_CHAN_DOAN_VA_KE_HOACH_TIEP_THEO.md`

Sau đó phải tự kiểm tra codebase và Git trước khi kết luận trạng thái hiện tại.

## Quy tắc làm việc

- Không suy đoán một phase đã hoàn thành chỉ vì tài liệu nói như vậy. Phải đối chiếu với `git status`, `git branch --show-current`, `git log --oneline --decorate --graph --all`, các file thực tế trong `frontend/src`, và các script trong `scripts/checks/frontend`.
- Không tự ý thay đổi kiến trúc hoặc thêm dependency nếu chưa chứng minh cần thiết.
- Frontend chỉ giao tiếp với Coordinator API. Không gọi trực tiếp Worker, SQLite, Ray, PyTorch hoặc model runtime.
- Dữ liệu trong `frontend/src/mocks/` là dữ liệu mô phỏng. Không trình bày chúng như benchmark hoặc kết quả thực nghiệm thật.
- Dashboard/frontend là lớp quan sát và điều khiển mỏng. Correctness logic thuộc Coordinator.
- Ưu tiên thay đổi nhỏ, có thể kiểm tra, có commit scope rõ ràng.
- Trước khi commit frontend, tối thiểu chạy `npm run lint` và `npm run build`.
- Nếu phase có verification script tương ứng, phải chạy script đó.
- Khi tài liệu tiến độ không khớp code/Git, ưu tiên code + Git làm nguồn sự thật và báo rõ chênh lệch.
- Không tự tạo số liệu benchmark giả để lấp chỗ trống.
- Không tự đánh dấu phase hoàn thành nếu chưa kiểm tra đủ acceptance criteria.

## Quy ước Git

- `main`: stable/release.
- `develop`: integration.
- Feature branch ngắn hạn: `feat/*`.
- Fix: `fix/*`.
- Refactor: `refactor/*`.
- Test/check: `test/*`.
- Docs: `docs/*`.
- PR feature -> `develop`.
- Dự án đang ưu tiên Squash and merge để giữ history `develop` gọn.
- Sau squash merge, local feature branch có thể cần `git branch -D` vì commit ancestry không còn giống branch cũ; chỉ force-delete sau khi xác nhận squash commit đã có trên `develop`.

## Trạng thái cần xác minh ngay

Theo tiến độ được ghi nhận gần nhất:
- Phase 1: hoàn thành.
- Phase 2: hoàn thành.
- Phase 3: hoàn thành, đã có Mock Coordinator qua MSW.
- Phase 4: hoàn thành và đã merge vào `develop`.
- Phase 5: đang thực hiện.
- Phase 5.1–5.3: đã được triển khai theo quá trình làm việc.
- Phase 5.4: có dấu hiệu chưa hoàn chỉnh vì `src/components/candidates/` từng được phát hiện là chưa tồn tại.
- Phase 5.5: chưa nên xem là hoàn thành cho đến khi kiểm tra code thực tế.

Codex phải xác minh các điểm trên bằng repository hiện tại trước khi tiếp tục.
