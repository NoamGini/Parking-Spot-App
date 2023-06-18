import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final Function() navPage;

  const CircularButton(
      this.text,
      this.size,
      this.color,
      this.navPage,
      {super.key}
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: navPage,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center, 
            ),
          ],
        ),
      ),
    );
  }
}
