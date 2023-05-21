import 'package:flutter/material.dart';

ButtonStyle textButtonStyle() {
  return TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.grey[700],
    disabledForegroundColor: Colors.grey.withOpacity(0.38),
    textStyle: const TextStyle(fontSize: 20),
    padding: const EdgeInsets.all(16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );
}

Icon iconStyle(IconData iconData, double size) {
  return Icon(
    iconData,
    size: size,
    color: Colors.grey[700],
  );
}
