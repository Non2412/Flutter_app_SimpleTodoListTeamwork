# 📋 Flutter To-Do List App with Notifications

แอปพลิเคชัน To-Do List ที่สร้างด้วย Flutter พร้อมฟีเจอร์การแจ้งเตือน ระบบล็อกอิน และการจัดการรายการงานอย่างครบครัน

## ✨ ฟีเจอร์หลัก

### 🔐 ระบบการจัดการผู้ใช้
- **เข้าสู่ระบบ** - ล็อกอินด้วยชื่อผู้ใช้และรหัสผ่าน
- **สมัครสมาชิก** - ลงทะเบียนผู้ใช้ใหม่พร้อมการตรวจสอบข้อมูล
- **ลืมรหัสผ่าน** - ระบบรีเซ็ตรหัสผ่าน (จำลอง)
- **ออกจากระบบ** - ล็อกเอาท์และกลับไปหน้าเข้าสู่ระบบ

### 📝 การจัดการรายการงาน
- **เพิ่มรายการใหม่** - สร้างงานใหม่พร้อมหัวข้อและรายละเอียด
- **ตั้งเวลาแจ้งเตือน** - กำหนดวันที่และเวลาที่ต้องการให้แจ้งเตือน
- **ลบรายการ** - ลบงานที่เสร็จสิ้นแล้ว
- **แสดงรายการทั้งหมด** - ดูรายการงานในรูปแบบที่เป็นระเบียบ

### 🔔 ระบบแจ้งเตือน
- **การแจ้งเตือนแบบ Local** - แจ้งเตือนเมื่อถึงเวลาที่กำหนด
- **การแจ้งเตือนแบบ Real-time** - แจ้งเตือนภายในแอป
- **การตั้งเวลาอัตโนมัติ** - จัดการเวลาแจ้งเตือนด้วย Timezone

### 🎨 UI/UX ที่สวยงาม
- **ไอคอนตามเวลา** - แสดงดวงอาทิตย์ (6:00-17:59) และดวงจันทร์ (18:00-5:59)
- **พื้นหลังแบบไล่สี** - ใช้สีไล่โทนน้ำเงิน
- **การ์ดที่มีเงา** - UI ที่ทันสมัยและใช้งานง่าย
- **รองรับภาษาไทย** - ทุกข้อความเป็นภาษาไทย

## 🛠️ เทคโนโลยีที่ใช้

### 📱 Flutter Framework
- **flutter/material.dart** - Material Design UI
- **StatefulWidget** - การจัดการ State

### 📦 Packages ที่ใช้
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^17.2.4
  timezone: ^0.9.4
  intl: ^0.19.0
```

### 🔧 ฟีเจอร์เฉพาะ
- **Local Notifications** - แจ้งเตือนแบบ Local
- **DateTime Picker** - เลือกวันที่และเวลา
- **Form Validation** - ตรวจสอบข้อมูลป้อนเข้า
- **Navigation Management** - จัดการการเปลี่ยนหน้า

## 📁 โครงสร้างไฟล์

```
lib/
├── main.dart           # หน้าหลักและระบบแจ้งเตือน
├── login.dart          # หน้าเข้าสู่ระบบและ UserStorage
├── register.dart       # หน้าสมัครสมาชิก
├── forgot_password.dart # หน้าลืมรหัสผ่าน
└── theme.dart          # ธีมและสไตล์

assets/
└── images/
    ├── background.png  # พื้นหลังแอป
    ├── sun.png         # ไอคอนดวงอาทิตย์
    └── moon.png        # ไอคอนดวงจันทร์
```

## 🚀 การติดตั้งและใช้งาน

### ความต้องการระบบ
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio หรือ VS Code
- Android/iOS Device หรือ Emulator

### ขั้นตอนการติดตั้ง

1. **Clone Repository**
```bash
git clone <repository-url>
cd flutter-todo-app
```

2. **ติดตั้ง Dependencies**
```bash
flutter pub get
```

3. **เพิ่มไฟล์ Assets**
```
- สร้างโฟลเดอร์ assets/images/
- เพิ่มไฟล์รูปภาพ: background.png, sun.png, moon.png
```

4. **ปรับแต่ง pubspec.yaml**
```yaml
flutter:
  assets:
    - assets/images/
```

5. **รันแอปพลิเคชัน**
```bash
flutter run
```

## 📱 การใช้งานแอป

### 1. เข้าสู่ระบบ
- เปิดแอปจะเจอหน้าเข้าสู่ระบบ
- กรอกชื่อผู้ใช้และรหัสผ่าน
- หรือคลิก "สมัครสมาชิก" เพื่อสร้างบัญชีใหม่

### 2. สมัครสมาชิก
- กรอกข้อมูล: ชื่อผู้ใช้, อีเมล, รหัสผ่าน
- ระบบจะตรวจสอบความถูกต้องของข้อมูล
- หากสำเร็จจะกลับไปหน้าเข้าสู่ระบบ

### 3. จัดการรายการงาน
- คลิกปุ่ม "เพิ่ม" เพื่อเพิ่มรายการใหม่
- กรอกหัวข้อ และรายละเอียด (ถ้ามี)
- ตั้งเวลาแจ้งเตือน (ถ้าต้องการ)
- คลิกไอคอนถังขยะเพื่อลบรายการ

### 4. ระบบแจ้งเตือน
- เมื่อถึงเวลาที่กำหนด ระบบจะแจ้งเตือนอัตโนมัติ
- รองรับการแจ้งเตือนแม้แอปปิดอยู่ (Android/iOS)

## 🔧 การกำหนดค่า

### Android Permissions
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

### iOS Permissions
```xml
<!-- ios/Runner/Info.plist -->
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

## 🎯 ฟีเจอร์พิเศษ

### ไอคอนตามเวลา
- **6:00-17:59** = ดวงอาทิตย์ 🌞
- **18:00-5:59** = ดวงจันทร์ 🌙
- **ไม่มีเวลา** = Checkbox ⬜

### การจัดเก็บข้อมูล
- ใช้ `UserStorage` class สำหรับจัดเก็บข้อมูลผู้ใช้
- ข้อมูลเก็บใน Memory (สำหรับ Demo)
- ใน Production ควรใช้ SQLite หรือ SharedPreferences

## 🐛 การแก้ไขปัญหาที่พบบ่อย

### ปัญหาการแจ้งเตือน
```dart
// ตรวจสอบการตั้งค่า Notification
await NotificationService().init();
```

### ปัญหาการโหลดรูปภาพ
```dart
// ใช้ errorBuilder เพื่อแสดงไอคอนสำรอง
errorBuilder: (context, error, stackTrace) {
  return const Icon(Icons.wb_sunny, size: 28);
}
```

### ปัญหา Context หลัง async
```dart
// เก็บ Navigator ก่อน async operation
final navigator = Navigator.of(context);
await someAsyncFunction();
navigator.pop();
```

## 🤝 การพัฒนาต่อ

### ฟีเจอร์ที่สามารถเพิ่มเติม
- [ ] ระบบหมวดหมู่งาน
- [ ] การแก้ไขรายการ
- [ ] ระบบ Priority
- [ ] การซิงค์กับ Cloud
- [ ] การแบ่งปันรายการ
- [ ] ธีมมืด/สว่าง
- [ ] การส่งออกข้อมูล

### การปรับปรุง Database
```dart
// เปลี่ยนจาก Memory เป็น SQLite
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Implementation ของ SQLite
}
```

## 📄 License

MIT License - ใช้งานได้อย่างเสรี

## 👥 ผู้พัฒนา
1. นาย สิทธิรัช พรหมคุณ 6612732135
2. นาย นพนันท์ เกษอินทร์ 6612732115
3. นาย ศุภชัย วิเชียร 6612732130
4. นาย เกียรติศักดิ์ ช่างทอง 6612732104
