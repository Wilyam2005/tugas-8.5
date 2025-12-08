╔═══════════════════════════════════════════════════════════════════════════╗
║                    APP AUTO-CLOSE FIX GUIDE                                ║
║                     (Updated with Error Handling)                           ║
╚═══════════════════════════════════════════════════════════════════════════╝

🚨 PROBLEM IDENTIFIED:
App auto-closes biasanya karena Firestore Security Rules!

════════════════════════════════════════════════════════════════════════════

📋 ROOT CAUSE ANALYSIS

✓ Code sudah di-check:
  - lib/main.dart: Firebase init dengan try-catch
  - lib/login_screen.dart: Proper auth handling
  - lib/homepage.dart: StreamBuilder dengan error handling (FIXED)
  - lib/profile.dart: StreamBuilder dengan error handling (FIXED)
  - lib/firebase_options.dart: Logging added

✓ Improvements made:
  - Added error handling di semua Firestore StreamBuilders
  - Added debug logging untuk track auth state
  - Added exception handling di Firebase init
  - Created test_firebase.dart untuk verify config

🔴 MOST LIKELY CAUSE: Firestore Security Rules tidak configured!

════════════════════════════════════════════════════════════════════════════

🎯 LANGKAH-LANGKAH UNTUK FIX (WAJIB DILAKUKAN):

════════════════════════════════════════════════════════════════════════════

STEP 1: CONFIGURE FIRESTORE SECURITY RULES
──────────────────────────────────────────

1. Open: https://console.firebase.google.com/
2. Select Project: wilyam-yazid-hamdi
3. Left Menu → Firestore Database
4. Click "Rules" tab
5. COPY-PASTE rules di bawah:

   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Allow read/write untuk authenticated users
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }

6. Click "Publish" button
7. Wait untuk "Rules updated successfully"

════════════════════════════════════════════════════════════════════════════

STEP 2: VERIFY FIRESTORE DATABASE ENABLED
──────────────────────────────────────────

1. Go to Firebase Console → Firestore Database
2. If "Create Database" button visible:
   - Click "Create Database"
   - Choose location (default: us-central1)
   - Click "Create"
3. If Firestore sudah exist, lanjut ke STEP 3

════════════════════════════════════════════════════════════════════════════

STEP 3: TEST FIREBASE CONFIG
─────────────────────────────

Sebelum run main app, test Firebase config:

  cd d:\w3-Grocery-App-flutter-mockup-main
  flutter run -t lib/test_firebase.dart

Ini akan:
  ✅ Test Firebase initialization
  ✅ Verify firebase_options.dart config
  ✅ Show success/error message

Expected output:
  ✅ Firebase initialized successfully!
  ✅ App Name: [default]
  ✅ Options Project ID: wilyam-yazid-hamdi

════════════════════════════════════════════════════════════════════════════

STEP 4: RUN MAIN APP
────────────────────

After Firestore rules published & Firebase config verified:

  cd d:\w3-Grocery-App-flutter-mockup-main
  flutter clean
  flutter pub get
  flutter run

Expected behavior:
  1. App starts with loading indicator
  2. "Initializing..." message shown
  3. After 5-10 seconds, LoginScreen appears
  4. NO BLACK SCREEN or AUTO-CLOSE!

════════════════════════════════════════════════════════════════════════════

STEP 5: IF STILL AUTO-CLOSE, DEBUG WITH LOGS
──────────────────────────────────────────────

Run with verbose logging:

  flutter run -v 2>&1 | Tee-Object debug_log.txt

Then:
  1. Search log untuk "ERROR" atau "Exception"
  2. Look untuk pattern: "❌" di console (kami sudah add debug prints)
  3. Send error message untuk further help

════════════════════════════════════════════════════════════════════════════

📝 WHAT WAS CHANGED IN CODE
──────────────────────────

1. lib/main.dart
   ✅ Added try-catch di Firebase.initializeApp()
   ✅ Added console.log di setiap auth state
   ✅ Better error messages
   ✅ Now: print("✅ Firebase initialized successfully")
   ✅ Now: print("❌ User logged out")

2. lib/firebase_options.dart
   ✅ Added debug logging di currentPlatform getter
   ✅ Shows platform being used: "🤖 Using Android Firebase Config"
   ✅ Better error messages untuk troubleshooting

3. lib/pages/homepage.dart
   ✅ StreamBuilder greeting now has error handling
   ✅ If Firestore fails: shows "Hi! 👋" instead of crashing
   ✅ Added logs: print("Homepage greeting stream: ...")

4. lib/pages/profile.dart
   ✅ StreamBuilder user data now has error handling
   ✅ If Firestore fails: shows "User" instead of crashing
   ✅ Added logs: print("Profile header stream: ...")

5. lib/test_firebase.dart (NEW)
   ✅ Standalone test app untuk verify Firebase config
   ✅ Run: flutter run -t lib/test_firebase.dart
   ✅ Shows detailed success/error messages

════════════════════════════════════════════════════════════════════════════

🔍 CHECKLIST BEFORE RUNNING APP

□ Firestore Database created in Firebase Console
□ Firestore Security Rules published (copied rules above)
□ flutter clean && flutter pub get (local)
□ Tested Firebase config: flutter run -t lib/test_firebase.dart
□ All imports resolved (no red squiggles)
□ Android SDK tools updated

════════════════════════════════════════════════════════════════════════════

📱 EXPECTED BEHAVIOR AFTER FIX

1️⃣ App starts:
   - Shows loading spinner + "Initializing..." message
   - Console shows: "✅ Firebase initialized successfully"

2️⃣ After auth check (5-10 seconds):
   - If logged out: LoginScreen appears
   - Console shows: "❌ User logged out"
   
   - If logged in: HomePage appears with greeting
   - Console shows: "✅ User logged in: user@example.com"

3️⃣ No auto-close!
   All Firestore errors handled gracefully.

════════════════════════════════════════════════════════════════════════════

❓ TROUBLESHOOTING

If app STILL auto-close after following steps:

1. Check Firebase console shows:
   ✅ Firestore Database tab exists (not "Create Database")
   ✅ Rules tab shows your published rules

2. Run verbose logs:
   flutter run -v 2>&1 | Tee-Object log.txt
   
   Post last 50 lines dari log untuk debugging

3. Check AndroidManifest.xml:
   android/app/src/main/AndroidManifest.xml
   
   Should contain:
   <uses-permission android:name="android.permission.INTERNET" />

4. Check package name:
   ✅ build.gradle.kts: applicationId = "com.example.w3_grocery_app"
   ✅ google-services.json: "package_name": "com.example.w3_grocery_app"
   ✅ Must EXACT MATCH!

════════════════════════════════════════════════════════════════════════════

If masih ada error, post:
1. Screenshot dari Firebase Console → Firestore Rules
2. Last 50 lines dari: flutter run -v
3. Exact error message dari console

Dengan info tersebut, bisa debug lebih akurat!

════════════════════════════════════════════════════════════════════════════
Last updated: 8 December 2025
Status: Code refactored with error handling + Firestore rules guide
════════════════════════════════════════════════════════════════════════════
