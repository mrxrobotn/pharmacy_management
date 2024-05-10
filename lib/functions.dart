import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Role { admin, client, pharmacien, fournisseur }
enum Status { En_stock, Rupture_de_stock }

// User
User? user = FirebaseAuth.instance.currentUser;
String? userUID = user?.uid;
String? getUsername = user?.displayName;
String? getEmail = user?.email;

//
Timestamp timestamp = Timestamp.now();

// Firestore Collections
CollectionReference users = FirebaseFirestore.instance.collection("users");
CollectionReference medicines = FirebaseFirestore.instance.collection("medicines");
CollectionReference orders = FirebaseFirestore.instance.collection("orders");
CollectionReference questions = FirebaseFirestore.instance.collection("questions");
CollectionReference advices = FirebaseFirestore.instance.collection("advices");


