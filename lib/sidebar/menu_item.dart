import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {

  final IconData icon;
  final String title;

  const MenuItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.only(left:20),
              child: Icon(
                icon,
                color: Colors.white,
                size:30,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
