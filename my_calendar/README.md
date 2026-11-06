# My Calendar – Ứng dụng quản lý lịch cá nhân

## 1. Giới thiệu

**My Calendar** là ứng dụng quản lý lịch cá nhân được xây dựng bằng Flutter. Ứng dụng giúp người dùng quản lý lịch trình, theo dõi sự kiện và công việc hằng ngày thông qua giao diện trực quan, đơn giản và dễ sử dụng.

Ứng dụng hỗ trợ tùy chỉnh giao diện sáng/tối, thay đổi màu chủ đạo và lưu trữ dữ liệu lịch trình để người dùng thuận tiện theo dõi các kế hoạch cá nhân.

## 2. Công nghệ sử dụng

- **Flutter:** Xây dựng giao diện ứng dụng đa nền tảng.
- **Dart:** Ngôn ngữ lập trình chính.
- **Material Design:** Thiết kế các thành phần giao diện.
- **SharedPreferences:** Lưu các thiết lập ứng dụng nếu được sử dụng trong dự án.
- **Cơ sở dữ liệu:** Thông qua `DatabaseService` để quản lý dữ liệu lịch trình.
- **Supabase:** Sử dụng nếu dự án đã tích hợp dịch vụ này.

## 3. Cấu trúc thư mục dự án

```text
my_app/
│
├── android/                       # Cấu hình nền tảng Android
├── ios/                           # Cấu hình nền tảng iOS
├── linux/                         # Cấu hình nền tảng Linux
├── macos/                         # Cấu hình nền tảng macOS
├── windows/                       # Cấu hình nền tảng Windows
├── web/                           # Cấu hình nền tảng Web
│
├── lib/
│   │
│   ├── main.dart                  # Điểm khởi chạy ứng dụng
│   │
│   ├── screens/
│   │   ├── app_shell.dart         # Khung giao diện chính
│   │   ├── home_screen.dart       # Màn hình trang chủ
│   │   ├── calendar_screen.dart   # Màn hình lịch
│   │   ├── tasks_screen.dart      # Màn hình công việc
│   │   └── settings_screen.dart   # Màn hình cài đặt
│   │
│   ├── models/
│   │   └── calendar_event.dart    # Mô hình dữ liệu sự kiện
│   │
│   ├── widgets/
│   │   ├── event_card.dart        # Thẻ hiển thị sự kiện
│   │   ├── app_sidebar.dart       # Sidebar của ứng dụng
│   │   ├── sidebar.dart           # Thanh điều hướng bên
│   │   ├── month_calendar.dart    # Lịch theo tháng
│   │   ├── add_event_form.dart    # Biểu mẫu thêm/sửa sự kiện
│   │   ├── sun_icon.dart           # Biểu tượng mặt trời tùy chỉnh
│   │   └── weather_card.dart      # Thẻ thông tin thời tiết
│   │
│   ├── services/
│   │   ├── database_service.dart  # Xử lý lưu và truy xuất dữ liệu
│   │   ├── theme_controller.dart  # Quản lý chế độ và màu giao diện
│   │   └── weather_service.dart   # Lấy dữ liệu thời tiết (nếu có)
│   │
│   └── theme/
│       └── app_theme.dart         # Khai báo cấu hình giao diện
│
├── test/
│   └── widget_test.dart           # Kiểm thử widget
│
├── assets/                        # Tài nguyên hình ảnh, biểu tượng (nếu có)
│
├── .gitignore                     # Các tệp không đưa lên Git
├── analysis_options.yaml           # Cấu hình phân tích mã Dart
├── pubspec.yaml                   # Khai báo thư viện và tài nguyên
├── pubspec.lock                   # Phiên bản thư viện đã khóa
└── README.md                      # Tài liệu dự án
```

**Chức năng các thư mục chính:**

- `screens/`: Chứa các màn hình chính của ứng dụng.
- `models/`: Định nghĩa cấu trúc dữ liệu và các thuộc tính của sự kiện.
- `widgets/`: Chứa những thành phần giao diện có thể tái sử dụng.
- `services/`: Xử lý nghiệp vụ, lưu trữ dữ liệu và kết nối các dịch vụ bên ngoài.
- `theme/`: Quản lý màu sắc, kiểu chữ và giao diện sáng/tối.
- `test/`: Chứa các bài kiểm thử.

## 4. Các chức năng chính

### 4.1. Trang chủ

- Hiển thị thông tin và lịch trình cần theo dõi.
- Tổng hợp các sự kiện trong ngày.
- Hiển thị thẻ thời tiết nếu dịch vụ thời tiết được cấu hình.

### 4.2. Quản lý lịch

- Xem lịch theo tháng.
- Chọn ngày để xem các sự kiện tương ứng.
- Chuyển đổi giữa các tháng.
- Thêm sự kiện mới.
- Chỉnh sửa hoặc xóa sự kiện.
- Quản lý thời gian, địa điểm, ghi chú và nhắc nhở của sự kiện nếu được hỗ trợ trong biểu mẫu.

### 4.3. Quản lý công việc

- Theo dõi danh sách công việc.
- Hỗ trợ quản lý các nhiệm vụ theo chức năng hiện có của ứng dụng.

### 4.4. Tùy chỉnh giao diện

- Chọn giao diện sáng (Light).
- Chọn giao diện tối (Dark).
- Sử dụng giao diện theo hệ thống (System).
- Thay đổi màu chủ đạo.
- Lưu thiết lập giao diện nếu cơ chế lưu đã được cấu hình.

### 4.5. Quản lý dữ liệu

- Lưu trữ và truy xuất dữ liệu thông qua `DatabaseService`.
- Hỗ trợ xóa toàn bộ dữ liệu lịch trình sau khi xác nhận.

## 5. Yêu cầu môi trường

Trước khi chạy dự án, cần cài đặt:

1. Flutter SDK.
2. Dart SDK tương thích với phiên bản Flutter đang sử dụng.
3. Android Studio hoặc Visual Studio Code.
4. Git (nếu cần tải mã nguồn từ kho Git).
5. Trình giả lập hoặc thiết bị chạy ứng dụng; riêng Windows cần môi trường phát triển desktop phù hợp.

Kiểm tra môi trường bằng lệnh:

```bash
flutter doctor
```

## 6. Cài đặt và chạy ứng dụng

### Bước 1: Mở thư mục dự án

```bash
cd my_app
```

### Bước 2: Cài đặt các thư viện

```bash
flutter pub get
```

### Bước 3: Kiểm tra lỗi mã nguồn

```bash
flutter analyze
```

Nếu có cảnh báo hoặc lỗi, hãy kiểm tra và xử lý trước khi phát hành ứng dụng.

### Bước 4: Chạy ứng dụng

Chạy trên thiết bị hoặc trình giả lập mặc định:

```bash
flutter run
```

Nếu muốn chạy trên Windows:

```bash
flutter run -d windows
```

Nếu muốn chạy trên Chrome:

```bash
flutter run -d chrome
```

Để xem danh sách thiết bị khả dụng:

```bash
flutter devices
```

### Bước 5: Tạo bản build

Build ứng dụng Windows:

```bash
flutter build windows
```

Build ứng dụng Android:

```bash
flutter build apk
```

Build ứng dụng Web:

```bash
flutter build web
```

## 7. Các lệnh Flutter thường dùng

| Lệnh | Chức năng |
|---|---|
| `flutter pub get` | Cài đặt thư viện |
| `flutter analyze` | Phân tích mã nguồn |
| `flutter test` | Chạy kiểm thử |
| `flutter devices` | Liệt kê thiết bị |
| `flutter run` | Chạy ứng dụng |
| `flutter clean` | Xóa các tệp build tạm |
| `flutter build apk` | Tạo bản build Android |
| `flutter build windows` | Tạo bản build Windows |

## 8. Định hướng phát triển

Một số tính năng có thể mở rộng trong tương lai:

- Đồng bộ lịch trình giữa nhiều thiết bị.
- Thông báo nhắc nhở sự kiện.
- Tìm kiếm và lọc sự kiện theo nội dung.
- Lặp lại sự kiện theo ngày, tuần hoặc tháng.
- Thống kê tiến độ hoàn thành công việc.
- Sao lưu và khôi phục dữ liệu.
- Cải thiện giao diện cho máy tính và thiết bị di động.

## 9. Tác giả

**My Calendar** – Dự án ứng dụng quản lý lịch cá nhân được phát triển bằng Flutter và Dart.

