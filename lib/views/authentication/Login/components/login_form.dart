import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../controllers/auth_response.dart';
import '../../../../controllers/authentication_service.dart';
import '../../../../functions.dart';
import '../../../pharmacien/pharmacien_home.dart';
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
                      .signInWithEmail(
                      email: email.text,
                      password: password.text)
                      .then((authResponse) async {
                    if (authResponse.authStatus == AuthStatus.success) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PharmacienHome()),
                              (route) => false);
                    }  else {
                      Util.showErrorMessage(
                          context, authResponse.message);
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
