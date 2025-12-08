🔴 ERROR: "flutter_application_12 mengalami masalah"
(App crashed with internal error)

═══════════════════════════════════════════════════════════════════════════════

PENYEBAB ERROR
──────────────

Error message (from screenshot):
"flutter_application_12 ditutup paksa karena kesalahan internal..."

Translation: "flutter_application_12 closed forcefully due to internal error..."

Root Causes:
1. ❌ Firestore Security Rules still not configured (CRITICAL!)
2. ❌ App trying to access Firestore without permission
3. ❌ Unhandled exception causing crash
4. ❌ App name mismatch: "flutter_application_12" vs "w3_grocery_app"

═══════════════════════════════════════════════════════════════════════════════

✅ SOLUSI LENGKAP (STEP-BY-STEP)
─────────────────────────────────

PRIORITY #1: CONFIGURE FIRESTORE SECURITY RULES (WAJIB!)
────────────────────────────────────────────────────────

1. Open: https://console.firebase.google.com/
2. Project: wilyam-yazid-hamdi
3. Left menu: Firestore Database
4. Click: "Rules" tab
5. Delete ALL existing rules
6. Copy-paste ini:

────────────────────────────────────────────────────────

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write all documents
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

────────────────────────────────────────────────────────

7. Click "Publish" button
8. Wait untuk message: "Rules updated successfully"

CRITICAL: Tanpa ini, app AKAN terus crash!

════════════════════════════════════════════════════════════════════════════════

PRIORITY #2: VERIFY FIRESTORE DATABASE ENABLED
───────────────────────────────────────────────

1. Firebase Console → Firestore Database
2. Check if database sudah terbuat:
   ✅ If see "Rules" tab → Database exists
   ❌ If see "Create Database" button → Create it:
      - Click "Create Database"
      - Choose location: us-central1 (default)
      - Click "Create"
      - Then configure rules (PRIORITY #1)

════════════════════════════════════════════════════════════════════════════════

PRIORITY #3: TEST FIREBASE CONFIG
──────────────────────────────────

Before running on device, test Firebase setup:

Open terminal:
  cd d:\w3-Grocery-App-flutter-mockup-main
  flutter run -t lib/test_firebase.dart

Expected output:
  ✅ "Firebase initialized successfully!"
  ✅ Shows project ID: wilyam-yazid-hamdi
  ✅ No error messages

If error appears:
  → Go back to PRIORITY #1
  → Check Firestore rules correctly published

════════════════════════════════════════════════════════════════════════════════

PRIORITY #4: CLEAN BUILD & REINSTALL
─────────────────────────────────────

Before running on device:

1. Clean old builds:
   flutter clean

2. Get fresh dependencies:
   flutter pub get

3. Uninstall old app dari device:
   - Open device Settings → Apps → flutter_application_12
   - Tap "Uninstall"
   OR
   - Long press app icon → Uninstall

4. Build & install fresh:
   flutter run

════════════════════════════════════════════════════════════════════════════════

PRIORITY #5: DEBUG IF STILL CRASHES
────────────────────────────────────

If app masih crash, collect debug info:

1. Run dengan verbose logs:
   flutter run -v 2>&1 | Tee-Object debug.txt

2. Watch untuk error messages seperti:
   - "PERMISSION_DENIED" → Firestore rules issue
   - "Firebase.initializeApp failed" → Config issue
   - "NoSuchMethodError" → Code issue

3. Search log untuk "ERROR" atau "Exception"

4. Post error messages untuk further debugging

════════════════════════════════════════════════════════════════════════════════

⚠️ COMMON ISSUES & FIXES
────────────────────────

ISSUE #1: Firestore Rules Not Published
───────────────────────────────────────
Symptom: App crashes immediately
Fix: Go to PRIORITY #1, make sure click "Publish"
     Wait untuk "Rules updated successfully"

ISSUE #2: Old App Still Installed
──────────────────────────────────
Symptom: New code not running
Fix: Uninstall app from device
     Then: flutter run (fresh install)

ISSUE #3: Cache Issues
──────────────────────
Symptom: Code changes not reflected
Fix: flutter clean
     flutter pub get
     flutter run

ISSUE #4: Package Name Mismatch
───────────────────────────────
Symptom: Firebase config not found
Fix: Verify:
     - build.gradle.kts: applicationId = "com.example.w3_grocery_app"
     - google-services.json: package_name = "com.example.w3_grocery_app"
     - firebase_options.dart: Android config untuk w3_grocery_app

════════════════════════════════════════════════════════════════════════════════

📋 QUICK CHECKLIST
──────────────────

BEFORE running app on device:

□ Firestore Database created (check Firestore tab exists)
□ Firestore Security Rules configured & published
□ Tested Firebase config: flutter run -t lib/test_firebase.dart
□ Old app uninstalled dari device
□ flutter clean executed
□ flutter pub get executed
□ Device connected & developer mode enabled

════════════════════════════════════════════════════════════════════════════════

🚀 LANGKAH-LANGKAH FINAL (7 MINUTES)
─────────────────────────────────────

1. Configure Firestore Rules (3 min)
   → Go to Firebase Console
   → Copy-paste rules above
   → Click "Publish"
   → Wait untuk success message

2. Clean & Rebuild (2 min)
   → Open terminal
   → flutter clean
   → flutter pub get

3. Uninstall Old App (1 min)
   → Open device Settings
   → Apps → flutter_application_12
   → Uninstall

4. Run New Build (1 min)
   → Terminal: flutter run
   → Wait untuk install

5. Test App (0 min)
   → LoginScreen should appear
   → NO CRASH!

════════════════════════════════════════════════════════════════════════════════

✅ EXPECTED RESULT
──────────────────

After following all steps:

1. App installs without error ✅
2. App launches without auto-close ✅
3. Loading spinner shows "Initializing..." ✅
4. After 5-10 seconds:
   - LoginScreen appears (if not logged in) ✅
   OR
   - HomePage appears (if logged in) ✅
5. NO CRASH, NO ERROR ✅

════════════════════════════════════════════════════════════════════════════════

📞 IF STILL HAVING ISSUES
──────────────────────────

1. Verify Firestore Rules are published:
   - Firebase Console → Firestore → Rules
   - Should show your rules (not empty)

2. Test Firebase config:
   - flutter run -t lib/test_firebase.dart
   - Should show success message

3. Check device logs:
   - flutter run -v 2>&1 | Tee-Object log.txt
   - Search untuk "ERROR"

4. Post error details untuk help

════════════════════════════════════════════════════════════════════════════════

🎯 KEY POINT
────────────

⚠️ FIRESTORE SECURITY RULES ADALAH CRITICAL!

Tanpa rules configured:
❌ Firestore denies ALL requests
❌ App crashes dengan PERMISSION_DENIED
❌ User sees: "App closed due to internal error"

Dengan rules configured:
✅ Firestore grants access to authenticated users
✅ App runs smoothly
✅ User sees LoginScreen/HomePage

════════════════════════════════════════════════════════════════════════════════

SUMMARY
───────

Problem:    App crashes dengan "internal error"
Cause:      Firestore rules not configured
Solution:   Configure Firestore rules (copy-paste above)
Time:       ~7 minutes
Result:     App will run without crashes ✅

════════════════════════════════════════════════════════════════════════════════
