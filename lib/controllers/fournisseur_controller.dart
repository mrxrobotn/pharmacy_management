import 'package:cloud_firestore/cloud_firestore.dart';

import '../functions.dart';
import '../models/stock_model.dart';

class FournisseurController {
  Stream<List<Map<String, dynamic>>> getOrders(String status) {
    try {
      return stockorders
          .where('status', isEqualTo: status)
          .snapshots()
          .asyncMap((snapshot) async {
        List<Map<String, dynamic>> results = [];
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          results.add({
            'number': data['number'],
            'orderTime': data['orderTime'],
            'productUID': data['productUID'],
            'quantity': data['quantity'],
            'status': data['status'],
          });
        }
        return results;
      });
    } catch (e) {
      print('Error finding product: $e');
      throw Exception('Failed to find product');
    }
  }

  Future<StockModel?> getOrderByNumber(String orderNumber) async {
    try {
      QuerySnapshot querySnapshot = await stockorders.where('number', isEqualTo: orderNumber).get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return StockModel(
          number: data['number'],
          orderBy: data['orderBy'],
          status: data['status'],
          orderTime: data['orderTime'] as Timestamp,
          productUID: data['productUID'],
          quantity: data['quantity'],
          deliveryUID: data['deliveryUID'],

        );
      } else {
        return null; // Order not found
      }
    } catch (e) {
      print('Error getting order by number: $e');
      throw Exception('Failed to get order by number');
    }
  }


  Stream<List<Map<String, dynamic>>> getAcceptedOrders() {
    try {
      return stockorders
          .where('deliveryUID', isEqualTo: userUID)
          .where('status', isEqualTo: 'en cours')
          .snapshots()
          .asyncMap((snapshot) async {
        List<Map<String, dynamic>> results = [];
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          results.add({
            'number': data['number'],
            'orderTime': data['orderTime'],
            'productUID': data['productUID'],
            'quantity': data['quantity'],
            'status': data['status'],
          });
        }
        return results;
      });
    } catch (e) {
      print('Error finding product: $e');
      throw Exception('Failed to find product');
    }
  }

  Future<void> updateOrderByNumber(String orderNumber, Map<String, dynamic> updates) async {
    try {
      QuerySnapshot querySnapshot = await stockorders.where('number', isEqualTo: orderNumber).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await stockorders.doc(docId).update(updates);
        print('Order updated successfully.');
      } else {
        print('Order not found');
      }
    } catch (e) {
      print('Error updating order: $e');
    }
  }
}