# 🚀 Complete Setup Guide

## Quick Start (5 Minutes)

### Step 1: Install Dependencies
```bash
cd test
flutter pub get
```

### Step 2: Setup Firebase

#### Option A: Using FlutterFire CLI (Recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure project
flutterfire configure
```

This will:
- Show your Firebase projects
- Let you select or create a project
- Auto-generate `firebase_options.dart` with correct credentials
- Setup iOS, Android, and Web configurations

#### Option B: Manual Configuration
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project (or select existing)
3. Add Android/iOS apps
4. Download config files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
5. Update `firebase_options.dart` with your keys

### Step 3: Configure Firebase Services

#### Enable Authentication
```
Firebase Console → Build → Authentication → Get Started
→ Sign-in method → Email/Password → Enable → Save
```

#### Setup Firestore Database
```
Firebase Console → Build → Firestore Database → Create Database
→ Select "Start in test mode" → Choose location → Enable
```

#### Add Sample Food Data
In Firestore, create collection `foods` and add documents:

**Document 1** (ID: auto or `food1`)
```json
{
  "id": "food1",
  "name": "Margherita Pizza",
  "description": "Classic Italian pizza with fresh mozzarella, tomatoes, and basil",
  "price": 12.99,
  "imageUrl": "https://images.unsplash.com/photo-1574071318508-1cdbab80d002",
  "category": "Pizza",
  "isAvailable": true
}
```

**Document 2**
```json
{
  "id": "food2",
  "name": "Cheeseburger",
  "description": "Juicy beef patty with melted cheese, lettuce, tomato, and special sauce",
  "price": 9.99,
  "imageUrl": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd",
  "category": "Burgers",
  "isAvailable": true
}
```

**Document 3**
```json
{
  "id": "food3",
  "name": "Chicken Alfredo",
  "description": "Creamy pasta with grilled chicken and parmesan cheese",
  "price": 14.99,
  "imageUrl": "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9",
  "category": "Pasta",
  "isAvailable": true
}
```

**Document 4**
```json
{
  "id": "food4",
  "name": "Caesar Salad",
  "description": "Fresh romaine lettuce with croutons, parmesan, and Caesar dressing",
  "price": 7.99,
  "imageUrl": "https://images.unsplash.com/photo-1546793665-c74683f339c1",
  "category": "Salads",
  "isAvailable": true
}
```

**Document 5**
```json
{
  "id": "food5",
  "name": "Chocolate Cake",
  "description": "Rich chocolate layer cake with chocolate frosting",
  "price": 6.99,
  "imageUrl": "https://images.unsplash.com/photo-1578985545062-69928b1d9587",
  "category": "Desserts",
  "isAvailable": true
}
```

### Step 4: Configure Firestore Security Rules

In Firestore → Rules tab, paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      // Anyone authenticated can read user data
      allow read: if request.auth != null;
      // Users can only write their own data
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Foods collection
    match /foods/{foodId} {
      // Anyone can read foods
      allow read: if true;
      // Only authenticated users can write (for now)
      // In production, restrict this to admin only
      allow write: if request.auth != null;
    }
    
    // Orders collection
    match /orders/{orderId} {
      // Users can only read their own orders
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      // Users can only create orders for themselves
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      // Orders cannot be updated or deleted by users
      allow update, delete: if false;
    }
  }
}
```

Click **Publish** to save rules.

### Step 5: Run the App

```bash
# Check for connected devices
flutter devices

# Run on connected device/emulator
flutter run

# Or run in debug mode
flutter run --debug

# For release build
flutter run --release
```

## 📱 Testing the App

### 1. First Launch
- App opens to Login screen
- Click "Sign Up"

### 2. Create Account
- Enter name: "John Doe"
- Enter email: "test@example.com"
- Enter password: "password123"
- Click Sign Up
- Should auto-login and show Home screen

### 3. Browse Foods
- See list of food items (if you added sample data)
- Each card shows image, name, price, category

### 4. View Food Details
- Tap any food card
- See full description
- Click "Add to Cart"
- See success message

### 5. View Cart
- Tap cart icon (top-right) with badge showing count
- See cart items with quantity controls
- Use +/- to change quantity
- See total updating

### 6. Place Order
- In cart, click "Place Order"
- Wait for success message
- Auto-redirect to home
- Cart is now empty

### 7. View Orders
- Go to Orders tab (bottom nav)
- See your placed orders
- Tap order to expand and see items
- Status: "PENDING"

### 8. Edit Profile
- Go to Profile tab
- Click edit icon (top-right)
- Update name, phone, address
- Click Save
- See success message

### 9. Logout
- In Profile, click Logout
- Returns to Login screen

## 🐛 Common Issues & Solutions

### Issue: "Target of URI doesn't exist" errors
**Solution:** Run `flutter pub get` again

### Issue: Firebase initialization failed
**Solution:** 
- Verify `firebase_options.dart` has correct values
- Re-run `flutterfire configure`
- Make sure Firebase project has a default location set

### Issue: No food items showing
**Solution:**
- Check Firestore has `foods` collection
- Verify documents have `isAvailable: true`
- Check security rules allow reading

### Issue: Cannot create account
**Solution:**
- Enable Email/Password in Firebase Authentication
- Password must be 6+ characters
- Use unique email for each account

### Issue: "Building with plugins requires symlink support" (Windows)
**Solution:**
- Enable Developer Mode: `start ms-settings:developers`
- Or continue without - this is just a warning

### Issue: Build fails on Android
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: Build fails on iOS
**Solution:**
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

## 📊 Firebase Console Quick Links

After setup, bookmark these:

- **Authentication**: Check registered users
  ```
  console.firebase.google.com/project/YOUR_PROJECT/authentication/users
  ```

- **Firestore Data**: View/edit database
  ```
  console.firebase.google.com/project/YOUR_PROJECT/firestore/data
  ```

- **Firestore Rules**: Edit security rules
  ```
  console.firebase.google.com/project/YOUR_PROJECT/firestore/rules
  ```

## 🎯 Development Tips

### Hot Reload
- Save any file → Auto hot reload
- Press `r` in terminal for manual hot reload
- Press `R` for hot restart

### Debug Mode
```bash
flutter run --debug
# Enables debug banner, debug prints, performance overlay
```

### Add More Food Items
In Firestore console, duplicate existing food document and modify:
- Change `id` and `name`
- Update `description`, `price`, `category`
- Use Unsplash for free images: `https://source.unsplash.com/800x600/?food,{category}`

### Monitor Firestore Usage
```
Firebase Console → Firestore Database → Usage tab
```

### View Logs
```bash
flutter logs
# Or in VS Code: Debug Console
```

## 🎨 Customization Ideas

### Change Theme Color
In `main.dart`:
```dart
theme: ThemeData(
  primarySwatch: Colors.blue,  // Change to: red, green, purple, etc.
```

### Add More Categories
Update food documents with new categories:
- `"category": "Drinks"`
- `"category": "Appetizers"`
- `"category": "Sides"`

### Modify Food Card Layout
Edit `home_screen.dart` → `FoodCard` widget

## 📱 Platform-Specific Setup

### Android
- Minimum SDK: 21 (Android 5.0)
- In `android/app/build.gradle`:
  ```gradle
  minSdkVersion 21
  targetSdkVersion 33
  ```

### iOS
- Minimum iOS: 12.0
- In `ios/Podfile`:
  ```ruby
  platform :ios, '12.0'
  ```

## 🚀 Deployment

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS (requires Mac)
```bash
flutter build ios --release
# Then open in Xcode to sign and submit
```

## 📞 Support

If you encounter issues:
1. Check [Flutter Docs](https://docs.flutter.dev/)
2. Check [Firebase Docs](https://firebase.google.com/docs)
3. Run `flutter doctor` to verify setup
4. Check the README.md for architecture details

## ✅ Verification Checklist

Before considering setup complete:

- [ ] `flutter pub get` runs without errors
- [ ] `flutter doctor` shows no critical issues
- [ ] Firebase project created
- [ ] Authentication enabled (Email/Password)
- [ ] Firestore database created
- [ ] At least 3 food items added to Firestore
- [ ] Security rules configured
- [ ] App builds and runs: `flutter run`
- [ ] Can sign up new user
- [ ] Can see food items on home screen
- [ ] Can add items to cart
- [ ] Can place order
- [ ] Can view orders
- [ ] Can edit profile
- [ ] Can logout

## 🎓 Next Steps

After successful setup:
1. Create test account and place orders
2. Add more food variety
3. Test on different devices/emulators
4. Explore the codebase
5. Customize UI/UX to your liking

Happy coding! 🎉
