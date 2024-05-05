import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/question_model.dart';

class QuestionController with ChangeNotifier {
  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  // Method to fetch questions from Firestore
  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('questions').get();
      _questions = querySnapshot.docs.map((doc) {
        return QuestionModel(
          uid: doc.id,
          content: doc['content'],
          senderUID: doc['senderUID'],
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching questions: $e");
    }
  }
}