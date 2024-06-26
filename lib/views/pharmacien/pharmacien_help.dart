import 'package:flutter/material.dart';

import 'questions_page.dart';


class PharmacienHelp extends StatefulWidget {
  const PharmacienHelp({super.key});

  @override
  State<PharmacienHelp> createState() => _PharmacienHelpState();
}

class _PharmacienHelpState extends State<PharmacienHelp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: ListTile(
              title: Text(
                "Centre d'assistance",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                "Répondre à des questions posés par les patients",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        body: const QuestionsPage(),
      ),
    );
  }
}
