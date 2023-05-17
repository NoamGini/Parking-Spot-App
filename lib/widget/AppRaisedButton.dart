import 'package:flutter/material.dart';


class AppRaisedButton extends StatelessWidget {
  String buttonText;
  Function() navPage;
  AppRaisedButton(this.buttonText, this.navPage);

  @override
  //this page has the RaisedButton design
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(buttonText, style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          primary:Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
        ),
        onPressed: navPage
    );
  }
}