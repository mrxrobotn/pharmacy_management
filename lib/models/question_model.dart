import 'package:flutter/material.dart';

class QuestionModel with ChangeNotifier {
  final String uid;
  final String content;
  final String senderUID;

  QuestionModel({
    required this.uid,
    required this.content,
    required this.senderUID,
  });
}
