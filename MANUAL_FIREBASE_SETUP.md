# 🔥 Manual Firebase Setup Guide

## Step 1: Create Firebase Project (2 minutes)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"** or **"Create a project"**
3. Enter project name: `food-delivery-app` (or any name)
4. Click **Continue**
5. Disable Google Analytics (optional) → **Create project**
6. Wait for project creation → Click **Continue**

## Step 2: Register Your App (3 minutes)

### For Android:
1. In Firebase Console, click the **Android icon** (robot)
2. **Android package name**: `com.example.test` (default Flutter package)
   - Find in: `android/app/build.gradle.kts` → look for `applicationId`
3. Click **Register app**
4. **Download google-services.json**
5. Place file in: `android/app/google-services.json`
6. Click **Continue** → **Continue** → **Continue to console**

### For iOS (Optional):
1. Click the **iOS icon** (Apple logo)
2. **Bundle ID**: `com.example.test`
3. Click **Register app**
4. **Download GoogleService-Info.plist**
5. Place in: `ios/Runner/GoogleService-Info.plist`

## Step 3: Get Firebase Config (2 minutes)

1. In Firebase Console → **Project Settings** (gear icon)
2. Scroll to **"Your apps"** section
3. Click your **Android app**
4. Scroll to **"SDK setup and configuration"**
5. Select **"Config"** option (not CDN)
6. Copy the configuration values

## Step 4: Update firebase_options.dart

Open `lib/firebase_options.dart` and replace the values:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_HERE',              // From Firebase Console
  appId: 'YOUR_APP_ID_HERE',                // From Firebase Console
  messagingSenderId: 'YOUR_SENDER_ID_HERE', // From Firebase Console
  projectId: 'YOUR_PROJECT_ID_HERE',        // From Firebase Console
  storageBucket: 'YOUR_BUCKET_HERE',        // From Firebase Console
);
```

## Step 5: Enable Authentication (1 minute)

1. Firebase Console → **Authentication**
2. Click **Get started**
3. Click **Sign-in method** tab
4. Click **Email/Password**
5. Enable the toggle → **Save**

## Step 6: Create Firestore Database (2 minutes)

1. Firebase Console → **Firestore Database**
2. Click **Create database**
3. Select **Start in test mode** → **Next**
4. Select location (closest to you) → **Enable**

## Step 7: Add Sample Food Data (3 minutes)

1. In Firestore, click **Start collection**
2. Collection ID: `foods`
3. Click **Next**
4. Document ID: `pizza1` (or auto-generate)
5. Add fields:

```
id: "pizza1" (string)
name: "Margherita Pizza" (string)
description: "Fresh mozzarella, tomato sauce, and basil" (string)
price: 12.99 (number)
imageUrl: "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500" (string)
category: "Pizza" (string)
isAvailable: true (boolean)
```

6. Click **Save**
7. Repeat for 3-4 more food items (burgers, pasta, etc.)

## Step 8: Set Firestore Rules (1 minute)

1. Firestore → **Rules** tab
2. Replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /foods/{foodId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /orders/{orderId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if false;
    }
  }
}
```

3. Click **Publish**

## Step 9: Run Your App! 🚀

```bash
flutter run
```

## ✅ Done!

Your app should now:
- Show food items on home screen
- Allow signup/login
- Let you add items to cart
- Place orders
- View order history

## 🐛 Troubleshooting

### "Default FirebaseApp is not initialized"
- Check `google-services.json` is in `android/app/`
- Run `flutter clean && flutter run`

### No food items showing
- Verify Firestore has `foods` collection
- Check internet connection

### Authentication errors
- Verify Email/Password is enabled in Firebase Console

---

**Total Time: ~15 minutes**

Much easier than installing Firebase CLI! 🎉
