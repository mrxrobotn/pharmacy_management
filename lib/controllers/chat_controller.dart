import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').where('role', isEqualTo: 'pharmacien').snapshots().map((event) {
      return event.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String recieverUID, message) async {

  }

}