import 'package:flutter/material.dart';

class Product {
  final String productUID;
  final int quantity;

  Product({
    required this.productUID,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productUID': productUID,
      'quantity': quantity,
    };
  }
}

class OrderModel with ChangeNotifier {
  final String uid;
  final String number;
  final String orderBy;
  final String status;
  final String totalAmount;
  final String paymentDetails;
  final String orderTime;
  final Map<String, Product> products;

  OrderModel({
    required this.uid,
    required this.number,
    required this.orderBy,
    required this.status,
    required this.totalAmount,
    required this.paymentDetails,
    required this.orderTime,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'number': number,
      'orderBy': orderBy,
      'status': status,
      'totalAmount': totalAmount,
      'paymentDetails': paymentDetails,
      'orderTime': orderTime,
      'products': products.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}
