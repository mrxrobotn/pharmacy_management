import 'package:flutter/material.dart';
import 'package:pharmacy_management/constants.dart';

import '../../controllers/notifications_api.dart';
import '../../controllers/user_controller.dart';
import '../../functions.dart';
import '../../models/user_model.dart';

class UserDetailsPage extends StatefulWidget {
  final UserModel user;

  const UserDetailsPage({super.key, required this.user});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _phoneController;
  late TextEditingController _scheduleController;
  late TextEditingController _addressController;
  late bool _canAccess;
  late Role _selectedRole;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _roleController = TextEditingController(text: widget.user.role.toString().split('.').last);
    _phoneController = TextEditingController(text: widget.user.telephone);
    _scheduleController = TextEditingController(text: widget.user.schedule);
    _addressController = TextEditingController(text: widget.user.address);
    _canAccess = widget.user.canAccess;
    _selectedRole = widget.user.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nom:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(controller: _nameController),
              const SizedBox(height: 16),
              const Text(
                'Email:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(controller: _emailController),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Role:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<Role>(
                    value: _selectedRole,
                    items: Role.values.map((role) {
                      return DropdownMenuItem<Role>(
                        value: role,
                        child: Text(role.toString().split('.')[1]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Addresse:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(controller: _addressController),
              const SizedBox(height: 16),
              const Text(
                'Télephone:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(controller: _phoneController),
              const SizedBox(height: 16),
              const Text(
                'Horaire:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(controller: _scheduleController),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Donner l\'accés à cet utilisateur? ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _canAccess,
                    onChanged: (value) {
                      setState(() async {
                        String? token = await UserController().getTokenForUser(widget.user.uid);
                        _canAccess = value;
                        // Check if Token is empty
                        if (token != null) {
                          sendNotificationMessage(
                            recipientToken: token,
                            title: 'Votre statut a été modifié',
                            body: _canAccess ? "vous avez maintenant l'accès à l'application" : "vous n'avez pas maintenant l\'accès à l'application",
                          );
                        } else {
                          print('Failed to get token for the user');
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  UserModel updatedUser = UserModel(
                    uid: widget.user.uid,
                    email: _emailController.text,
                    name: _nameController.text,
                    role: _selectedRole,
                    address: _addressController.text,
                    telephone: _phoneController.text,
                    schedule: _scheduleController.text,
                    canAccess: _canAccess,
                    thumbnail: widget.user.thumbnail,
                  );
                  await UserController().updateUserData(updatedUser);
                  Navigator.pop(context, updatedUser);
                },
                child: const Text(
                  'Modifier',
                  style: TextStyle(color: kWhite),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  UserController().deleteUser(widget.user.uid);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: kWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _scheduleController.dispose();
    _roleController.dispose();
    super.dispose();
  }
}
