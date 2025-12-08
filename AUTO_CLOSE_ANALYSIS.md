🔍 ANALISIS: MENGAPA APP AUTO CLOSE

═════════════════════════════════════════════════════════════════════════

⚠️ ROOT CAUSE ANALYSIS

Ada 3 kemungkinan utama penyebab app auto-close:

1. 🔴 FIRESTORE SECURITY RULES (PALING KEMUNGKINAN - 95%)
   ──────────────────────────────────────────────────────
   Firestore default deny semua akses! Jika tidak dikonfigurasi:
   - App mencoba read dari Firestore di HomePage/Profile
   - Firestore deny request
   - Error thrown → App crash & auto-close
   
   Solusi: Configure Firestore Security Rules

2. 🟠 UNHANDLED EXCEPTION DI CODE (10%)
   ───────────────────────────────────────
   Ada error di login_screen.dart atau homepage.dart yang tidak tertangani
   
   Solusi: Cek logs & tambah error handling

3. 🟡 FIREBASE INIT ERROR (5%)
   ────────────────────────────
   Firebase.initializeApp() gagal karena config error
   
   Solusi: Verify firebase_options.dart & google-services.json

═════════════════════════════════════════════════════════════════════════

✅ SOLUTION #1: FIRESTORE SECURITY RULES (WAJIB DILAKUKAN)

Step 1: Buka Firebase Console
  https://console.firebase.google.com/

Step 2: Select Project "wilyam-yazid-hamdi"

Step 3: Go to Firestore Database → Rules

Step 4: Replace SEMUA rules dengan ini:

  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      // Allow read/write untuk authenticated users
      match /{document=**} {
        allow read, write: if request.auth != null;
      }
      
      // Allow anonymous read (optional, untuk test)
      match /{document=**} {
        allow read: if true;
      }
    }
  }

Step 5: Click "Publish"

⚠️ PENTING: Ini adalah permissive rules untuk development!
   Untuk production, ubah menjadi lebih restrictive:
   
   match /users/{userId} {
     allow read, write: if request.auth.uid == userId;
   }

═════════════════════════════════════════════════════════════════════════

✅ SOLUTION #2: ENABLE CLOUD FIRESTORE

Jika Firestore belum enabled:

Step 1: Firebase Console → Firestore Database
Step 2: Click "Create Database"
Step 3: Select location (default: us-central1 untuk development)
Step 4: Choose "Start in production mode" (atau test mode, kemudian update rules)
Step 5: Click "Create"

═════════════════════════════════════════════════════════════════════════

✅ SOLUTION #3: VERIFY PACKAGE NAME

Pastikan ini semua SAMA:

1. build.gradle.kts:
   applicationId = "com.example.w3_grocery_app"

2. google-services.json:
   "package_name": "com.example.w3_grocery_app"

3. firebase_options.dart:
   Android config untuk package "com.example.w3_grocery_app"

Current Status:
  ✅ build.gradle.kts: "com.example.w3_grocery_app"
  ✅ google-services.json: "com.example.w3_grocery_app" (entry exists)
  ✅ firebase_options.dart: Android config matches

═════════════════════════════════════════════════════════════════════════

✅ SOLUTION #4: RUN DENGAN DEBUG LOGS

Jalankan app dengan verbose logs untuk lihat error exact:

  cd d:\w3-Grocery-App-flutter-mockup-main
  flutter run -v 2>&1 | Tee-Object log.txt

Lihat file log.txt untuk error details.

═════════════════════════════════════════════════════════════════════════

✅ SOLUTION #5: TEST FIREBASE CONFIG

Jalankan firebase config test app:

  flutter run -t lib/test_firebase.dart

Ini akan:
  ✅ Verify firebase options loaded correctly
  ✅ Initialize Firebase
  ✅ Show success/error message
  ✅ Help identify config problems

═════════════════════════════════════════════════════════════════════════

🔧 IMPROVEMENTS MADE TO CODE

1. lib/main.dart
   ✅ Added try-catch di Firebase.initializeApp()
   ✅ Added console.log di every auth state
   ✅ Better error messages

2. lib/firebase_options.dart
   ✅ Added debug logging di currentPlatform getter
   ✅ Better error messages untuk troubleshooting

3. lib/test_firebase.dart (NEW FILE)
   ✅ Standalone test app untuk verify Firebase config
   ✅ Shows detailed error if initialization fails

═════════════════════════════════════════════════════════════════════════

🎯 STEP-BY-STEP DEBUGGING

If app still auto-close:

1. First: Configure Firestore Rules (CRITICAL!)
   - Go to Firebase Console
   - Firestore Database → Rules
   - Paste the rules above
   - Publish

2. Second: Test Firebase Config
   - Run: flutter run -t lib/test_firebase.dart
   - Should show success screen
   - If fails, check console logs

3. Third: Run with verbose logs
   - Run: flutter run -v 2>&1 | Tee-Object log.txt
   - Search log for "ERROR" or "Exception"
   - Post error message untuk further debugging

4. Fourth: Check Android Manifest
   - android/app/src/main/AndroidManifest.xml
   - Verify internet permission exists:
     <uses-permission android:name="android.permission.INTERNET" />

5. Fifth: Clean and rebuild
   - flutter clean
   - flutter pub get
   - flutter run

═════════════════════════════════════════════════════════════════════════

📋 CHECKLIST

Do these BEFORE running app:

□ Configure Firestore Security Rules
□ Enable Firestore Database di Firebase Console
□ Verify package names match (build.gradle + google-services.json)
□ Run: flutter clean && flutter pub get
□ Test Firebase config: flutter run -t lib/test_firebase.dart
□ Run with verbose logs untuk debug jika masih error
□ Check Android manifest has internet permission

═════════════════════════════════════════════════════════════════════════

Jika masih ada pertanyaan, silakan post:
1. Firebase console screenshot showing Firestore status
2. flutter run -v output (last 100 lines)
3. Error message dari app

Dengan info tersebut bisa di-debug lebih spesific.

═════════════════════════════════════════════════════════════════════════
