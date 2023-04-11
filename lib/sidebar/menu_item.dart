import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    //   child: Padding(
    //     padding: const EdgeInsets.all(16),
    //     child: Row(
    //       textDirection: TextDirection.rtl,
    //       children: <Widget>[
    //         const SizedBox(width: 20),
    //         Padding(
    //           padding: const EdgeInsets.only(left:20),
    //           child: Icon(
    //             icon,
    //             color: Colors.white,
    //             size:30,
    //           ),
    //         ),
    //         Text(
    //           title,
    //           style: const TextStyle(
    //             fontWeight: FontWeight.w300,
    //             fontSize: 20,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
