# How to Add Food Items to Your App

## Quick Answer
**YES**, you need to add food items to Firebase. The home screen displays foods from your Firebase database, not from mock data.

---

## Option 1: Using the Admin Screen (Easiest) ⭐

### Step 1: Navigate to Admin Screen
Add this route to your main.dart or navigation:

```dart
// Open Admin Screen
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const AdminScreen()),
);
```

### Step 2: Click "Add Sample Foods to Firebase"
- Opens the admin screen
- Click the green button to add 10 sample foods
- Wait for confirmation message

### Step 3: Refresh Home Screen
- Go back to home screen
- Foods will now appear automatically

---

## Option 2: Manual Firebase Console Upload

### Step 1: Go to Firebase Console
1. Open [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Firestore Database**

### Step 2: Create Collection
1. Click **+ Start Collection**
2. Name it: `foods`
3. Click **Next**

### Step 3: Add Food Document
Click **+ Add Document** and create entries with this structure:

```json
{
  "id": "1",
  "name": "Margherita Pizza",
  "description": "Classic pizza with tomato sauce, mozzarella, and basil",
  "price": 12.99,
  "imageUrl": "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400",
  "category": "Pizza",
  "isAvailable": true
}
```

### Required Fields:
| Field | Type | Example |
|-------|------|---------|
| `id` | String | "1", "2", etc |
| `name` | String | "Margherita Pizza" |
| `description` | String | "Classic pizza..." |
| `price` | Number | 12.99 |
| `imageUrl` | String | URL to food image |
| `category` | String | Pizza, Burger, Dessert, Drinks, Asian |
| `isAvailable` | Boolean | true/false |

---

## Option 3: Programmatic Upload (Dart Code)

### In your app code:
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addFood() async {
  final firestore = FirebaseFirestore.instance;
  
  await firestore.collection('foods').doc('1').set({
    'id': '1',
    'name': 'Margherita Pizza',
    'description': 'Classic pizza with tomato sauce',
    'price': 12.99,
    'imageUrl': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
    'category': 'Pizza',
    'isAvailable': true,
  });
}
```

---

## Food Categories Available

The app currently supports these categories:

- 🍕 **Pizza**
- 🍔 **Burger**
- 🍰 **Dessert**
- 🥤 **Drinks**
- 🍜 **Asian**

*(These are hardcoded in home_screen.dart line 72-78)*

---

## Where to Find Images

Use free image URLs from:
- **Unsplash**: https://unsplash.com (copy image URL)
- **Pexels**: https://pexels.com
- **Pixabay**: https://pixabay.com
- **Your own images**: Upload to Firebase Storage

---

## Adding Custom Foods

### Method 1: Via Admin Screen
Create a custom food and pass to seeder:

```dart
final food = Food(
  id: '99',
  name: 'Your Dish Name',
  description: 'Your description',
  price: 9.99,
  imageUrl: 'image-url-here',
  category: 'Pizza', // Must match existing categories
  isAvailable: true,
);

final seeder = FirebaseFoodSeeder();
await seeder.addFood(food);
```

### Method 2: Edit the Seeder
Edit `lib/services/firebase_food_seeder.dart` and modify the `getSampleFoods()` method to add your custom foods.

---

## Troubleshooting

### Foods Not Showing on Home Screen?

1. **Check Firebase Rules**
   - Go to Firestore Rules
   - Ensure read is allowed:
   ```
   match /databases/{database}/documents {
     match /foods/{document=**} {
       allow read: if true;
       allow write: if false; // Or your auth logic
     }
   }
   ```

2. **Check Data Structure**
   - Ensure all required fields exist
   - Field names must match exactly (case-sensitive)
   - `isAvailable` must be boolean, not string

3. **Check Image URLs**
   - Images must be publicly accessible
   - URLs should end with `?w=400` or similar for optimization

4. **Hot Reload Not Working**
   - Do a full hot restart: `flutter run --hot`
   - Or stop and restart the app

### Foods Appear But No Images?

- Check if image URLs are valid (copy URL in browser)
- Ensure images are publicly accessible
- Try different Unsplash image URLs

### "Collection Not Found" Error?

- Ensure collection name is exactly `foods` (lowercase)
- Check Firebase project is connected properly
- Verify Firebase initialization in main.dart

---

## Summary

| Method | Ease | Speed | Best For |
|--------|------|-------|----------|
| Admin Screen | ⭐⭐⭐ | ⭐⭐⭐ | First-time setup |
| Firebase Console | ⭐⭐ | ⭐⭐ | Manual control |
| Code | ⭐⭐⭐ | ⭐⭐ | Custom logic |

**Recommended**: Use **Admin Screen** (Option 1) for quickest setup!
