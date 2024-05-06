import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../functions.dart';
import '../../models/user_model.dart';

class QuestionsPage extends StatefulWidget {
  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late Stream<QuerySnapshot> _questionsStream;

  @override
  void initState() {
    super.initState();
    _questionsStream = questions.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(),
        child: StreamBuilder(
          stream: _questionsStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.separated(
                itemCount: streamSnapshot.data!.docs.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  return FutureBuilder(
                    future: UserController().getUserDataById(documentSnapshot['senderUID']),
                    builder: (context, AsyncSnapshot<UserModel?> userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (userSnapshot.hasData && userSnapshot.data != null) {
                        UserModel user = userSnapshot.data!;
                        return QuestionTile(
                          user: user,
                          questionDocument: documentSnapshot,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class QuestionTile extends StatelessWidget {
  final UserModel user;
  final DocumentSnapshot questionDocument;

  const QuestionTile({super.key,
    required this.user,
    required this.questionDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(
                'Par: ${user.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                'Question: ${questionDocument['content']}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              onTap: () {
                _showAnswersPopup(context, questionDocument);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAnswersPopup(BuildContext context, DocumentSnapshot questionDocument) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Réponses',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _showReplyDialog(context, questionDocument.id);
                        },
                        icon: const Icon(Icons.reply_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('questions').doc(questionDocument.id).collection('answers').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data!.docs.map((DocumentSnapshot answerDoc) {
                            return ListTile(
                              title: Text(answerDoc['answer']),
                              subtitle: FutureBuilder(
                                future: UserController().getUserDataById(answerDoc['senderUID']),
                                builder: (context, AsyncSnapshot<UserModel?> userSnapshot) {
                                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  if (userSnapshot.hasData && userSnapshot.data != null) {
                                    UserModel user = userSnapshot.data!;
                                    return Text('Par: ${user.name}');
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _showReplyDialog(BuildContext context, String questionId) {
    TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Répondre à la question"),
          content: TextField(
            controller: replyController,
            decoration: const InputDecoration(hintText: "Réponse ...."),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer"),
            ),
            TextButton(
              onPressed: () {
                // Save reply to Firestore
                String replyContent = replyController.text.trim();
                if (replyContent.isNotEmpty) {
                  saveReply(questionId, replyContent);
                }
                Navigator.of(context).pop();
              },
              child: const Text("Répondre"),
            ),
          ],
        );
      },
    );
  }

  void saveReply(String questionId, String replyContent) {
    String uid = userUID!;
    FirebaseFirestore.instance.collection('questions').doc(questionId).collection('answers').add({
      'answer': replyContent,
      'senderUID': uid,
    });
  }
}
