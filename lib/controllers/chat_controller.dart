import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_management/models/chat_model.dart';
import '../functions.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getClientsStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'client')
        .snapshots()
        .map((event) {
      return event.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getPharmaciensStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'pharmacien')
        .snapshots()
        .map((event) {
      return event.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverUID, message) async {
    ChatModel newMessage = ChatModel(
        senderUID: userUID!,
        senderEmail: getEmail!,
        receiverUID: receiverUID,
        message: message,
        timestamp: timestamp);

    List<String> ids = [userUID!, receiverUID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore
        .collection('chatrooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserId) {
    List<String> ids = [userID, otherUserId];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
