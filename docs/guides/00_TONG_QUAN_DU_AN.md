# 00 — Tổng quan dự án HeteroES

## 1. Tên và mục tiêu

Tên hệ thống ngắn: **HeteroES**. Tên đầy đủ theo ngữ cảnh nghiên cứu: **HeteroES-LLM**.

Mục tiêu là xây dựng một hệ thống đáng tin cậy để thực hiện **ES-based LLM post-training** trên một cụm GPU nhỏ, không đồng nhất, sử dụng phần cứng phổ thông.

Bài toán chính:
- phân phối candidate evaluation lên worker có năng lực khác nhau;
- quản lý lease/attempt/result an toàn;
- tránh duplicate hoặc stale result;
- theo dõi model version;
- phục hồi trạng thái khi lỗi;
- đo thời gian, network cost và synchronization cost;
- đánh giá scheduler khác nhau trên cùng workload.

## 2. Phần cứng mục tiêu

- NVIDIA RTX 5070 Ti 16 GB.
- NVIDIA GTX 1660 Super 6 GB.
- Hai máy Linux kết nối LAN.

Mục tiêu là tận dụng worker yếu hơn nếu worker đó mang lại lợi ích thực tế, nhưng không bắt buộc mọi worker đều phải được nhận vào cluster.

## 3. Model và task ban đầu

- Model: `Qwen2.5-0.5B-Instruct`
- Task: `Countdown`

Đây là cấu hình khởi đầu, không phải ràng buộc kiến trúc vĩnh viễn.

## 4. Stack dự kiến

Core stack:
- Python
- FastAPI / HTTP
- SQLite với WAL
- PyTorch
- Transformers

Ray hoặc vLLM chỉ được đưa vào nếu có ADR/chứng cứ cho thấy cần thiết hoặc có lợi.

Frontend hiện tại:
- React
- TypeScript
- Vite
- React Router
- TanStack Query
- MSW để mô phỏng Coordinator API trước khi backend thật sẵn sàng

## 5. Hình dung hệ thống

```text
UI / CLI
   |
   v
Coordinator
   |    |  \--> Ledger / Checkpoint / Artifact state
   |
   +------ HTTP/API ------+
   |                      |
   v                      v
Worker A              Worker B
RTX 5070 Ti           GTX 1660 Super
```

Coordinator là control plane và source of truth của experiment.

Worker là execution plane: xin việc, nhận candidate descriptor, chạy perturbation/evaluation, gửi heartbeat và gửi result.

## 6. Vai trò frontend

Frontend không phải training engine. Vai trò của frontend:
- quan sát cluster;
- quan sát worker admission/capability;
- xem experiment;
- xem generation;
- xem candidate/attempt;
- xem event/failure;
- xem timing/network/sync metrics;
- xem artifact/config/model version.

Frontend phải lấy dữ liệu qua **Coordinator API**. Không đưa correctness logic của distributed runtime vào React.

## 7. Giai đoạn Mock Coordinator

Backend Coordinator thật chưa phải điều kiện để dựng frontend. Vì vậy frontend dùng:

```text
React Page
   |
TanStack Query
   |
API service
   |
HTTP request
   |
MSW handler
   |
Mock Coordinator data
```

MSW đóng vai Coordinator API giả.

Mục tiêu:
- chứng minh UI không phụ thuộc trực tiếp vào mock object;
- cố định sơ bộ API shape;
- kiểm tra page/query/service boundary;
- phát triển frontend trước backend;
- sau này thay MSW bằng FastAPI mà không phải viết lại page.

Dữ liệu mock chỉ phục vụ phát triển giao diện. Không xem là số liệu benchmark.
