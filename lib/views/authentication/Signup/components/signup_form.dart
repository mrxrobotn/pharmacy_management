import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants.dart';
import '../../../../controllers/auth_response.dart';
import '../../../../controllers/authentication_service.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../functions.dart';
import '../../../../models/user_model.dart';
import '../../../widgets/already_have_an_account_acheck.dart';
import '../../Login/login_screen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleController = TextEditingController();
  Role _selectedRole = Role.client;
  File? _selectedImage;
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  late Role role;
  bool canAccess = false;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context, await imagePicker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context, await imagePicker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          const Center(
            child: Text('Choisir une photo de profile'),
          ),
          const SizedBox(height: kDefaultPadding,),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(75),
                image: _selectedImage != null
                    ? DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: _selectedImage == null
                  ? const Icon(
                Icons.camera_alt,
                size: 40,
                color: Colors.white,
              )
                  : null,
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: username,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Nom d'utilisateur",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Saisir votre nom d\'utilisateur';
              } else if (value.length < 4) {
                return 'saisir au moins 4 caractères';
              } else if (value.length > 13) {
                return 'Le nombre maximum de caractères est de 13';
              }
              return null;
            },
          ),
          const SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Icon(Icons.email),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Saisir votre email';
              } else if (!value.contains('@')) {
                return 'Veuillez saisir un email valide';
              }
              return null;
            },
          ),
          const SizedBox(height: kDefaultPadding),
          TextFormField(
            controller: password,
            textInputAction: TextInputAction.done,
            obscureText: ispasswordev,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: "Mot de passe",
              prefixIcon: const Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Icon(Icons.lock),
              ),
              suffixIcon: IconButton(
                icon: ispasswordev
                    ? Icon(
                  Icons.visibility_off,
                  color: selected == FormData.password
                      ? enabledtxt
                      : disabledtxt,
                  size: 20,
                )
                    : Icon(
                  Icons.visibility,
                  color: selected == FormData.password
                      ? enabledtxt
                      : disabledtxt,
                  size: 20,
                ),
                onPressed: () => setState(
                        () => ispasswordev = !ispasswordev),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Saisir un mot de passe';
              } else if (value.length < 4) {
                return 'Saisir au moins 4 caractères';
              } else if (value.length > 13) {
                return 'Le nombre maximum de caractères est de 13';
              }
              return null;
            },
          ),
          const SizedBox(height: kDefaultPadding),
          ElevatedButton(
            onPressed: () {
              _showRolePickerDialog(context);
            },
            child: const Text("Choisir un rôle", style: TextStyle(color: kWhite)),
          ),
          const SizedBox(height: kDefaultPadding),
          Text(
            'Rôle sélectionné : ${_selectedRole.toString().split('.').last}',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold, color: kPrimaryColor
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && _selectedImage != null) {
                String un = username.text;
                String em = email.text;
                String pwd = password.text;
                String imageUrl = await _uploadImage();

                if (un.isEmpty || em.isEmpty || pwd.isEmpty) {
                  print('One or more fields are empty');
                } else {
                  AuthenticationService()
                      .signUpWithEmail(
                      name: un,
                      email: em,
                      password: pwd)
                      .then((authResponse) {
                    if (authResponse.authStatus == AuthStatus.success) {
                      User? user = FirebaseAuth.instance.currentUser;
                      String? userUID = user?.uid;
                      if (userUID != null) {
                        UserModel user = UserModel(
                          uid: userUID,
                          email: em,
                          name: un,
                          role: _selectedRole,
                          canAccess: canAccess,
                          thumbnail: imageUrl,
                        );
                        UserController().saveUserToFirestore(user);
                        _selectedImage = null;
                      } else {
                        print('User UID is null');
                      }
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                              (route) => false);
                    } else {
                      Util.showErrorMessage(
                          context, authResponse.message);
                    }
                  });
                }
              }
            },
            child: Text(
              "S'inscrire".toUpperCase(),
              style: const TextStyle(color: kWhite),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }

  Future<String> _uploadImage() async {
    try {
      if (_selectedImage != null) {

        // Generate a unique filename for the image
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Upload image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('users/$fileName.jpg');

        await ref.putFile(_selectedImage!);

        // Get the image URL
        String imageUrl = await ref.getDownloadURL();

        return imageUrl;
      } else {
        print('No image selected');
        return '';
      }
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  void _showRolePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: _buildRolePickerDialogContent(context),
        );
      },
    );
  }

  Widget _buildRolePickerDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choisir un rôle',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          _buildRoleButton(context, Role.client),
          _buildRoleButton(context, Role.pharmacien),
          _buildRoleButton(context, Role.fournisseur),
        ],
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, Role role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedRole = role;
            _roleController.text = role.toString().split('.').last;
            Navigator.pop(context);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          role.toString().split('.').last,
          style: const TextStyle(
            fontSize: 16.0,
            color: kWhite
          ),
        ),
      ),
    );
  }
}