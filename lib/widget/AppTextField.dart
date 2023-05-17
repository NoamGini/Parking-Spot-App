import 'package:flutter/material.dart';


class AppTextField extends StatelessWidget {
  String labelText;
  String hintText;
  IconData icon;
  bool isPassword;
  TextEditingController textController = TextEditingController();
  AppTextField(this.labelText, this.hintText, this.icon, this.textController, this.isPassword);

  @override
  //this page has the TextField design
  Widget build(BuildContext context) {

    return TextField(
        controller: textController,
        obscureText: isPassword, //hide text
        obscuringCharacter: "*",
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.black,),
          hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(fontSize: 15, color: Colors.black),

        )
    );
  }
}