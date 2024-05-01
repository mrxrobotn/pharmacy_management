import 'package:flutter/material.dart';
import '../../../../constants.dart';


class ForgetScreenTopImage extends StatelessWidget {
  const ForgetScreenTopImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          "Changer votre mot de passe".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset("assets/images/forgot-password.png"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: kDefaultPadding * 2),
      ],
    );
  }
}