// lib/providers/order_provider.dart

import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/firebase_order_service.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseOrderService _orderService = FirebaseOrderService();
  
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => [..._orders];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Place new order
  Future<bool> placeOrder({
    required String userId,
    required List<OrderItem> items,
    String? deliveryAddress,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      double totalAmount = items.fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );

      Order newOrder = Order(
        id: '', // Will be set by Firestore
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        createdAt: DateTime.now(),
        deliveryAddress: deliveryAddress,
      );

      await _orderService.placeOrder(newOrder);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Load user orders
  void loadUserOrders(String userId) {
    _orderService.getUserOrders(userId).listen(
      (orders) {
        _orders = orders;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _orderService.cancelOrder(orderId);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
