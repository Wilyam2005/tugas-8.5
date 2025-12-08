🔴 MASALAH: "Langsung Logout Ketika Masuk Diawal"

═══════════════════════════════════════════════════════════════════════════

GEJALA:
- User login dengan email/password
- App menampilkan SnackBar "Login successful!"
- Kemudian langsung kembali ke LoginScreen
- User NOT tetap tersimpan

PENYEBAB:
1. ❌ Firestore Security Rules tidak dikonfigurasi
   → App mungkin mencoba akses Firestore saat login
   → Firestore reject → Error tidak tertangani
   → Session corrupted → Auto logout

2. ❌ Issue dengan Firestore document tidak ada
   → saat login berhasil, app try read user data
   → Document not found → Exception
   → Session terminated

3. ❌ Stream listener di HomePage causing logout
   → StreamBuilder listening to Firestore
   → Jika Firestore fail → Session can be affected

═══════════════════════════════════════════════════════════════════════════

✅ SOLUSI COMPREHENSIVE (STEP-BY-STEP)
════════════════════════════════════════

STEP 1: CONFIGURE FIRESTORE SECURITY RULES (WAJIB!)
───────────────────────────────────────────────────

1. Go to: https://console.firebase.google.com/
2. Project: wilyam-yazid-hamdi
3. Firestore Database → Rules tab
4. Delete all existing rules
5. Paste ini EXACTLY:

────────────────────────────────────────────────────────

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow all authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

────────────────────────────────────────────────────────

6. Click "Publish"
7. Wait for "Rules updated successfully"

⚠️ CRITICAL! Tanpa ini, login akan FAIL!

════════════════════════════════════════════════════════════════════════════

STEP 2: CREATE TEST USER (MANUAL)
──────────────────────────────────

In Firebase Console:

1. Go to: Authentication
2. Click: "Add User" atau "Create User"
3. Email: test@example.com
4. Password: Test123456
5. Click "Create User"

Atau gunakan app untuk register account dulu.

════════════════════════════════════════════════════════════════════════════

STEP 3: VERIFY FIRESTORE COLLECTION
───────────────────────────────────

Firebase Console → Firestore Database → Data tab

Check if collection 'users' exists dengan test user data:
/users/{uid}
  - fullName: (nama user)
  - email: test@example.com
  - createdAt: (timestamp)

Jika tidak ada:
  → Register baru user melalui app (click "CREATE AN ACCOUNT")
  → Ini akan automatically create document di Firestore

════════════════════════════════════════════════════════════════════════════

STEP 4: CLEAN BUILD & TEST
──────────────────────────

1. Terminal:
   cd d:\w3-Grocery-App-flutter-mockup-main
   flutter clean
   flutter pub get

2. Uninstall old app from device:
   Settings → Apps → flutter_application_12 → Uninstall

3. Run:
   flutter run

4. Try to login dengan credentials:
   Email: test@example.com
   Password: Test123456

Expected:
  ✅ SnackBar: "Login successful!"
  ✅ App transitions to HomePage
  ✅ Shows greeting: "Hi, [User Name] 👋"
  ✅ User tetap logged in (bukan logout)

════════════════════════════════════════════════════════════════════════════

STEP 5: IF STILL LOGOUT IMMEDIATELY
───────────────────────────────────

Debug dengan logs:

1. Run dengan verbose:
   flutter run -v 2>&1 | Tee-Object debug.txt

2. Watch untuk messages seperti:
   - "❌ Firestore error"
   - "PERMISSION_DENIED"
   - "Stream error"
   - "Exception"

3. Search log untuk "ERROR" atau "❌"

4. Jika ada error, cek:
   - Firestore Rules published?
   - Users collection exists?
   - User document created saat signup?

════════════════════════════════════════════════════════════════════════════

🔧 CODE IMPROVEMENTS APPLIED
──────────────────────────────

1. lib/main.dart
   ✅ Refactored StreamBuilder into _buildHome() method
   ✅ Better error handling & logging
   ✅ Changed print() to debugPrint()

2. lib/login_screen.dart
   ✅ Improved _login() function
   ✅ Added detailed debugging
   ✅ Removed unnecessary navigation (let StreamBuilder handle it)
   ✅ Better error messages

3. Code now:
   ✅ Checks mounted before setState
   ✅ Uses debugPrint() untuk cleaner logs
   ✅ Doesn't force navigation (depends on auth state)
   ✅ Proper exception handling

════════════════════════════════════════════════════════════════════════════

📋 STEP-BY-STEP CHECKLIST
──────────────────────────

BEFORE testing:

□ Firestore Rules configured & published
□ Firestore Database created (Rules tab visible)
□ Users collection exists (or will be created on signup)
□ Test user account exists (test@example.com)
□ flutter clean executed
□ flutter pub get executed
□ Old app uninstalled from device
□ Device connected

════════════════════════════════════════════════════════════════════════════

TESTING WORKFLOW
─────────────────

1. Start app: flutter run
2. Wait for LoginScreen to appear
3. Click "CREATE AN ACCOUNT"
4. Register baru:
   - Full Name: John Doe
   - Email: john@test.com
   - Password: Test123456
5. Click "CREATE AN ACCOUNT" button
6. Should show: "Account created successfully!"
7. Automatically return ke LoginScreen
8. Login dengan:
   - Email: john@test.com
   - Password: Test123456
9. Click "SIGN IN"
10. Should show: "Login successful!"
11. After 1-2 seconds → HomePage appears
12. Shows: "Hi, John Doe 👋"
13. User tetap logged in (tidak logout!)

════════════════════════════════════════════════════════════════════════════

❓ TROUBLESHOOTING
──────────────────

PROBLEM: Login seems to work but returns to LoginScreen
──────────────────────────────────────────────────────
Causes:
  1. Firestore Rules not published
  2. User document not created
  3. Stream error pada HomePage

Solutions:
  → Verify Firestore Rules published
  → Check users collection exists
  → Run: flutter run -v untuk see errors
  → Check Firestore error handling code

PROBLEM: "Account created successfully!" tapi user tidak ter-save
─────────────────────────────────────────────────────────────────
Causes:
  1. Firestore Rules deny write access
  2. Firestore collection doesn't exist

Solutions:
  → Publish Firestore Rules
  → Check rules allow write untuk authenticated users
  → Verify _saveUserToFirestore() function

PROBLEM: Logs show "PERMISSION_DENIED"
──────────────────────────────────────
Solutions:
  → Firestore Rules NOT published!
  → Go to Firebase Console
  → Firestore → Rules tab
  → Paste rules above & publish

PROBLEM: StreamBuilder showing errors
──────────────────────────────────────
Solutions:
  → Error handling already in place
  → App should fallback to "Hi! 👋" if error
  → Check if issue is in code atau Firestore

════════════════════════════════════════════════════════════════════════════

🎯 EXPECTED BEHAVIOR AFTER ALL FIXES
──────────────────────────────────────

✅ Tap "SIGN IN" button
✅ Enter email/password
✅ SnackBar: "Login successful!"
✅ App transitions to HomePage (NOT logout)
✅ Shows user greeting: "Hi, [Name] 👋"
✅ Bottom navigation works (Orders, Cart, Favorites, Profile)
✅ User can navigate around without logout
✅ Only logout when click Profile → Logout button

════════════════════════════════════════════════════════════════════════════

📊 VERIFICATION POINTS
──────────────────────

Check these dalam Firebase Console:

1. Firestore Database
   → Rules tab: Shows YOUR rules (not empty)
   → Data tab: Shows 'users' collection
   → Each user doc: Has fullName, email, createdAt

2. Authentication
   → Shows all registered users
   → Each user: Has email, creation date

3. Both sections data harus match:
   → User in Auth = User document in Firestore

════════════════════════════════════════════════════════════════════════════

SUMMARY
───────

Problem: User logout immediately after login
Cause: Usually Firestore Rules issue
Solution: Configure Firestore Rules + test thoroughly
Result: User login works, session persists ✅

════════════════════════════════════════════════════════════════════════════
