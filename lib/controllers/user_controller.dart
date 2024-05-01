import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.name,
          'role': user.role.toString().split('.').last, // Store role as string
          'canAccess': user.canAccess,
        });
      }
    } catch (e) {
      print('Error saving user to Firestore: $e');
      rethrow; // Rethrow the error for handling in UI if needed
    }
  }
}
