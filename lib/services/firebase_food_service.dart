// lib/services/firebase_food_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

class FirebaseFoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all available foods
  Stream<List<Food>> getFoods() {
    return _firestore
        .collection('foods')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data()))
          .toList();
    });
  }

  // Get food by ID
  Future<Food?> getFoodById(String foodId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('foods').doc(foodId).get();

      if (doc.exists) {
        return Food.fromMap(doc.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      throw 'Failed to fetch food details';
    }
  }

  // Get foods by category
  Stream<List<Food>> getFoodsByCategory(String category) {
    return _firestore
        .collection('foods')
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data()))
          .toList();
    });
  }

  // Search foods by name
  Future<List<Food>> searchFoods(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('foods')
          .where('isAvailable', isEqualTo: true)
          .get();

      List<Food> allFoods = snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Filter by query
      return allFoods
          .where((food) =>
              food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw 'Failed to search foods';
    }
  }
}
