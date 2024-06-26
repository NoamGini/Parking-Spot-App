import 'package:flutter/material.dart';
import 'package:parking_spot_app/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  static const routeName = "SignUpPage";

  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final validatePasswordController = TextEditingController();
  late Uri url;
  final formKey = GlobalKey<FormState>();
  bool finalResponse=false;
  

@override
void dispose() {
  // Dispose of the controllers if they were used by the user
  if (nameController.text.isNotEmpty) {
    nameController.dispose();
  }
  if (emailController.text.isNotEmpty) {
    emailController.dispose();
  }
  if (passwordController.text.isNotEmpty) {
    passwordController.dispose();
  }
  if (validatePasswordController.text.isNotEmpty) {
    validatePasswordController.dispose();
  }

  // Call the superclass dispose() method
  super.dispose();
}

  Future<void> saveData() async {
    final validation = formKey.currentState?.validate();
    if (validation == true) {
      formKey.currentState?.save();
    }

  } 
  
  Future<bool> postData() async{
      saveData();
      const url = "http://10.0.2.2:5000/register";
      final uri = Uri.parse(url);
      final response = await http.post(
          uri, body: json.encode(
          {'name': nameController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'validatePassword': validatePasswordController.text,
            'parking': null,
            'points': 0,
            'avatar': null
            }));
      
      final jsonResponse = json.decode(response.body);
      final message = jsonResponse['response'];
      if (message == "User registered successfully"){
        finalResponse= true;
        return true;
      }
      return false;             
    }

// The showAlertDialog() function
showAlertDialogSucc(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('רישום בוצע!'),
        content: const Text('נרשמת בהצלחה'),
        actions: [
          TextButton(
            child: const Text('אישור'),
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LogInPage()),
                    );
            },
          ),
        ],
      );
    },
  );
}

showAlertDialogExistUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('משתמש קיים'),
        content: const Text('משתמש זה כבר קיים במערכת.'),
        actions: [
          TextButton(
            child: const Text('עבור לעמוד הכניסה'),
            onPressed: () {
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LogInPage()),
                    );
            },
          ),
          TextButton(
            child: const Text('הישאר בעמוד'),
            onPressed: () {
               Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        child: Form( key: formKey,
         child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("הרשמה",
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontWeight: FontWeight.w100)),
              const SizedBox(height: 45),
              TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "שם מלא",
                    hintText: "הכנס שם מלא",
                    prefixIcon: Icon(
                      Icons.people,
                      color: Colors.black,
                    ),
                    hintStyle:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                   validator: (value){
                      if (value == null || value.isEmpty){
                        return 'הכנס שם מלא';
                      }
                      else if (value.length < 2){
                        return ' שם מלא חייב להכיל לפחות 2 תווים';
                      }
                      return null;
                   },
                ),
              const SizedBox(height: 20),
              TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "מייל",
                      hintText: "הכנס מייל",
                      prefixIcon: Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                          fontSize: 15, color: Colors.black),
                    ),
                     validator: (value){
                      if (value == null || value.isEmpty){
                        return 'הכנס מייל';
                      }
                      else if (!value.contains("@") || !value.contains(".")){
                        return 'כתובת המייל אינה תקינה';
                      }
                      return null;
                     },
                  ),
              const SizedBox(height: 20),
              TextFormField(
                    controller: passwordController,
                    obscureText: true, //hide text
                    obscuringCharacter: "*",
                    decoration: const InputDecoration(
                      labelText: "סיסמא",
                      hintText: "הכנס סיסמא",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                          fontSize: 15, color: Colors.black),
                    ),
                     validator: (value){
                      if (value == null || value.isEmpty){
                        return 'הכנס סיסמא';
                      }
                      else if (value.length < 8){
                        return 'הסיסמא חייבת להכיל לפחות 8 תווים';
                      }
                      return null;
                     },
                  ),
              const SizedBox(height: 20),
              TextFormField(
                    controller: validatePasswordController,
                    obscureText: true, //hide text
                    obscuringCharacter: "*",
                    decoration: const InputDecoration(
                      labelText: "וידוא סיסמא",
                      hintText: "חזור על הסיסמא",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                          fontSize: 15, color: Colors.black),
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'חזור על הסיסמא';
                      }
                      else if (value.length < 8){
                        return 'הסיסמא חייבת להכיל לפחות 8 תווים';
                      }
                      else if (value != passwordController.text){
                        return 'הסיסמאות לא תואמות';
                      }
                      return null;
                    },
                  ),
              const SizedBox(height: 20),           
              ElevatedButton(
                  onPressed:() async {
                    if (formKey.currentState!.validate()){
                      bool c = await postData();
                      if (c){

                        showAlertDialogSucc(context);
                      }
                      else{
                        showAlertDialogExistUser(context);
                      }                   
                    }
                  },
                  child: Text(
                      "הירשם", style: const TextStyle(color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  )),
                  style: ElevatedButton.styleFrom(
                    primary: Theme
                        .of(context)
                        .primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  )
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("יש לך כבר משתמש?",
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("עבור להתחברות",
                          style: TextStyle(
                              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,))),
                ],
              ),
            ],
          ),
        ))
      )
    )
  );
  }
}

