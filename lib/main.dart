import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/views/admin/admin_home.dart';
import 'package:pharmacy_management/views/authentication/Welcome/welcome_screen.dart';
import 'package:pharmacy_management/views/client/client_home.dart';
import 'package:pharmacy_management/views/fournisseur/fournisseur_home.dart';
import 'package:pharmacy_management/views/pharmacien/pharmacien_home.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'functions.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (user != null) {
    await users.doc(userUID).get().then((value) {
      if (value['role'] == Role.admin) {
        runApp(const AdminHome());
      }
      if (value['role'] == Role.pharmacien) {
        runApp(const PharmacienHome());
      }
      if (value['role'] == Role.client) {
        runApp(const ClientHome());
      }
      if (value['role'] == Role.fournisseur) {
        runApp(const FournisseurHome());
      }
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
      theme: ThemeData(
          fontFamily: 'HelveticaNeue',
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'HelveticaNeue'),
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )
      ),
      home: const WelcomeScreen()
    );
  }
}
