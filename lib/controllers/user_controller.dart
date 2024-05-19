import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
          token: data['token'],
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
      // Get token
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (firebaseUser != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.name,
          'role': user.role.toString().split('.').last, // Store role as string
          'canAccess': user.canAccess,
          'thumbnail': user.thumbnail,
          'token': fcmToken,
        });
      }
    } catch (e) {
      print('Error saving user to Firestore: $e');
      rethrow; // Rethrow the error for handling in UI if needed
    }
  }

  Future<bool> checkUserAccess(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['canAccess'] as bool;
      } else {
        print('User with ID $uid does not exist');
        return false; // User does not exist
      }
    } catch (e) {
      print('Error checking user access: $e');
      return false; // Error occurred
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
              schedule: data['schedule'],
              token: data['token'],
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
            schedule: data['schedule'],
            token: data['token']
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
          'token': user.token,
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

  Future<String?> getUserUidByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await users
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size == 1) {
        return querySnapshot.docs.first.id;
      } else if (querySnapshot.size > 1) {
        // This should not happen, but handle multiple users found with same email
        print('Multiple users found with email $email');
        return null;
      } else {
        // User not found with the given email
        print('User not found with email $email');
        return null;
      }
    } catch (e) {
      print('Error getting user UID by email: $e');
      return null;
    }
  }

  // Function to retrieve selected reclamation user's Token
  Future<String?> getTokenForUser(String userId) async {
    try {

      // Get the document snapshot for the specified user ID
      DocumentSnapshot snapshot = await users.doc(userId).get();

      // Check if the document exists
      if (snapshot.exists) {
        // Cast the data to a Map<String, dynamic>
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Access the 'token' field from the document data
        return data['token'] as String?;
      } else {
        print('user does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }
}
