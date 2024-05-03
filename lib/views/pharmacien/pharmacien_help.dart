import 'package:flutter/material.dart';

import '../../constants.dart';

class PharmacienHelp extends StatefulWidget {
  const PharmacienHelp({super.key});

  @override
  State<PharmacienHelp> createState() => _PharmacienHelpState();
}

class _PharmacienHelpState extends State<PharmacienHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: kGreen,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
            ),
            child: const ListTile(
              title: Text(
                "Questions & Ordonnonce",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                "Reciever/Envoyer des messages",
                textAlign: TextAlign.center,
              ),
              leading: Icon(Icons.chat),
              trailing: Icon(Icons.chat),
            ),
          ),
        ],
      ),
    );
  }
}