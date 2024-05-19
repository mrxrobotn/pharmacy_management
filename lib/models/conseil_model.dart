import 'package:flutter/material.dart';

class ConseilModel with ChangeNotifier {
  final String content;
  final String senderUID;
  final String productUID;

  ConseilModel({
    required this.content,
    required this.senderUID,
    required this.productUID,
  });
}
