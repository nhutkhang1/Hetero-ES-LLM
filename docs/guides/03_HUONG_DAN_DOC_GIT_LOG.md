# 03 — Hướng dẫn Codex đọc Git để xác minh tiến độ

Mục tiêu là dùng Git như nguồn sự thật thay vì chỉ dựa vào ghi chú.

## 1. Branch và working tree

Từ repository root:

```bash
git status
git branch --show-current
git branch -a
```

Cần trả lời: đang ở branch nào, có thay đổi chưa commit không, remote branch nào còn tồn tại, `develop` local có theo kịp `origin/develop` không.

## 2. History tổng quát

```bash
git log --oneline --decorate --graph --all --max-count=80
```

Tìm các mốc:

```text
chore(frontend): scaffold React TypeScript application
feat(frontend): add application shell and routing
feat(frontend): add coordinator data architecture
feat(frontend): add worker cluster monitoring UI
```

Nếu Phase 5 chưa merge, commit Phase 5 thường nằm trên `feat/experiment-monitoring-ui`.

## 3. Riêng develop

```bash
git log develop --oneline --decorate --max-count=30
```

`develop` chứng minh các phase đã merge. Feature commit chưa merge không được xem là đã tích hợp.

## 4. Riêng branch hiện tại

```bash
git log --oneline --decorate develop..HEAD
```

Lệnh này cho biết commit trên feature branch nhưng chưa thuộc history `develop`.

## 5. Diff so với develop

```bash
git diff --stat develop...HEAD
git diff develop...HEAD -- frontend/src
```

Dùng để xác định branch đang thêm/sửa file nào và component nào thực sự tồn tại.

## 6. Squash merge và `git branch -d`

Feature branch có thể là:

```text
A - B - C - D
```

GitHub squash thành:

```text
A - S
```

Nội dung `S` có thể tương đương B+C+D nhưng commit ancestry khác. Vì vậy sau squash merge, `git branch -d feat/something` có thể báo branch chưa fully merged.

Trước khi dùng `git branch -D`:
1. `git switch develop`
2. `git pull origin develop`
3. xác nhận squash commit PR có trên `develop`
4. rồi mới force-delete local feature branch

## 7. Tìm commit Phase 5

```bash
git log --all --oneline --grep="experiment"
git log --all --oneline --grep="generation"
git log --all --oneline --grep="candidate"
git log --all --oneline --grep="attempt"
```

Không suy ra “5.4 hoàn thành” chỉ vì có commit tên generation detail. Phải kiểm tra file và build.

## 8. Kiểm tra file theo phase

```bash
find frontend/src/components/experiments -maxdepth 1 -type f -print
find frontend/src/components/generations -maxdepth 1 -type f -print
find frontend/src/components/candidates -maxdepth 1 -type f -print
find frontend/src/components/attempts -maxdepth 1 -type f -print
find frontend/src/pages -maxdepth 1 -type f -print | sort
find frontend/src/hooks -maxdepth 1 -type f -print | sort
find frontend/src/api -maxdepth 1 -type f -print | sort
```

## 9. Kiểm tra route

```bash
sed -n '1,260p' frontend/src/app/router.tsx
```

Tìm:

```text
/workers/:workerId
/experiments/:experimentId
/experiments/:experimentId/generations/:generationId
/experiments/:experimentId/generations/:generationId/candidates/:candidateId
```

Chỉ coi route tồn tại nếu code hiện tại thật sự khai báo.

## 10. Quality gate

Từ `frontend/`:

```bash
npm run lint
npm run build
```

Nếu phase có verification script, chạy script tương ứng.

Một phase không nên được đánh dấu hoàn thành nếu code không lint/build.

## 11. Dạng báo cáo mong muốn

Codex nên trả về bảng ngắn:

```text
Phase | Git evidence | File evidence | Build/check | Kết luận
1     | ...          | ...           | ...         | DONE
...
5.4   | ...          | missing ...   | ...         | PARTIAL
```

Nêu bằng chứng cụ thể, không chỉ kết luận.
