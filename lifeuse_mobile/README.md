# LifeUse – Flutter Mobile Application

A minimal, high-performance Flutter mobile application connected to the **LifeUse** Spring Boot backend.

---

## 🎨 Design Philosophy
* **Palette:** Strict 3-4 color scheme (Obsidian Black `#090B0E`, Pure White `#FFFFFF`, Electric Indigo `#6366F1`, Emerald `#10B981`).
* **Aesthetic:** Minimalist, high-contrast, premium fintech styling.
* **App Icon:** Modern geometric monogram (`L` + `U`) with subtle indigo glow on a dark squircle.

---

## 📱 Features
1. **Authentication Flow:**
   - **Login Screen:** Sign in via `username`, `email`, or `phoneNumber` with password visibility toggle.
   - **Register Screen:** Complete account creation matching Spring Boot backend validations (`username`, `firstName`, `lastName`, `email`, `phoneNumber`, `password`, `confirmPassword`).
   - **Live Validation:** Matches backend requirements (8+ char password with uppercase, lowercase, digit, special symbol; E.164 phone format).
   - **Error Mapping:** Automatically surfaces exact backend error codes (`EMAIL_ALREADY_EXISTS`, `INVALID_CREDENTIALS`, etc.).
2. **Dashboard / Home:**
   - Displays user profile, full name, username, and email/phone verification status.
   - Dynamic **Role Badges:** `User`, `Customer`, `Admin`, `SuperAdmin` with custom accent highlights.
   - Backend API connection status and clean logout.
3. **Session Persistence:**
   - Automatically stores JWT tokens in local storage (`SharedPreferences`).
   - Auto-login restores session on app launch.

---

## 🚀 How to Run the App

### 1. Ensure the Backend is Running
In your root project directory (`E:\Mobile-Application-dev`):
```powershell
.\mvnw.cmd spring-boot:run
```
The backend starts at `http://localhost:8080/api/lifeUse`.

### 2. Configure Backend Host in Flutter
In `lib/core/config/api_config.dart`, the default host is set to:
* **Android Emulator:** `http://10.0.2.2:8080` (Default)
* **iOS Simulator / Desktop / Web:** `http://localhost:8080`
* **Physical Device:** `http://<YOUR_PC_LAN_IP>:8080` (e.g. `http://192.168.1.5:8080`)

*(Note: You can also tap the server badge directly on the Login screen to change the host at runtime without restarting!)*

### 3. Start the Flutter App
Inside `E:\Mobile-Application-dev\lifeuse_mobile`:
```powershell
flutter pub get
flutter run
```

---

## 🧪 Testing Credentials (Quick Fill)
You can test with pre-seeded accounts using password `Password123!`:
* **SuperAdmin:** `superadmin@lifeuse.com`
* **Admin:** `admin@lifeuse.com`
* **Customer:** `customer@lifeuse.com`
* **User:** `user@lifeuse.com`
