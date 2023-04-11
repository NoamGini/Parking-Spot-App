import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final String buttonText;
  final Function() navPage;

  const AppElevatedButton(this.buttonText, this.navPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        fixedSize: const Size(200, 50),
      ),
      onPressed: navPage,
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
