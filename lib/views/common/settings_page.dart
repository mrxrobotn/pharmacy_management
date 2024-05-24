import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/views/authentication/Login/login_screen.dart';
import '../../constants.dart';
import '../../controllers/user_controller.dart';
import '../../functions.dart';
import '../../models/user_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserModel _user;

  Widget _buildInfo(String label, Future<int> Function() getData) {
    return FutureBuilder<int>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'Nunito',
                  fontSize: 20,
                ),
              ),
              Text(
                snapshot.data.toString(),
                style: const TextStyle(
                  color: Color.fromRGBO(39, 105, 171, 1),
                  fontFamily: 'Nunito',
                  fontSize: 25,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Paramètres'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kBlue,
                    Color.fromRGBO(39, 105, 171, 1),
                  ],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                ),
              ),
            ),
            Scaffold(
                backgroundColor: Colors.transparent,
                body: FutureBuilder(
                    future: UserController().getUserDataById(userUID!),
                    builder: (context, AsyncSnapshot<UserModel?> userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (userSnapshot.hasData && userSnapshot.data != null) {
                        _user = userSnapshot.data!;
                        return  SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical:10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    MenuAnchor(
                                      builder: (context, controller, child) {
                                        return IconButton(
                                          onPressed: () {
                                            if (controller.isOpen) {
                                              controller.close();
                                            } else {
                                              controller.open();
                                            }
                                          },
                                          icon: const Icon(Icons.more_vert, size: 30, color: kWhite,),
                                        );
                                      },
                                      menuChildren: [
                                        MenuItemButton(
                                          child: const Text('Modifier profile'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => EditUserInfoScreen(user: _user)),
                                            ).then((value) {
                                              if (value == true) {
                                                setState(() {});
                                              }
                                            });
                                          },
                                        ),
                                        MenuItemButton(
                                          child: const Text('Déconnexion'),
                                          onPressed: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                                                  (Route<dynamic> route) => false,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: height * 0.43,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          double innerWidth = constraints.maxWidth;

                                          return Container(
                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: Colors.white,
                                            ),
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.network(
                                                  _user.thumbnail,
                                                  width: innerWidth * 0.45,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    _user.name,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(39, 105, 171, 1),
                                                      fontFamily: 'Nunito',
                                                      fontSize: 37,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                if (_user.role == Role.pharmacien)
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      _buildInfo("Médicaments", () => UserController().countUserMedicaments()),
                                                    ],
                                                  ),
                                              ],
                                            ), // Aligning everything to top
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: height * 0.5,
                                      width: width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'Mes informations',
                                              style: TextStyle(
                                                color: Color.fromRGBO(39, 105, 171, 1),
                                                fontSize: 27,
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                            const Divider(
                                              thickness: 2.5,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(5),
                                              child: Card(
                                                child: ListTile(
                                                  title: Text(
                                                    'Points de fidèlité: ${_user.coupon.toString()} points',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  leading: const SizedBox(),
                                                ),
                                              ),
                                            ),
                                            _buildUserInfoField('Email', _user.email),
                                            _buildUserInfoField('Tél', _user.telephone ?? 'Non défini'),
                                            _buildUserInfoField('Addresse', _user.address ?? 'Non défini'),
                                            if (_user.role == Role.pharmacien)
                                            _buildUserInfoField('Heures d\'ouverture', _user.schedule ?? 'Non défini'),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoField(String label, String value) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Card(
        child: ListTile(
          title: Text(
            '$label: $value',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          leading: const SizedBox(),
        ),
      ),
    );
  }
}

class EditUserInfoScreen extends StatefulWidget {
  final UserModel user;

  const EditUserInfoScreen({super.key, required this.user});

  @override
  _EditUserInfoScreenState createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _scheduleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.telephone ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _scheduleController = TextEditingController(text: widget.user.schedule ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier les Informations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nom', _nameController),
              _buildTextField('Email', _emailController),
              _buildTextField('Téléphone', _phoneController),
              _buildTextField('Address', _addressController),
              _buildTextField('Horaire de travail', _scheduleController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _updateUserInfo();
                },
                child: const Text('Enregistrer',style: TextStyle(
                    fontSize: 16.0,
                    color: kWhite
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _updateUserInfo() {
    // Update user information in the database
    UserModel updatedUser = UserModel(
      uid: widget.user.uid,
      email: _emailController.text,
      name: _nameController.text,
      role: widget.user.role,
      canAccess: widget.user.canAccess,
      thumbnail: widget.user.thumbnail,
      address: _addressController.text,
      telephone: _phoneController.text,
      schedule: _scheduleController.text,
    );
    UserController().updateUserData(updatedUser).then((_) {
      // Notify parent widget that editing is successful
      Navigator.pop(context, true);
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update user: $error'),
      ));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }
}