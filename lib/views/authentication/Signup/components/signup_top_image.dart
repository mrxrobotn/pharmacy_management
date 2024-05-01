import 'package:flutter/material.dart';
import '../../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Créer un compte".toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kDefaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset("assets/images/mortar.png"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: kDefaultPadding),
      ],
    );
  }
}
