import 'package:flutter/material.dart';

class MedicineModel with ChangeNotifier {
  final String uid;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final String ownerUID;
  final String thumbnail;
  final String expiration;

  MedicineModel({
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.ownerUID,
    required this.thumbnail,
    required this.expiration,
  });
}
