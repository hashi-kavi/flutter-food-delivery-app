// lib/providers/food_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

class FoodProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Food> _foods = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Food> get foods => _foods;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all foods
  Future<void> fetchFoods() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('foods').get();
      _foods = snapshot.docs.map((doc) => Food.fromMap(doc.data())).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch foods: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new food
  Future<bool> addFood(Food food) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final docRef = _firestore.collection('foods').doc();
      final newFood = food.copyWith(id: docRef.id);

      await docRef.set(newFood.toMap());

      _foods.add(newFood);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add food: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update existing food
  Future<bool> updateFood(Food food) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('foods').doc(food.id).update(food.toMap());

      final index = _foods.indexWhere((f) => f.id == food.id);
      if (index != -1) {
        _foods[index] = food;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update food: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete food
  Future<bool> deleteFood(String foodId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firestore.collection('foods').doc(foodId).delete();

      _foods.removeWhere((f) => f.id == foodId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete food: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Toggle availability
  Future<bool> toggleAvailability(String foodId, bool isAvailable) async {
    try {
      await _firestore.collection('foods').doc(foodId).update({
        'isAvailable': isAvailable,
      });

      final index = _foods.indexWhere((f) => f.id == foodId);
      if (index != -1) {
        _foods[index] = _foods[index].copyWith(isAvailable: isAvailable);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to toggle availability: $e';
      notifyListeners();
      return false;
    }
  }
}
