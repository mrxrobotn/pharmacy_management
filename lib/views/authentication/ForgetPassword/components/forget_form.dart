import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../controllers/auth_response.dart';
import '../../../../controllers/authentication_service.dart';
import '../../../../functions.dart';
import '../../Login/login_screen.dart';

class ForgetForm extends StatelessWidget {
  ForgetForm({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

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
              hintText: "Votre email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(kDefaultPadding),
                child: Icon(Icons.person),
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
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                AuthenticationService()
                    .resetPassword(email: email.text)
                    .then((authResponse) {
                  if (authResponse.authStatus == AuthStatus.success) {
                    Util.showSuccessMessage(context,
                        "Un e-mail a été envoyé pour réinitialiser le mot de passe, veuillez vérifier votre e-mail.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  } else {
                    Util.showErrorMessage(context, authResponse.message);
                  }
                });
              }
            },
            child: Text(
              "Envoyer".toUpperCase(), style: const TextStyle(color: kWhite),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            child: Text(
              "Retour".toUpperCase(), style: const TextStyle(color: kWhite),
            ),
          ),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
