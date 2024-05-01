import 'package:flutter/material.dart';
import '../../../../constants.dart';


class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "BIENVENUE AU PHARMACIE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: kDefaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                "assets/images/pharmacy_logo.png",
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: kDefaultPadding * 2),
      ],
    );
  }
}