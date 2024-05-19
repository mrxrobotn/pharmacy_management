import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/models/conseil_model.dart';

import '../functions.dart';

class ConseilController with ChangeNotifier {

  // Method to fetch advices from Firestore
  Future<ConseilModel?> fetchAdvicesByProductId(String id) async {
    try {
      DocumentSnapshot doc = await medicines.doc(id).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


        return ConseilModel(
            content: data['content'].toString(),
            senderUID: data['senderUID'] ,
            productUID: data['productUID']
        );
      } else {
        print('Product with ID $id does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting Product data: $e');
      return null;
    }
  }

  Future<void> addNewAdvice(ConseilModel conseil) async {
    try {
      await advices.add({
        'content': conseil.content,
        'senderUID': conseil.senderUID,
        'productUID': conseil.productUID,
      });
      notifyListeners();
      print('New advice added successfully');
    } catch (e) {
      print('Error adding new advice: $e');
    }
  }
}
