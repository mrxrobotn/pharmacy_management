import 'package:flutter/material.dart';

import '../../constants.dart';

class PharmacienMessages extends StatefulWidget {
  const PharmacienMessages({super.key});

  @override
  State<PharmacienMessages> createState() => _PharmacienMessagesState();
}

class _PharmacienMessagesState extends State<PharmacienMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: kBlue,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
            ),
            child: const ListTile(
              title: Text(
                "Messages",
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