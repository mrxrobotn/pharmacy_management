import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:pharmacy_management/controllers/notifications_api.dart';

class MedicineModel with ChangeNotifier {
  final String uid;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final String ownerUID;
  final String thumbnail;
  final String expiration;
  final String availability;

  MedicineModel({
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.ownerUID,
    required this.thumbnail,
    required this.expiration,
    required this.availability,
  });

  // Add fromSnapshot method to create a MedicineModel from a Firestore document
  factory MedicineModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MedicineModel(
      uid: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? 0,
      quantity: data['quantity'] ?? 0,
      ownerUID: data['ownerUID'] ?? '',
      thumbnail: data['thumbnail'] ?? '',
      expiration: data['expiration'] ?? '',
      availability: data['availability'] ?? '',
    );
  }

  // Function to check quantity and send notification
  void checkQuantityAndNotify(String recipientToken) {
    if (quantity <= 5 && quantity !=0) {
      _sendLowStockNotification(recipientToken);
    } else if (quantity == 0) {
      _sendEmptyStockNotification(recipientToken);
    }
  }

  // Function to send low stock notification
  Future<void> _sendLowStockNotification(String recipientToken) async {
    bool result = await sendNotificationMessage(
      recipientToken: recipientToken,
      title: 'Alerte de stock faible',
      body: 'La quantité du produit $name est faible. Il ne reste que $quantity.',
    );
    if (result) {
      devtools.log('Notification sent successfully.');
    } else {
      devtools.log('Failed to send notification.');
    }
  }

  // Function to send low stock notification
  Future<void> _sendEmptyStockNotification(String recipientToken) async {
    bool result = await sendNotificationMessage(
      recipientToken: recipientToken,
      title: 'Rupture de stock',
      body: 'Le produit $name est épuisé, merci de contacter un fournisseur.',
    );
    if (result) {
      devtools.log('Notification sent successfully.');
    } else {
      devtools.log('Failed to send notification.');
    }
  }
}
