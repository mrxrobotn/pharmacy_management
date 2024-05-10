import 'package:flutter/material.dart';

class AnswerModel with ChangeNotifier {
  final String uid;
  final String answer;
  final String senderUID;

  AnswerModel({
    required this.uid,
    required this.answer,
    required this.senderUID,
  });
}
