// lib/providers/analytics_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as app_models;

class AnalyticsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<app_models.Order> _allOrders = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all orders for analytics
  Future<void> fetchOrdersForAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      _allOrders = snapshot.docs
          .map((doc) => app_models.Order.fromMap(doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch orders: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate total revenue
  double get totalRevenue {
    return _allOrders
        .where((order) => order.status == 'delivered')
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Get total orders count
  int get totalOrdersCount => _allOrders.length;

  // Get delivered orders count
  int get deliveredOrdersCount =>
      _allOrders.where((order) => order.status == 'delivered').length;

  // Get pending orders count
  int get pendingOrdersCount =>
      _allOrders.where((order) => order.status == 'pending').length;

  // Get most ordered foods
  List<FoodStat> getMostOrderedFoods({int limit = 5}) {
    final foodMap = <String, FoodStat>{};

    for (var order in _allOrders) {
      for (var item in order.items) {
        if (foodMap.containsKey(item.foodId)) {
          foodMap[item.foodId]!.quantity += item.quantity;
          foodMap[item.foodId]!.revenue += (item.price * item.quantity);
        } else {
          foodMap[item.foodId] = FoodStat(
            foodId: item.foodId,
            foodName: item.foodName,
            quantity: item.quantity,
            revenue: (item.price * item.quantity),
          );
        }
      }
    }

    final sortedFoods = foodMap.values.toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    return sortedFoods.take(limit).toList();
  }

  // Get orders per day for the last N days
  Map<String, int> getOrdersPerDay({int days = 7}) {
    final now = DateTime.now();
    final ordersByDay = <String, int>{};

    // Initialize all days with 0
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.month}/${date.day}';
      ordersByDay[dateKey] = 0;
    }

    // Count orders for each day
    for (var order in _allOrders) {
      final orderDate = order.createdAt;
      final daysDiff = now.difference(orderDate).inDays;

      if (daysDiff < days) {
        final dateKey = '${orderDate.month}/${orderDate.day}';
        ordersByDay[dateKey] = (ordersByDay[dateKey] ?? 0) + 1;
      }
    }

    return ordersByDay;
  }

  // Get revenue per day for the last N days
  Map<String, double> getRevenuePerDay({int days = 7}) {
    final now = DateTime.now();
    final revenueByDay = <String, double>{};

    // Initialize all days with 0
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.month}/${date.day}';
      revenueByDay[dateKey] = 0.0;
    }

    // Sum revenue for each day (only delivered orders)
    for (var order in _allOrders.where((o) => o.status == 'delivered')) {
      final orderDate = order.createdAt;
      final daysDiff = now.difference(orderDate).inDays;

      if (daysDiff < days) {
        final dateKey = '${orderDate.month}/${orderDate.day}';
        revenueByDay[dateKey] =
            (revenueByDay[dateKey] ?? 0) + order.totalAmount;
      }
    }

    return revenueByDay;
  }

  // Get average order value
  double get averageOrderValue {
    final deliveredOrders =
        _allOrders.where((order) => order.status == 'delivered').toList();
    if (deliveredOrders.isEmpty) return 0.0;
    return totalRevenue / deliveredOrders.length;
  }
}

// Helper class for food statistics
class FoodStat {
  final String foodId;
  final String foodName;
  int quantity;
  double revenue;

  FoodStat({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.revenue,
  });
}
