// lib/providers/admin_order_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as app_models;

class AdminOrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<app_models.Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _newOrderCount = 0;

  List<app_models.Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get newOrderCount => _newOrderCount;

  // Listen to real-time order updates (admin view)
  void listenToOrders() {
    _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        final newOrders = snapshot.docs
            .map((doc) => app_models.Order.fromMap(doc.data()))
            .toList();

        // Count new pending orders
        _newOrderCount = newOrders.where((o) => o.status == 'pending').length;

        _orders = newOrders;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Failed to fetch orders: $error';
        notifyListeners();
      },
    );
  }

  // Fetch all orders (admin view) - one-time fetch
  Future<void> fetchAllOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs
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

  // Reset new order count
  void resetNewOrderCount() {
    _newOrderCount = 0;
    notifyListeners();
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local list
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: newStatus,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update order: $e';
      notifyListeners();
      return false;
    }
  }

  // Get orders by status
  List<app_models.Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Get total revenue
  double getTotalRevenue() {
    return _orders
        .where((order) => order.status == 'delivered')
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Get order count by status
  Map<String, int> getOrderCountByStatus() {
    final Map<String, int> counts = {
      'pending': 0,
      'preparing': 0,
      'delivering': 0,
      'delivered': 0,
    };

    for (var order in _orders) {
      counts[order.status] = (counts[order.status] ?? 0) + 1;
    }

    return counts;
  }
}
