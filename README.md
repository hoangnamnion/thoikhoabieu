# 📱 Ứng Dụng Thời Khóa Biểu Tuần iOS (Flutter + Cloud API)

Ứng dụng xem thời khóa biểu tuần tối ưu hóa cho iOS, giao diện phong cách Cupertino/Modern Glassmorphism, tự động đồng bộ từ **Cloud API** (không cần build lại app khi đổi lịch), hỗ trợ **Offline Cache** và **Thông báo nhắc giờ học**.

---

## ✨ Tính Năng Nổi Bật

1. **Đồng Bộ Cloud Tức Thì (No-Rebuild)**:
   - Dữ liệu lịch học được tải trực tiếp từ đường dẫn Cloud API (JSON).
   - Khi có thay đổi môn học, phòng học, chỉ cần chỉnh sửa file JSON trên Cloud, app sẽ tự cập nhật ngay khi mở hoặc kéo làm mới (Pull-to-refresh).
2. **Offline-First (Xem khi mất mạng)**:
   - Tự động lưu cache cục bộ vào thiết bị. Không có Internet vẫn xem được bình thường.
3. **2 Chế Độ Xem Linh Hoạt**:
   - **Tab Ngày (Thứ 2 ➔ Chủ Nhật)**: Hiển thị danh sách tiết học theo từng ngày, trạng thái *Đang học*, *Sắp diễn ra*, *Đã kết thúc*.
   - **Bảng Lưới Toàn Tuần (Weekly Matrix Grid)**: Xem toàn cảnh lịch học cả tuần trong 1 màn hình.
4. **Thông Báo Giờ Học Thông Minh**:
   - Nhắc nhở trước giờ học **30 phút**.
   - Thông báo chính xác **khi bắt đầu tiết học**.
5. **Cấu hình Nguồn Cloud trong App**:
   - Có màn hình Cài đặt cho phép dán bất kỳ URL JSON nào (GitHub Gist, Supabase, MockAPI, Cloudflare Worker, Google Sheet JSON).
   - Có nút Test kết nối trực tiếp.

---

## 📄 Cấu Trúc File JSON Cloud Chuẩn

Bạn có thể lưu file JSON này trên GitHub Gist, Cloudflare Worker, Supabase hoặc Hosting riêng:

```json
{
  "semester": "Học kỳ 1 (2026 - 2027)",
  "student_name": "Nguyễn Văn A",
  "updated_at": "2026-08-24T08:00:00Z",
  "schedule": [
    {
      "id": "mon_01",
      "day_of_week": 2,
      "subject_name": "Lập trình Ứng dụng Di động iOS",
      "room": "Phòng Lab A3-201",
      "teacher": "TS. Nguyễn Văn An",
      "start_time": "07:30",
      "end_time": "09:50",
      "color": "#4F46E5",
      "notes": "Mang theo laptop cá nhân"
    },
    {
      "id": "mon_02",
      "day_of_week": 2,
      "subject_name": "Cơ sở dữ liệu",
      "room": "Phòng B1-402",
      "teacher": "ThS. Trần Thị Mai",
      "start_time": "13:30",
      "end_time": "15:50",
      "color": "#0EA5E9",
      "notes": "Thực hành SQL"
    }
  ]
}
```

*Quy ước ngày (`day_of_week`): 2 = Thứ Hai, 3 = Thứ Ba, 4 = Thứ Tư, 5 = Thứ Năm, 6 = Thứ Sáu, 7 = Thứ Bảy, 8 = Chủ Nhật.*

---

## 🚀 Hướng Dẫn Tự Động Xuất File `.ipa` Qua GitHub Actions

Vì bạn đang dùng máy tính Windows, dự án đã được tích hợp sẵn quy trình CI/CD **GitHub Actions** (`.github/workflows/build_ipa.yml`) chạy trên máy ảo **macOS của GitHub** hoàn toàn miễn phí:

### Bước 1: Đẩy mã nguồn lên GitHub cá nhân
1. Tạo một repository mới trên GitHub (ví dụ: `thoi-khoa-bieu-ios`).
2. Mở terminal tại thư mục này và chạy:
   ```bash
   git init
   git add .
   git commit -m "feat: Khoi tao app Thoi Khoa Bieu iOS"
   git branch -M main
   git remote add origin <URL_GITHUB_CUA_BAN>
   git push -u origin main
   ```

### Bước 2: Tải file `.ipa`
1. Truy cập vào repository GitHub của bạn trên trình duyệt.
2. Bấm vào tab **Actions** ➔ Chọn workflow **Build iOS IPA**.
3. Khi workflow chạy xong (màu xanh lá ✅), cuộn xuống mục **Artifacts** và bấm tải file `ThoiKhoaBieu-iOS-IPA.zip`.
4. Giải nén bạn sẽ nhận được file **`ThoiKhoaBieu.ipa`**!

---

## 📲 Hướng Dẫn Cài Đặt File `.ipa` Vào iPhone

Bạn có thể cài đặt file `.ipa` vừa tải vào iPhone bằng các công cụ thông dụng sau:
- **TrollStore** (nếu máy hỗ trợ - cài vĩnh viễn không cần ký lại).
- **AltStore / SideStore** (Ký bằng Apple ID cá nhân miễn phí).
- **Sideloadly / 3uTools** (Cắm cáp nối iPhone với máy tính và kéo file `.ipa` vào).
- **Scarlet / Esign**.
