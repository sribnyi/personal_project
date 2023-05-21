import 'package:flutter/material.dart';
import 'app-styles.dart';

class PaddedRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double size;

  const PaddedRow({super.key, required this.icon, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          iconStyle(icon, size), // Use your icon style function
          Text(text),

        ],
      ),
    );
  }
}
