import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatModel with ChangeNotifier {
  final String senderUID;
  final String senderEmail;
  final String receiverUID;
  final String message;
  final Timestamp timestamp;

  ChatModel({
      required this.senderUID,
      required this.senderEmail,
      required this.receiverUID,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap () {
    return {
      'senderUID': senderUID,
      'senderEmail': senderEmail,
      'receiverUID': receiverUID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
