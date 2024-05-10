import 'package:flutter/material.dart';

class ConseilModel with ChangeNotifier {
  final String uid;
  final String content;
  final String senderUID;
  final String productUID;

  ConseilModel({
    required this.uid,
    required this.content,
    required this.senderUID,
    required this.productUID,
  });
}
