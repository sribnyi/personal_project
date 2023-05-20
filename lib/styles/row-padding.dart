import 'package:flutter/material.dart';
import 'app-styles.dart';

class PaddedRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const PaddedRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          iconStyle(icon), // Use your icon style function
          Text(text),
        ],
      ),
    );
  }
}
