import 'package:cloud_firestore/cloud_firestore.dart';
import '../functions.dart';
import '../models/order_model.dart';

class OrderController {

  Future<void> addOrder(OrderModel order) async {
    try {
      // Create a new document in the "medicines" collection
      DocumentReference docRef = await orders.add({
        'number': order.number,
        'orderBy': order.orderBy,
        'deliveryUID': order.deliveryUID,
        'status': order.status,
        'totalAmount': order.totalAmount,
        'paymentDetails': order.paymentDetails,
        'orderTime': order.orderTime,
        'products': order.products,
        'productsOwners': order.productsOwners,
      });

      // Retrieve the ID of the newly created document
      String docId = docRef.id;

      // Update the document with the UID
      await medicines.doc(docId).update({
        'uid': docId,
      });
    } catch (e) {
      print('Error saving order: $e');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      QuerySnapshot querySnapshot = await orders.get();
      List<OrderModel> allOrders = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel(
          number: data['number'],
          orderBy: data['orderBy'],
          deliveryUID: data['deliveryUID'],
          status: data['status'],
          totalAmount: data['totalAmount'],
          paymentDetails: data['paymentDetails'],
          orderTime: data['orderTime'],
          products: data['products'],
          productsOwners: data['productsOwners'],
        );
      }).toList();
      return allOrders;
    } catch (e) {
      print('Error getting orders: $e');
      throw Exception('Failed to get orders');
    }
  }

  Future<OrderModel?> getOrderByNumber(String orderNumber) async {
    try {
      QuerySnapshot querySnapshot = await orders.where('number', isEqualTo: orderNumber).get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return OrderModel(
          number: data['number'],
          orderBy: data['orderBy'],
          deliveryUID: data['deliveryUID'],
          status: data['status'],
          totalAmount: data['totalAmount'],
          paymentDetails: data['paymentDetails'],
          orderTime: data['orderTime'] as Timestamp,
          products: List<String>.from(data['products']),
          productsOwners: List<String>.from(data['productsOwners']),
        );
      } else {
        return null; // Order not found
      }
    } catch (e) {
      print('Error getting order by number: $e');
      throw Exception('Failed to get order by number');
    }
  }

  Future<String> getProductName(String productId) async {
    try {
      QuerySnapshot querySnapshot = await medicines.where('uid', isEqualTo: productId).get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['name'];
      } else {
        return 'Unknown'; // Product not found
      }
    } catch (e) {
      print('Error getting product name: $e');
      throw Exception('Failed to get product name');
    }
  }

  Stream<List<Map<String, dynamic>>> findDeliveredProductStreams(String userUID, String status) {
    try {
      return orders
          .where('productsOwners', arrayContains: userUID)
          .where('status', isEqualTo: status)
          .snapshots()
          .asyncMap((snapshot) async {
        List<Map<String, dynamic>> results = [];
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          for (var productId in data['products']) {
            results.add({
              'orderNumber': data['number'],
              'orderBy': data['orderBy'],
              'deliveryUID': data['deliveryUID'],
              'productName': await getProductName(productId),
              'status': data['status'],
              'totalAmount': data['totalAmount'],
              'products': data['products'],
              'productsOwners': data['productsOwners'],
            });
          }
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
      QuerySnapshot querySnapshot = await orders.where('number', isEqualTo: orderNumber).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await orders.doc(docId).update(updates);
        print('Order updated successfully.');
      } else {
        print('Order not found');
      }
    } catch (e) {
      print('Error updating order: $e');
    }
  }
}
