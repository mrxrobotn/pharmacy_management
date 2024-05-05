import 'package:flutter/material.dart';

class ChatModel with ChangeNotifier {
  final String uid;
  final String name;

  ChatModel({
    required this.uid,
    required this.name,

  });
}