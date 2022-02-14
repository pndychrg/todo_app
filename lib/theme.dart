import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    scaffoldBackgroundColor: kprimarycolor,
    iconTheme: IconThemeData(color: Colors.white),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ktertiarycolor,
  );
}
