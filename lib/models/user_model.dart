import 'package:flutter/material.dart';
import '../functions.dart';

class UserModel with ChangeNotifier {
  final String uid;
  final String email;
  final String name;
  final Role role;
  final bool canAccess;
  final String thumbnail;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.canAccess,
    required this.thumbnail,
  });
}
