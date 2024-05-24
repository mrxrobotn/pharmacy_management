import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModel with ChangeNotifier {
  final String number;
  final String orderBy;
  late String? deliveryUID;
  final String status;
  final String totalAmount;
  final String paymentDetails;
  final Timestamp orderTime;
  final List<String> products;
  final List<String> productsOwners;

  OrderModel({
    required this.number,
    required this.orderBy,
    this.deliveryUID,
    required this.status,
    required this.totalAmount,
    required this.paymentDetails,
    required this.orderTime,
    required this.products,
    required this.productsOwners,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      number: data['number'],
      orderBy: data['orderBy'],
      deliveryUID: data['deliveryUID'],
      status: data['status'],
      totalAmount: data['totalAmount'],
      paymentDetails: data['paymentDetails'],
      orderTime: data['orderTime'],
      products: List<String>.from(data['products']),
      productsOwners: List<String>.from(data['productsOwners']),
    );
  }
}
