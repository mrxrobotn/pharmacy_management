import 'package:flutter/material.dart';
import '../functions.dart';

class UserModel with ChangeNotifier {
  final String uid;
  late final String email;
  late final String name;
  late final Role role;
  late final bool canAccess;
  final String thumbnail;
  String? telephone;
  String? address;
  String? schedule;
  String? token;
  int? coupon;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.canAccess,
    required this.thumbnail,
    this.telephone,
    this.address,
    this.schedule,
    this.token,
    this.coupon,
  });
}
