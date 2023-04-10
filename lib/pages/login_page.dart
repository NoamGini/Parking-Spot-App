import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parking_spot_app/pages/signup_page.dart';
import 'package:parking_spot_app/widget/AppTextField.dart';
import 'package:parking_spot_app/widget/background.dart';
import 'package:parking_spot_app/widget/AppRaisedButton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LogInPage extends StatelessWidget {
  static const routeName = "LogInPage";
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(logInPageDesign(context))
    );
  }

  showAlertDialogNotExistUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('משתמש איננו קיים'),
        content: Text('על מנת להירשם עבור לעמוד ההרשמה'),
        actions: [
          TextButton(
            child: Text('אישור'),
            onPressed: () {
               Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
 

  Container logInPageDesign(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool finalResponse=false;

    void clearText() {
    emailController.clear();
    passwordController.clear();
  }

    Future<bool> checkData() async{
      const url = "http://10.0.2.2:5000/signIn";
      final uri = Uri.parse(url);
      final response = await http.post(
          uri, body: json.encode(
          {'email': emailController.text,
            'password': passwordController.text,
            }));
      
      final jsonResponse = json.decode(response.body);
      final message = jsonResponse['response'];
      if (message == "exist"){
        finalResponse= true;
        return true;
      }
      return false;             
    }
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("התחברות", style: TextStyle(fontSize: 50, color: Colors.black, fontWeight: FontWeight.w100)),
          const SizedBox(height: 45),
          AppTextField( "מייל", "הכנס מייל ", Icons.people,emailController,false),
          const SizedBox(height: 20),
          AppTextField("סיסמא", "הכנס סיסמא", Icons.lock,passwordController,true),
          const SizedBox(height: 40),
           ElevatedButton(
        child: Text("כניסה", style: const TextStyle(
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
        onPressed: () async {
            bool c = await checkData();
            if (c){
              clearText();
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
            }
            else{
              showAlertDialogNotExistUser(context);
            }                   
          }             
    ),
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("אין לך משתמש?",style: TextStyle(fontSize: 15, color: Colors.black)),
              TextButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: const Text("הירשם כאן",style: TextStyle(fontSize: 18, color: Colors.black))
              ),
            ],
          ),
        ],
      ),
    );
  }
}