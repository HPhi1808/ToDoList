# UTH SmartTasks 📝

**UTH SmartTasks** là ứng dụng quản lý công việc (To-Do List) hiện đại, được xây dựng bằng **Flutter**. Ứng dụng áp dụng kiến trúc **MVVM**, hỗ trợ **Offline-first** (hoạt động khi không có mạng) và đồng bộ dữ liệu thông minh.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green)
![State Management](https://img.shields.io/badge/State-Provider-orange)

## 📸 Screenshots

| Màn hình chính (Home) | Tạo Task mới (Add) | Chi tiết (Detail) |
|:---:|:---:|:---:|
| <img src="assets/images/screenshot_home.png" width="200"/> | <img src="assets/images/screenshot_add.png" width="200"/> | <img src="assets/images/screenshot_detail.png" width="200"/> |

## ✨ Tính năng chính

* **Đăng nhập Google:** Xác thực người dùng nhanh chóng qua Firebase Auth.
* **Offline-First:** Sử dụng **SQLite (Sqflite)** để lưu trữ dữ liệu cục bộ. App vẫn hoạt động mượt mà khi tắt mạng.
* **Quản lý Task:**
    * Xem danh sách công việc theo thẻ màu (dựa trên danh mục).
    * Thêm công việc mới.
    * Xem chi tiết công việc.
    * Xóa công việc.
* **Giao diện hiện đại:** UI được thiết kế sạch sẽ, trực quan.
* **Profile:** Xem thông tin người dùng và Đăng xuất.

## 🛠 Tech Stack

* **Framework:** Flutter
* **Ngôn ngữ:** Dart
* **Kiến trúc:** MVVM (Model - View - ViewModel)
* **State Management:** Provider
* **Local Database:** Sqflite (SQLite)
* **Authentication:** Firebase Auth & Google Sign-In
* **Networking:** Http (Kết nối REST API mock)

## 📂 Cấu trúc thư mục

```text
lib/
├── models/                # Các class dữ liệu (Task)
├── view_models/           # Logic nghiệp vụ (TaskViewModel)
├── services/              # Các dịch vụ bên ngoài (AuthService)
├── views/
│   ├── screens/           # Các màn hình chính (Home, Detail, Create...)
│   └── widgets/           # Các widget tái sử dụng (TaskItem...)
└── main.dart              # Khởi chạy ứng dụng & Cấu hình Provider