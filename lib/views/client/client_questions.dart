import 'package:flutter/material.dart';
import 'package:pharmacy_management/constants.dart';
import 'package:pharmacy_management/controllers/question_controller.dart';
import 'package:pharmacy_management/models/question_model.dart';

import '../../functions.dart';
import '../../models/answer_model.dart';

class ClientsQuestions extends StatefulWidget {
  const ClientsQuestions({Key? key});

  @override
  State<ClientsQuestions> createState() => _ClientsQuestionsState();
}

class _ClientsQuestionsState extends State<ClientsQuestions> {
  final QuestionController questionController = QuestionController();
  late List<QuestionModel> _questions;
  late List<QuestionModel> _filteredQuestions;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    List<QuestionModel> questions = await questionController.fetchQuestions();
    setState(() {
      _questions = questions;
      _filteredQuestions = _questions;
    });
  }

  void _filterQuestions(String query) {
    setState(() {
      _filteredQuestions = _questions
          .where((question) =>
      question.content.toLowerCase().contains(query.toLowerCase()) ||
          question.senderUID.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addNewQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textController = TextEditingController();
        return AlertDialog(
          title: const Text("Pose un question"),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: "Question......."),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                String content = textController.text;
                if (content.isNotEmpty) {
                  QuestionModel question = QuestionModel(
                      content: content,
                      senderUID: userUID!,
                      uid: ''
                  );
                  questionController.addQuestion(question);
                  _loadQuestions(); // Reload questions list
                }
                Navigator.of(context).pop();
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: ListTile(
            title: Text(
              "Tous les questions posés",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewQuestion,
            color: kBlue,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterQuestions,
              decoration: const InputDecoration(
                labelText: 'Recherche par content .....',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredQuestions.isEmpty
                ? const Center(child: Text('Aucun question trouvé'))
                : ListView.builder(
              itemCount: _filteredQuestions.length,
              itemBuilder: (context, index) {
                QuestionModel question = _filteredQuestions[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionAnswersPage(question: question),
                      ),
                    );
                  },
                  child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(question.content),
                        leading: const Icon(Icons.question_mark),
                        trailing: const Icon(Icons.arrow_forward_ios_sharp),
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionAnswersPage extends StatelessWidget {
  final QuestionModel question;

  const QuestionAnswersPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous les réponses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<AnswerModel>>(
                future: QuestionController().fetchAnswersForQuestion(question.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<AnswerModel>? answers = snapshot.data;
                    if (answers != null && answers.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: answers.length,
                        itemBuilder: (context, index) {
                          AnswerModel answer = answers[index];
                          return Card(
                            child: ListTile(
                              title: Text(answer.answer),
                              leading: const Icon(Icons.question_answer),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('Aucune réponse trouvé.'));
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
