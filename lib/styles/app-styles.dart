import 'package:flutter/material.dart';

ButtonStyle textButtonStyle() {
  return TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blueGrey,
    disabledForegroundColor: Colors.grey.withOpacity(0.38),
    textStyle: const TextStyle(fontSize: 20),
    padding: const EdgeInsets.all(16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );
}

Icon iconStyle(IconData iconData) {
  return Icon(
    iconData,
    size: 50,
    color: Colors.blueGrey[500],
  );
}
