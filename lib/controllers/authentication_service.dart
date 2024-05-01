import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'auth_response.dart';

class AuthenticationService {
  static const String emptyMsg = "";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future intializeService() async {
    //Lets call this init method from main function before runApp function call
    //For web app we need to initialize it differently
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyBd9fPdBjG0wdT0WDqOPkMwr9ur4wAM55U',
          appId: '1:273289006400:web:ac2e5bb318ba2628f93ea5',
          messagingSenderId: '273289006400',
          projectId: 'pharmacy-mangement',
          authDomain: 'pharmacy-mangement.firebaseapp.com',
          storageBucket: 'pharmacy-mangement.appspot.com',
          measurementId: 'G-XVB6PQ4DFG',
      ));
    } else {
      await Firebase.initializeApp();
    }
  }

  Future<AuthResponse> signUpWithEmail(
      {required String name,
      required String email,
      required String password}) async {
    //Lets call this method from sign up screen
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);
      return AuthResponse(AuthStatus.success, emptyMsg);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(AuthStatus.error, generateErrorMessage(e.code));
    }
  }

  //Lets call this function from login screen
  Future<AuthResponse> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AuthResponse(AuthStatus.success, emptyMsg);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(AuthStatus.error, generateErrorMessage(e.code));
    }
  }

  //Lets call this function from forgot password screen
  Future<AuthResponse> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return AuthResponse(AuthStatus.success, emptyMsg);
    } on FirebaseAuthException catch (e) {
      return AuthResponse(AuthStatus.error, generateErrorMessage(e.code));
    }
  }

  //Lets call this function from home screen to sign out user from firebase
  Future signOut() async {
    await _auth.signOut();
  }

  String? getEmail() {
    return _auth.currentUser!.email;
  }

  String generateErrorMessage(errorCode) {
    String errorMessage;
    switch (errorCode) {
      case "invalid-email":
        errorMessage = "Your email address appears to be malformed";
        break;
      case "weak-password":
        errorMessage = "Your password should be at least 6 characters";
        break;
      case "email-already-in-use":
        errorMessage = "The email address is already in use by another account";
        break;
      case "user-not-found":
        errorMessage = "User with this credentials does not exists";
        break;
      default:
        errorMessage = "Unexpected error occurred, please try again";
    }
    return errorMessage;
  }
}
