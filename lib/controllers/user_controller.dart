import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../functions.dart';
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


  Future<UserModel?> getUserData() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot doc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return UserModel(
            uid: data['uid'],
            email: data['email'],
            name: data['name'],
            role: Role.values.firstWhere(
                    (role) => role.toString() == 'Role.${data['role']}'),
            canAccess: data['canAccess'],
          );
        }
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<UserModel?> getUserDataById(String userID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userID).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
          uid: data['uid'],
          email: data['email'],
          name: data['name'],
          role: Role.values.firstWhere(
                  (role) => role.toString() == 'Role.${data['role']}'),
          canAccess: data['canAccess'],
        );
      } else {
        print('User with ID $userID does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

}