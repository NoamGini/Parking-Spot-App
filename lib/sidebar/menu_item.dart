import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const MenuItem({super.key, required this.icon, required this.title, this.onTap});

  final color = Colors.white;
  final hoverColor = Colors.white70;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      trailing: Icon(
        icon,
        color: Colors.lightBlueAccent),
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: color)),
      hoverColor: hoverColor,
      onTap: onTap,
    );
  }
}
