import 'package:cloud_firestore/cloud_firestore.dart';
import '../functions.dart';
import '../models/stock_model.dart';

class StockController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'stockorders';

  // Create a new stock
  Future<void> createStock(StockModel stock) async {
    try {
      await _firestore.collection(collectionName).add(stock.toMap());
    } catch (e) {
      print('Error creating stock: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getOrders(String status) {
    try {
      return stockorders
          .where('orderBy', isEqualTo: userUID)
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



  // Read all stocks
  Stream<List<StockModel>> getStocks() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => StockModel.fromMap(doc.data())).toList());
  }

  // Update an existing stock
  Future<void> updateStock(StockModel stock) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(stock.productUID)
          .update(stock.toMap());
    } catch (e) {
      print('Error updating stock: $e');
    }
  }

  // Delete a stock
  Future<void> deleteStock(String productUID) async {
    try {
      await _firestore.collection(collectionName).doc(productUID).delete();
    } catch (e) {
      print('Error deleting stock: $e');
    }
  }
}