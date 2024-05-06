import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../functions.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
      await users.where('role', isNotEqualTo: 'admin').get();
      List<UserModel> allusers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
          uid: data['uid'],
          email: data['email'],
          name: data['name'],
          role: Role.values.firstWhere(
                  (role) => role.toString() == 'Role.${data['role']}'),
          canAccess: data['canAccess'],
          thumbnail: data['thumbnail'],
          address: data['address'],
          telephone: data['telephone'],
          schedule: data['schedule'],
        );
      }).toList();
      return allusers;
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

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
              thumbnail: data['thumbnail'],
              address: data['address'],
              telephone: data['telephone'],
              schedule: data['schedule']);
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
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userID).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
            uid: data['uid'],
            email: data['email'],
            name: data['name'],
            role: Role.values.firstWhere(
                (role) => role.toString() == 'Role.${data['role']}'),
            canAccess: data['canAccess'],
            thumbnail: data['thumbnail'],
            address: data['address'],
            telephone: data['telephone'],
            schedule: data['schedule']);
      } else {
        print('User with ID $userID does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<int> countUserMedicaments() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('medicines')
            .where('ownerUID', isEqualTo: firebaseUser.uid)
            .get();
        return querySnapshot.size;
      }
      return 0;
    } catch (e) {
      print('Error counting user medicaments: $e');
      return 0;
    }
  }

  Future<int> countUserOrders() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('orders')
            .where('recieverUID', isEqualTo: firebaseUser.uid)
            .get();
        return querySnapshot.size;
      }
      return 0;
    } catch (e) {
      print('Error counting user medicaments: $e');
      return 0;
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'email': user.email,
          'name': user.name,
          'role': user.role.toString().split('.').last,
          'canAccess': user.canAccess,
          'thumbnail': user.thumbnail,
          'address': user.address,
          'telephone': user.telephone,
          'schedule': user.schedule,
        });
      }
    } catch (e) {
      print('Error updating user in Firestore: $e');
      rethrow; // Rethrow the error for handling in UI if needed
    }
  }

  Future<void> deleteUser(String id) async {
    await users.doc(id).delete();
  }
}
