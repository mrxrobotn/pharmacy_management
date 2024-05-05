import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData mainTheme(BuildContext context) {
      return ThemeData(
            fontFamily: 'HelveticaNeue',
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'HelveticaNeue'),
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: kPrimaryColor,
                        shape: const StadiumBorder(),
                        maximumSize: const Size(double.infinity, 56),
                        minimumSize: const Size(double.infinity, 56),
                  ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  iconColor: kPrimaryColor,
                  prefixIconColor: kPrimaryColor,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: kDefaultPadding),
                  border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide.none,
                  ),
            ),
      );
}


ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.grey.shade500,
      secondary: Colors.grey.shade200,
      tertiary: Colors.white,
      inversePrimary: Colors.grey.shade900,
    )
);
