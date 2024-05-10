import 'package:cloud_firestore/cloud_firestore.dart';
import '../functions.dart';
import '../models/order_model.dart';

class OrderController {

  Future<void> addOrder(OrderModel order) async {
    try {
      await orders.add(order.toMap());
    } catch (e) {
      print('Error adding order: $e');
      throw Exception('Failed to add order');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      QuerySnapshot querySnapshot = await orders.get();
      List<OrderModel> allOrders = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel(
          uid: doc.id,
          number: data['number'],
          orderBy: data['orderBy'],
          status: data['status'],
          totalAmount: data['totalAmount'],
          paymentDetails: data['paymentDetails'],
          orderTime: data['orderTime'],
          products: data['products'],
        );
      }).toList();
      return allOrders;
    } catch (e) {
      print('Error getting orders: $e');
      throw Exception('Failed to get orders');
    }
  }
}
