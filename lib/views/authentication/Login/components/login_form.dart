import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_management/models/user_model.dart';
import '../../../../constants.dart';
import '../../../../controllers/auth_response.dart';
import '../../../../controllers/authentication_service.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../functions.dart';
import '../../../../main.dart';
import '../../../widgets/already_have_an_account_acheck.dart';
import '../../ForgetPassword/forget_screen.dart';
import '../../Signup/signup_screen.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
                return 'Saisir un email valid';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: TextFormField(
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
                  return 'Saisir votre mot de passe';
                } else if (value.length < 4) {
                  return 'Saisir au moins 4 caractères';
                } else if (value.length > 13) {
                  return 'Le nombre maximum de caractères est de 13';
                }
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              const Text(
               "Mot de passe oublié ? ",
                style: TextStyle(color: kPrimaryColor),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ForgetScreen();
                      },
                    ),
                  );
                },
                child: const Text(
                  "Réinitialiser",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: kDefaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  AuthenticationService()
                      .signInWithEmail(email: email.text, password: password.text)
                      .then((authResponse) async {
                    if (authResponse.authStatus == AuthStatus.success) {
                      String? uid = await UserController().getUserUidByEmail(email.text);
                      bool access= await UserController().checkUserAccess(uid!);
                      // Get token
                      final fcmToken = await FirebaseMessaging.instance.getToken();
                      print(fcmToken);
                      if (access == true) {
                        await users.doc(uid).get().then((value) async {
                          if (value['role'] == 'admin') {
                            UserModel user = UserModel(
                                uid: uid,
                                email: value['email'],
                                name: value['name'],
                                role: Role.admin,
                                canAccess: value['canAccess'],
                                thumbnail: value['thumbnail'],
                                token: fcmToken
                            );
                            UserController().updateUserData(user);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Admin()),
                            );

                          }
                          if (value['role'] == 'pharmacien') {
                            UserModel user = UserModel(
                                uid: uid,
                                email: value['email'],
                                name: value['name'],
                                role: Role.pharmacien,
                                canAccess: value['canAccess'],
                                thumbnail: value['thumbnail'],
                                token: fcmToken
                            );
                            UserController().updateUserData(user);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Pharmacien()),
                            );
                          }
                          if (value['role'] == 'client') {
                            UserModel user = UserModel(
                                uid: uid,
                                email: value['email'],
                                name: value['name'],
                                role: Role.client,
                                canAccess: value['canAccess'],
                                thumbnail: value['thumbnail'],
                                token: fcmToken
                            );
                            UserController().updateUserData(user);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Client()),
                            );
                          }
                          if (value['role'] == 'fournisseur') {
                            UserModel user = UserModel(
                                uid: uid,
                                email: value['email'],
                                name: value['name'],
                                role: Role.fournisseur,
                                canAccess: value['canAccess'],
                                thumbnail: value['thumbnail'],
                                token: fcmToken
                            );
                            UserController().updateUserData(user);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Fournisseur()),
                            );
                          }
                        });
                      } else {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Non autorisé'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Merci d\'avoir utilisé notre application.'),
                                    Text('veuillez attendre qu\'un administrateur approuve votre accès pour utiliser l\'application'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      Util.showErrorMessage(context, authResponse.message);
                    }
                  });
                }
              },
              child: Text(
                "Se connecter".toUpperCase(), style: const TextStyle(color: kWhite),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


