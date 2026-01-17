# Food Delivery App

A Flutter-based food delivery application with Firebase backend, implementing clean architecture principles.

## 🏗️ Architecture Overview

This application follows **clean architecture** with clear separation of concerns:

- **Models**: Pure Dart classes representing data structures
- **Services**: Firebase operations and business logic
- **Providers**: State management using Provider package
- **Screens**: UI components

### Data Flow
```
Screens → Providers → Services → Firebase
```

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point & Firebase initialization
├── firebase_options.dart               # Firebase configuration (auto-generated)
├── models/                             # Data models
│   ├── user.dart                       # User model
│   ├── food.dart                       # Food item model
│   └── order.dart                      # Order & OrderItem models
├── services/                           # Firebase services
│   ├── firebase_auth_service.dart      # Authentication logic
│   ├── firebase_food_service.dart      # Food data operations
│   └── firebase_order_service.dart     # Order management
├── providers/                          # State management
│   ├── auth_provider.dart              # Auth state
│   ├── cart_provider.dart              # Cart state (local)
│   └── order_provider.dart             # Order state
└── screens/                            # UI screens
    ├── login_screen.dart               # User login
    ├── signup_screen.dart              # User registration
    ├── home_screen.dart                # Food listing
    ├── food_details_screen.dart        # Food details & add to cart
    ├── cart_screen.dart                # Cart view & checkout
    ├── order_screen.dart               # Order history
    └── profile_screen.dart             # User profile management
```

## ✨ Features

### Authentication
- Email/password signup and login
- User profile management
- Persistent authentication state

### Food Browsing
- View available food items
- Food details with description and pricing
- Category-based organization

### Shopping Cart
- Add/remove items
- Quantity management
- Real-time total calculation
- Local state (not persisted)

### Orders
- Place orders from cart
- View order history
- Order status tracking (pending, preparing, delivered, cancelled)
- Order details view

### Profile
- View and edit user information
- Update name, phone, and address
- Display user email

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Step 1: Clone and Install Dependencies

```bash
cd test
flutter pub get
```

### Step 2: Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project
   - Enable Firebase Authentication and Cloud Firestore

2. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```
   This will automatically update `firebase_options.dart`

3. **Enable Authentication**
   - In Firebase Console → Authentication
   - Enable Email/Password sign-in method

4. **Setup Firestore Database**
   - In Firebase Console → Firestore Database
   - Create database in **test mode** (for development)
   - Add a `foods` collection with sample data:

   ```json
   {
     "id": "food1",
     "name": "Margherita Pizza",
     "description": "Classic pizza with tomato sauce, mozzarella, and fresh basil",
     "price": 12.99,
     "imageUrl": "https://example.com/pizza.jpg",
     "category": "Pizza",
     "isAvailable": true
   }
   ```

   **Sample Food Items** (add multiple for better testing):
   - Pizza (Margherita, Pepperoni)
   - Burgers (Classic, Cheese)
   - Pasta (Carbonara, Alfredo)
   - Desserts (Ice Cream, Cake)

### Step 3: Run the Application

```bash
flutter run
```

## 📱 Usage Flow

1. **First Time Users**
   - Open app → Signup screen
   - Enter name, email, password
   - Auto-login after signup

2. **Returning Users**
   - Auto-login if previously authenticated
   - Manual login if logged out

3. **Browsing & Ordering**
   - Browse food items on home screen
   - Tap food card to view details
   - Add items to cart
   - Navigate to cart → Place order
   - View orders in Orders tab

4. **Profile Management**
   - Go to Profile tab
   - Edit name, phone, address
   - Save changes

## 🔒 Firebase Security Rules

### Firestore Rules (Development)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Foods collection (read-only for users)
    match /foods/{foodId} {
      allow read: if true;
      allow write: if false;  // Only admin can write
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      allow update: if false;  // Orders cannot be updated by users
    }
  }
}
```

## 🛠️ Technical Details

### Dependencies
- `firebase_core`: ^3.8.1 - Firebase initialization
- `firebase_auth`: ^5.3.4 - Authentication
- `cloud_firestore`: ^5.5.2 - Database
- `provider`: ^6.1.2 - State management

### State Management
- **Provider** package for reactive state
- Separate providers for Auth, Cart, and Orders
- Cart state is local (not persisted to Firebase)

### Data Models
- **AppUser**: User profile data
- **Food**: Food item information
- **Order**: Order details with items
- **OrderItem**: Individual food items in an order

## 🚧 Limitations (By Design)

This is a 2-day project with specific scope constraints:

- ❌ No admin panel
- ❌ No real-time delivery tracking
- ❌ No payment gateway integration
- ❌ No food search functionality
- ❌ Cart is not persisted (clears on app restart)
- ❌ No order editing after placement
- ❌ No push notifications

## 🐛 Troubleshooting

### Firebase initialization error
- Ensure `flutterfire configure` was run successfully
- Check `firebase_options.dart` has correct configuration

### No food items showing
- Verify Firestore has `foods` collection with data
- Check Firestore security rules allow reading

### Login/Signup fails
- Verify Firebase Authentication is enabled
- Check email format is valid
- Ensure password is at least 6 characters

### Build errors
- Run `flutter clean && flutter pub get`
- Verify Flutter version: `flutter --version`

## 📄 License

This project is for educational purposes.

## 👨‍💻 Development

Built with Flutter & Firebase following clean architecture principles.
