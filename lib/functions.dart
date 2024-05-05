import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Role { admin, client, pharmacien, fournisseur }

// User
User? user = FirebaseAuth.instance.currentUser;
String? userUID = user?.uid;
String? getUsername = FirebaseAuth.instance.currentUser?.displayName;
String? getEmail = FirebaseAuth.instance.currentUser?.email;

// Firestore Collections
CollectionReference users = FirebaseFirestore.instance.collection("users");
CollectionReference medicines = FirebaseFirestore.instance.collection("medicines");
CollectionReference orders = FirebaseFirestore.instance.collection("orders");
CollectionReference questions = FirebaseFirestore.instance.collection("questions");

// TextEditingControllers
final TextEditingController username = TextEditingController();
final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();
late Role role;
const bool canAccess = false;

