import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/chat_controller.dart';

import '../chat_page.dart';
import '../widgets/user_tile.dart';

class ClientMessages extends StatefulWidget {
  const ClientMessages({super.key});

  @override
  State<ClientMessages> createState() => _ClientMessagesState();
}

class _ClientMessagesState extends State<ClientMessages> {
  final ChatController _chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatController.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      text: userData["email"],
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      recieverEmail: userData["email"],
                    )));
      },
    );
  }
}
