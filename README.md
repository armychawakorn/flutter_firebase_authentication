# Flutter Authentication Project

โปรเจกต์นี้เป็นตัวอย่างการสร้างแอปพลิเคชัน Flutter ที่มีการ Authentication (การยืนยันตัวตนผู้ใช้) โดยใช้ Firebase Authentication ซึ่งประกอบด้วยหน้าจอหลักๆ ดังนี้:

1.  **หน้าหลัก (Home Screen)**
2.  **หน้าเข้าสู่ระบบ (Login Screen)**
3.  **หน้าสร้างบัญชี (Create Account Screen)**
4.  **หน้าลืมรหัสผ่าน (Forgot Password Screen)**
5. **Custom Text Field**

## โครงสร้างโปรเจกต์

```
flutter_firebase_authentication/
├── lib/
│   ├── custom_text_field.dart    # Reusable Text Field Widget
│   ├── views/
│   │   ├── create_account_screen.dart   # หน้าสร้างบัญชี
│   │   ├── forgot_password_screen.dart # หน้าลืมรหัสผ่าน
│   │   ├── home_screen.dart        # หน้าหลัก
│   │   └── login_screen.dart      # หน้าเข้าสู่ระบบ
│   ├── main.dart               # จุดเริ่มต้นของแอป
│   └── firebase_options.dart     # Firebase configuration (generated by FlutterFire CLI)
├── pubspec.yaml              # Dependencies
└── README.md                 # ไฟล์นี้
```

## คำอธิบายแต่ละหน้า

### 1. หน้าหลัก (Home Screen) - `home_screen.dart`

*   **`HomePage` (StatefulWidget)**: เป็นหน้าหลักของแอป
    *   **`_HomePageState`**: State ของ `HomePage`
        *   `_user`: ตัวแปรที่เก็บสถานะการ login ของผู้ใช้ (`null` = ยังไม่ได้ login, `User` object = login แล้ว).
        *   `initState()`: เรียก `_checkCurrentUser()` เมื่อหน้าจอถูกสร้างขึ้น.
        *   `_checkCurrentUser()`:
            *   ตรวจสอบว่ามี user ที่ login อยู่หรือไม่ โดยใช้ `FirebaseAuth.instance.currentUser`.
            *   ใช้ `FirebaseAuth.instance.authStateChanges().listen(...)` เพื่อ "ฟัง" การเปลี่ยนแปลงสถานะ authentication (login, logout). เมื่อมีการเปลี่ยนแปลง, listener จะ update `_user` และ rebuild UI.
        *   `_signOut()`: ทำการ sign out ผู้ใช้ โดยเรียก `FirebaseAuth.instance.signOut()` และ navigate ไปที่หน้า Login
        *   `build()`: สร้าง UI ของหน้าหลัก.
            *   `AppBar`: แสดง title และปุ่ม "Logout" (ถ้า user login อยู่).
            *   `_buildContent()`: เรียก function นี้เพื่อสร้าง content ตามสถานะ login.
        *   `_buildLoggedInContent()`: สร้าง UI เมื่อผู้ใช้ login แล้ว.
            *   แสดง Icon
            *   แสดงข้อความต้อนรับ, ชื่อ (หรือ email), และปุ่ม "Sign Out".
        *   `_buildLoggedOutContent()`: สร้าง UI เมื่อผู้ใช้ยังไม่ได้ login.
            *   แสดง Icon
            *   แสดงข้อความต้อนรับ, ปุ่ม "Login", และปุ่ม "Create Account".

### 2. หน้าเข้าสู่ระบบ (Login Screen) - `login_screen.dart`

*   **`LoginPage` (StatefulWidget)**: หน้าจอสำหรับให้ผู้ใช้ login.
    *   **`_LoginPageState`**: State ของ `LoginPage`
        *   `_emailController`, `_passwordController`: `TextEditingController` สำหรับรับ input email และ password.
        *   `build()`: สร้าง UI ของหน้า Login.
            *   `AppBar`: แสดง title "Login".
            *   ใช้ `CustomTextField` สำหรับ email และ password fields.
            *   มีปุ่ม "Login".
            *   มี `TextButton` "Forgot Password?" (ไปที่หน้า Forgot Password).
            *   มี `TextButton` "Don't have an account? Sign Up" (ไปที่หน้า Create Account).
        *   `_login()`: ทำการ login ผู้ใช้.
            *   ตรวจสอบ email และ password ว่าไม่ว่างเปล่า.
            *   แสดง loading indicator.
            *   เรียก `FirebaseAuth.instance.signInWithEmailAndPassword` เพื่อ sign in.
            *   ซ่อน loading indicator.
            *   ถ้า sign in สำเร็จ, navigate ไปที่หน้า Home.
            *   ถ้ามี error (เช่น `user-not-found`, `wrong-password`), แสดง error message.
        *   `_showErrorDialog()`: แสดง error dialog.

### 3. หน้าสร้างบัญชี (Create Account Screen) - `create_account_screen.dart`

*   **`CreateAccountPage` (StatelessWidget)**: หน้าจอสำหรับให้ผู้ใช้สร้างบัญชีใหม่.
    *   `_emailController`, `_passwordController`, `_confirmPasswordController`:  `TextEditingController`  สำหรับรับ input email, password, และ confirm password.
    *   `build()`: สร้าง UI ของหน้า Create Account.
        *   `AppBar`: แสดง title "Create Account".
        *   ใช้  `CustomTextField`  สำหรับ email, password, และ confirm password fields.
        *   มีปุ่ม "Create Account".
        *   มี  `TextButton`  "Already have an account? Sign In" (กลับไปที่หน้า Login).
    *   `_createAccount()`: ทำการสร้างบัญชีผู้ใช้ใหม่.
        *   ตรวจสอบ email, password, และ confirm password.
        *   แสดง loading indicator.
        *   เรียก  `FirebaseAuth.instance.createUserWithEmailAndPassword`  เพื่อสร้างบัญชี.
        *   ซ่อน loading indicator.
        *   ถ้าสร้างบัญชีสำเร็จ, แสดง success dialog และ navigate ไปที่หน้า Login.
        *   ถ้ามี error (เช่น  `weak-password`,  `email-already-in-use`), แสดง error message.
    *   `_showErrorDialog()`: แสดง error dialog.
    *   `_showSuccessDialog()`: แสดง success dialog.

### 4. หน้าลืมรหัสผ่าน (Forgot Password Screen) - `forgot_password_screen.dart`

*   **`ForgotPasswordPage` (StatefulWidget)**: หน้าจอสำหรับให้ผู้ใช้ reset password.
    *   **`_ForgotPasswordPageState`**: State ของ `ForgotPasswordPage`
        *   `_emailController`: `TextEditingController` สำหรับรับ input email.
        *   `build()`: สร้าง UI ของหน้า Forgot Password.
            *   `AppBar`: แสดง title "Forgot Password".
            *   มี  `TextField`  (หรือ  `CustomTextField`) สำหรับให้ผู้ใช้กรอก email.
            *   มีปุ่ม "Send Reset Link".
        *   `_resetPassword()`: ส่ง email สำหรับ reset password.
            *   ตรวจสอบ email ว่าไม่ว่างเปล่า.
            *   แสดง loading indicator.
            *   เรียก  `FirebaseAuth.instance.sendPasswordResetEmail`  เพื่อส่ง email.
            *   ซ่อน loading indicator.
            *   ถ้าส่ง email สำเร็จ, แสดง success dialog และ navigate กลับไปที่หน้า Login.
            *   ถ้ามี error, แสดง error message.
        *   `_showErrorDialog()`: แสดง error dialog.
        *    `_showSuccessDialog()`: แสดง success dialog.

### 5. Custom Text Field - `custom_text_field.dart`

*   **`CustomTextField` (StatelessWidget)**: เป็น reusable widget สำหรับสร้าง `TextFormField` ที่มี style เหมือนกันทั้งแอป. ช่วยลด code ที่ซ้ำซ้อน.
    *   รับ parameters ต่างๆ เช่น `controller`, `labelText`, `hintText`, `icon`, `obscureText`, `keyboardType`.
    *   สร้าง `TextFormField` ที่มี decoration (label, hint, icon, border, etc.) ที่กำหนดไว้.

## `main.dart`

*   `main()`:
    *   `WidgetsFlutterBinding.ensureInitialized()`:  จำเป็นต้องเรียกก่อนที่จะใช้ Firebase.
    *   `Firebase.initializeApp(...)`:  Initialize Firebase.
    *   `runApp(MyApp())`:  Run  `MyApp`  widget.
*   `MyApp`:
    *   `MaterialApp`:  Root widget ของแอป.
    *   `title`:  Title ของแอป.
    *   `theme`:  Theme ของแอป (colors, fonts, etc.).
    *   `initialRoute`:  Route เริ่มต้น (หน้าแรกที่จะแสดงเมื่อเปิดแอป).
    *   `routes`:  กำหนด routes สำหรับแต่ละหน้าจอ (screen).  ช่วยให้สามารถ navigate ระหว่างหน้าจอได้โดยใช้ชื่อ route (เช่น  `Navigator.pushNamed(context, '/login')`).
