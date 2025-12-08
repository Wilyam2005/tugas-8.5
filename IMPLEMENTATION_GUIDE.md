# Grocery App - Firebase Integration Guide

## ✅ Completion Status

Konversi dari UI Mockup menjadi Functional App dengan Firebase telah **SELESAI**.

### Implemented Features

#### 1. Firebase Authentication ✅
- **Sign In**: Email & Password authentication
- **Sign Up**: Create new account with full name storage
- **Sign Out**: Logout functionality with auto-redirect
- **State Management**: Real-time auth state monitoring via StreamBuilder

#### 2. Firestore Database Integration ✅
- **User Collection**: Stores user profiles
- **User Data Structure**:
  ```
  users/{uid}/
  ├── fullName: string
  ├── email: string
  └── createdAt: timestamp
  ```
- **Real-time Sync**: All pages use StreamBuilder for live data updates

#### 3. Pages Implementation

##### LoginScreen (`lib/login_screen.dart`)
```
Features:
- Email & Password input
- Firebase Authentication
- Error handling with SnackBar
- Link to RegisterScreen
```

##### RegisterScreen (in `login_screen.dart`)
```
Features:
- Full Name, Email, Password input
- Password confirmation validation
- Create Firebase Auth account
- Save user data to Firestore
- Auto-redirect on success
```

##### HomePage (`lib/pages/homepage.dart`)
```
Features:
- Real-time user greeting "Hi, [Name] 👋"
- Fetches fullName from Firestore
- StreamBuilder for live updates
- Fallback to "User" if data unavailable
```

##### ProfilePage (`lib/pages/profile.dart`)
```
Features:
- Display real user data (name, email)
- Edit Profile button
- Logout button
- Real-time user info sync
```

##### EditProfilePage (in `lib/pages/profile.dart`)
```
Features:
- Load current fullName on open
- Edit and save fullName to Firestore
- Success/error feedback
- Proper state management
```

### Architecture Changes

#### main.dart
- Async initialization with Firebase
- StreamBuilder-based auth routing
- Automatic page switching based on auth state

#### Authentication Flow
```
Not Logged In → LoginScreen
                 ↓
             (Sign In/Sign Up)
                 ↓
           Firebase Auth + Firestore
                 ↓
           Logged In → RootShell (Main App)
```

## 🚀 How to Run

### Prerequisites
1. Flutter SDK installed
2. Android Studio (for Android build)
3. Xcode (for iOS build)
4. Firebase project configured

### Setup Steps

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase** (Optional - already configured)
   ```bash
   flutterfire configure
   ```

3. **Run on Emulator/Device**
   ```bash
   flutter run
   ```

4. **Build APK**
   ```bash
   flutter build apk --release
   ```

## 📝 Testing Guide

### Test Case 1: Sign Up
1. Launch app → LoginScreen appears
2. Click "CREATE AN ACCOUNT"
3. Fill: Full Name, Email, Password, Confirm Password
4. Click "SIGN UP"
5. **Expected**: Account created, redirect to login, user data saved in Firestore

### Test Case 2: Sign In
1. Enter registered email & password
2. Click "SIGN IN"
3. **Expected**: Redirect to HomePage with greeting showing your name

### Test Case 3: View Profile
1. After login, tap Profile icon in navigation bar
2. **Expected**: See your name and email from Firestore

### Test Case 4: Edit Profile
1. In Profile page, click edit icon
2. Change Full Name
3. Click checkmark ✓
4. **Expected**: Name updated in Firestore, reflected in HomePage greeting

### Test Case 5: Logout
1. In Profile page, tap "LogOut"
2. **Expected**: Redirect to LoginScreen, session cleared

### Test Case 6: Persistence
1. After login, close app
2. Reopen app
3. **Expected**: Still logged in, user data displays immediately

## 🔧 Troubleshooting

### Issue: "google-services.json not found"
**Solution**: File copied to `android/app/google-services.json`

### Issue: "Firebase not initialized"
**Solution**: Check `firebase_options.dart` is imported and Firebase.initializeApp() called in main()

### Issue: "Firestore returns null"
**Solution**: 
- Verify Firestore rules allow read/write
- Check user is logged in (auth state)
- Ensure document path is correct: `users/{uid}`

### Issue: "Build fails on Android"
**Solution**:
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

## 📂 Key Files

| File | Purpose |
|------|---------|
| `lib/firebase_options.dart` | Firebase configuration |
| `lib/main.dart` | App entry, Firebase init, auth routing |
| `lib/login_screen.dart` | Login & Register screens with Firebase |
| `lib/pages/homepage.dart` | Home page with real-time user greeting |
| `lib/pages/profile.dart` | Profile, edit profile, logout |
| `android/app/google-services.json` | Android Firebase config |
| `FIREBASE_INTEGRATION.md` | Detailed integration docs |

## 🎯 Next Steps (Optional Enhancements)

- [ ] Password reset functionality
- [ ] Social authentication (Google, Apple)
- [ ] User profile picture upload
- [ ] Email verification
- [ ] Phone number authentication
- [ ] User preferences/settings storage
- [ ] Push notifications via FCM
- [ ] Offline data sync with local storage

## 📞 Support

For Firebase issues, refer to:
- [Firebase Flutter Documentation](https://firebase.flutter.dev)
- [FirebaseAuth Documentation](https://firebase.google.com/docs/auth)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)

---

**Status**: ✅ Complete and Ready for Testing
**Last Updated**: December 8, 2025
