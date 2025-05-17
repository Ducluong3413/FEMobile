# assistantstroke

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# FEAiStrocke



flutter pub get


yaml :
        dependencies:
        flutter:
            sdk: flutter
        fl_chart: ^0.63.0  # Bạn có thể kiểm tra phiên bản mới nhất trên pub.dev





Thêm dependency vào pubspec.yaml:
yaml
Sao chép
Chỉnh sửa
dependencies:
  google_maps_flutter: ^2.5.0
Cấp quyền sử dụng GPS trên Android (AndroidManifest.xml):
xml
Sao chép
Chỉnh sửa
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>




 flutter pub add dio



 nếu chạy tren android thì hãy chuyển ip ở api_service.dart