// lib/services/firebase_food_seeder.dart
// This service helps seed initial food data to Firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

class FirebaseFoodSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sample foods to add to Firebase
  List<Food> getSampleFoods() {
    return [
      Food(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Classic pizza with tomato sauce, mozzarella, and basil',
        price: 12.99,
        imageUrl:
            'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
        category: 'Pizza',
        isAvailable: true,
      ),
      Food(
        id: '2',
        name: 'Cheese Burger',
        description: 'Juicy beef patty with cheese, lettuce, and special sauce',
        price: 8.99,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        category: 'Burger',
        isAvailable: true,
      ),
      Food(
        id: '3',
        name: 'Chocolate Cake',
        description: 'Rich chocolate cake with creamy frosting',
        price: 6.99,
        imageUrl:
            'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
        category: 'Dessert',
        isAvailable: true,
      ),
      Food(
        id: '4',
        name: 'Pepperoni Pizza',
        description: 'Loaded with pepperoni and extra cheese',
        price: 14.99,
        imageUrl:
            'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
        category: 'Pizza',
        isAvailable: true,
      ),
      Food(
        id: '5',
        name: 'Chicken Burger',
        description: 'Crispy chicken with mayo and fresh vegetables',
        price: 9.99,
        imageUrl:
            'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=400',
        category: 'Burger',
        isAvailable: true,
      ),
      Food(
        id: '6',
        name: 'Strawberry Smoothie',
        description: 'Fresh strawberry smoothie with yogurt',
        price: 5.99,
        imageUrl:
            'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=400',
        category: 'Drinks',
        isAvailable: true,
      ),
      Food(
        id: '7',
        name: 'Ramen Bowl',
        description: 'Authentic Japanese ramen with pork and egg',
        price: 13.99,
        imageUrl:
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
        category: 'Asian',
        isAvailable: true,
      ),
      Food(
        id: '8',
        name: 'Tiramisu',
        description: 'Classic Italian dessert with coffee and mascarpone',
        price: 7.99,
        imageUrl:
            'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
        category: 'Dessert',
        isAvailable: true,
      ),
      Food(
        id: '9',
        name: 'Iced Coffee',
        description: 'Cold brew coffee with ice and milk',
        price: 4.99,
        imageUrl:
            'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
        category: 'Drinks',
        isAvailable: true,
      ),
      Food(
        id: '10',
        name: 'Pad Thai',
        description: 'Thai stir-fried noodles with shrimp and peanuts',
        price: 11.99,
        imageUrl:
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400',
        category: 'Asian',
        isAvailable: true,
      ),
    ];
  }

  // Add single food to Firebase
  Future<void> addFood(Food food) async {
    try {
      await _firestore.collection('foods').doc(food.id).set(food.toMap());
      print('✓ Added ${food.name} to Firebase');
    } catch (e) {
      print('✗ Error adding food: $e');
      rethrow;
    }
  }

  // Add all sample foods to Firebase
  Future<void> seedAllFoods() async {
    try {
      final foods = getSampleFoods();
      
      for (var food in foods) {
        await _firestore.collection('foods').doc(food.id).set(food.toMap());
        print('✓ Added ${food.name}');
      }
      
      print('\n✓ Successfully added ${foods.length} foods to Firebase!');
    } catch (e) {
      print('✗ Error seeding foods: $e');
      rethrow;
    }
  }

  // Check if foods already exist
  Future<bool> foodsExist() async {
    try {
      final snapshot = await _firestore.collection('foods').limit(1).get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('✗ Error checking foods: $e');
      return false;
    }
  }

  // Delete all foods (use with caution)
  Future<void> deleteAllFoods() async {
    try {
      final snapshot = await _firestore.collection('foods').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('✓ Deleted all foods from Firebase');
    } catch (e) {
      print('✗ Error deleting foods: $e');
      rethrow;
    }
  }
}
