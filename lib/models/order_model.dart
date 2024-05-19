import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModel with ChangeNotifier {
  final String number;
  final String orderBy;
  final String status;
  final String totalAmount;
  final String paymentDetails;
  final Timestamp orderTime;
  final List<String> products;
  final List<String> productsOwners;

  OrderModel({
    required this.number,
    required this.orderBy,
    required this.status,
    required this.totalAmount,
    required this.paymentDetails,
    required this.orderTime,
    required this.products,
    required this.productsOwners,
  });
}
