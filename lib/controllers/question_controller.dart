import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../functions.dart';
import '../models/answer_model.dart';
import '../models/question_model.dart';

class QuestionController with ChangeNotifier {
  List<QuestionModel> _question = [];

  List<QuestionModel> get question => _question;

  // Method to fetch questions from Firestore
  Future<List<QuestionModel>> fetchQuestions() async {
    try {
      QuerySnapshot querySnapshot =
      await questions.get();
      List<QuestionModel> allquestions = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return QuestionModel(
          uid: data['uid'],
          content: data['content'],
          senderUID: data['senderUID'],
        );
      }).toList();
      return allquestions;
    } catch (e) {
      print('Error getting all questions: $e');
      return [];
    }
  }

  Future<void> addQuestion(QuestionModel question) async {
    DocumentReference docRef = await questions.add({
      'uid': '',
      'content': question.content,
      'senderUID': question.senderUID,
    });

    await docRef.update({'uid': docRef.id});
  }


  Future<List<AnswerModel>> fetchAnswersForQuestion(String questionUid) async {
    try {
      QuerySnapshot querySnapshot = await questions
          .doc(questionUid)
          .collection('answers')
          .get();

      List<AnswerModel> answers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AnswerModel(
          uid: doc.id,
          answer: data['answer'],
          senderUID: data['senderUID'],
        );
      }).toList();

      return answers;
    } catch (e) {
      print('Error fetching answers for question: $e');
      return [];
    }
  }
}