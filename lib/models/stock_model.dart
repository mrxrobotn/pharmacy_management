import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StockModel with ChangeNotifier {
  final String number;
  final String productUID;
  final String orderBy;
  final String quantity;
  late String? deliveryUID;
  final String status;
  final Timestamp orderTime;

  StockModel({
    required this.number,
    required this.productUID,
    required this.orderBy,
    required this.quantity,
    required this.deliveryUID,
    required this.status,
    required this.orderTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'productUID': productUID,
      'orderBy': orderBy,
      'quantity': quantity,
      'deliveryUID': deliveryUID,
      'status': status,
      'orderTime': orderTime,
    };
  }

  factory StockModel.fromMap(Map<String, dynamic>? map) {
    return StockModel(
      productUID: map?['productUID'] ?? '',
      orderBy: map?['orderBy'] ?? '',
      quantity: map?['quantity'] ?? '',
      deliveryUID: map?['deliveryUID'] ?? '',
      status: map?['status'] ?? '',
      orderTime: map?['orderTime'] ?? Timestamp.now(),
      number: map?['number'] ?? '',
    );
  }
}
