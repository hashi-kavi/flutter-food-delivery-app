// lib/providers/cart_provider.dart

import 'package:flutter/foundation.dart';
import '../models/food.dart';
import '../models/order.dart';

class CartItem {
  final Food food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });

  double get totalPrice => food.price * quantity;
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};
  
  int get itemCount => _items.length;
  
  int get totalQuantity {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  bool get isEmpty => _items.isEmpty;

  // Add item to cart
  void addItem(Food food) {
    if (_items.containsKey(food.id)) {
      _items[food.id]!.quantity++;
    } else {
      _items[food.id] = CartItem(food: food, quantity: 1);
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeItem(String foodId) {
    _items.remove(foodId);
    notifyListeners();
  }

  // Increase quantity
  void increaseQuantity(String foodId) {
    if (_items.containsKey(foodId)) {
      _items[foodId]!.quantity++;
      notifyListeners();
    }
  }

  // Decrease quantity
  void decreaseQuantity(String foodId) {
    if (_items.containsKey(foodId)) {
      if (_items[foodId]!.quantity > 1) {
        _items[foodId]!.quantity--;
      } else {
        _items.remove(foodId);
      }
      notifyListeners();
    }
  }

  // Clear cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Convert cart to order items
  List<OrderItem> getOrderItems() {
    return _items.values.map((cartItem) {
      return OrderItem(
        foodId: cartItem.food.id,
        foodName: cartItem.food.name,
        price: cartItem.food.price,
        quantity: cartItem.quantity,
      );
    }).toList();
  }
}
