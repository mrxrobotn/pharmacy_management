import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/themes.dart';
import 'package:pharmacy_management/views/admin/admin_home.dart';
import 'package:pharmacy_management/views/authentication/Welcome/welcome_screen.dart';
import 'package:pharmacy_management/views/client/client_home.dart';
import 'package:pharmacy_management/views/fournisseur/fournisseur_home.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_home.dart';
import 'firebase_options.dart';
import 'functions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (user != null) {
    await users.doc(userUID).get().then((value) {
      if (value['role'] == 'admin') {
        runApp(const Admin());
      }
      if (value['role'] == 'pharmacien') {
        runApp(const Pharmacien());
      }
      if (value['role'] == 'client') {
        runApp(const Client());
      }
      if (value['role'] == 'fournisseur') {
        runApp(const Fournisseur());
      }
      print(value['role']);
    });
  } else {
    print("User is not logged in");
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainTheme(context),
      home: const WelcomeScreen()
    );
  }
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Page',
      debugShowCheckedModeBanner: false,
      theme: mainTheme(context),
      home: const AdminHome(),
    );
  }
}

class Client extends StatelessWidget {
  const Client({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Page',
      debugShowCheckedModeBanner: false,
      theme: mainTheme(context),
      home: const ClientHome(),
    );
  }
}

class Pharmacien extends StatelessWidget {
  const Pharmacien({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacien Page',
      theme: mainTheme(context),
      home: const PharmacienHome(),
    );
  }
}

class Fournisseur extends StatelessWidget {
  const Fournisseur({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fournisseur Page',
      theme: mainTheme(context),
      home: const FournisseurHome(),
    );
  }
}