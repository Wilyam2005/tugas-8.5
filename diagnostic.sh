#!/bin/bash
# Diagnostic script untuk Flutter Grocery App

echo "╔════════════════════════════════════════════════════════╗"
echo "║   FLUTTER GROCERY APP - DIAGNOSTIC REPORT              ║"
echo "║   Checking for Auto-Close Issues                       ║"
echo "╚════════════════════════════════════════════════════════╝"

echo ""
echo "1️⃣  Checking Flutter SDK..."
flutter --version

echo ""
echo "2️⃣  Checking connected devices..."
flutter devices

echo ""
echo "3️⃣  Running dependency check..."
cd "d:\w3-Grocery-App-flutter-mockup-main"
flutter pub get

echo ""
echo "4️⃣  Running code analysis..."
flutter analyze --no-fatal-infos 2>&1 | head -50

echo ""
echo "5️⃣  Checking Firebase configuration..."
if [ -f "android/app/google-services.json" ]; then
    echo "   ✅ google-services.json found"
    echo "   Content:"
    head -10 android/app/google-services.json
else
    echo "   ❌ google-services.json NOT found"
fi

echo ""
echo "6️⃣  Checking build.gradle.kts..."
if grep -q "com.example.w3_grocery_app" android/app/build.gradle.kts; then
    echo "   ✅ Package name matches in build.gradle.kts"
else
    echo "   ❌ Package name mismatch in build.gradle.kts"
fi

echo ""
echo "7️⃣  Running Firebase Config Test..."
flutter run -t lib/test_firebase.dart

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║   DIAGNOSTIC COMPLETE                                  ║"
echo "╚════════════════════════════════════════════════════════╝"
