import 'package:flutter/material.dart';
import 'package:pharmacy_management/controllers/chat_controller.dart';

import '../common/chat_page.dart';
import '../widgets/user_tile.dart';

class PatientChatList extends StatefulWidget {
  const PatientChatList({super.key});

  @override
  State<PatientChatList> createState() => _PatientChatListState();
}

class _PatientChatListState extends State<PatientChatList> {
  final ChatController _chatController = ChatController();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Recherche...',
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatController.getPharmaciensStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        List<Map<String, dynamic>> users = snapshot.data ?? [];
        String query = _searchController.text.toLowerCase();

        // Filter users based on search query
        if (query.isNotEmpty) {
          users = users.where((user) {
            String name = user['name'].toLowerCase();
            return name.contains(query);
          }).toList();
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(users[index], context);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData,
      BuildContext context,
      ) {
    return UserTile(
      text: userData["name"],
      thumbnail: userData["thumbnail"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"],
              receiverUID: userData["uid"],
            ),
          ),
        );
      },
    );
  }
}
