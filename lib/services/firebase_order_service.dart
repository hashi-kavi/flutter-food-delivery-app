// lib/services/firebase_order_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as app_models;

class FirebaseOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Place a new order
  Future<String> placeOrder(app_models.Order order) async {
    try {
      DocumentReference docRef = await _firestore.collection('orders').add(order.toMap());
      
      // Update order with generated ID
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw 'Failed to place order';
    }
  }

  // Get user orders
  Stream<List<app_models.Order>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => app_models.Order.fromMap(doc.data()))
          .toList();
    });
  }

  // Get order by ID
  Future<app_models.Order?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('orders').doc(orderId).get();

      if (doc.exists) {
        return app_models.Order.fromMap(doc.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      throw 'Failed to fetch order details';
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
    } catch (e) {
      throw 'Failed to update order status';
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      await updateOrderStatus(orderId, 'cancelled');
    } catch (e) {
      throw 'Failed to cancel order';
    }
  }
}
