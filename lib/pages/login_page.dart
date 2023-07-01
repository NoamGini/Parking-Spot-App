import 'package:flutter/material.dart';
import 'package:parking_spot_app/models/parking_kahol_lavan.dart';
import 'package:parking_spot_app/pages/homepage.dart';
import 'package:parking_spot_app/pages/signup_page.dart';
import 'package:parking_spot_app/widget/AppTextField.dart';
import 'package:parking_spot_app/widget/background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/models/user.dart';


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
        title: const Text('משתמש איננו קיים'),
        content: const Text('על מנת להירשם עבור לעמוד ההרשמה'),
        actions: [
          TextButton(
            child: const Text('אישור'),
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

   User extractJsonValues(jsonObject) {
      ParkingKaholLavan? parkingKaholLavan;
      String name = jsonObject["name"];
      String emailAddress = jsonObject["email"];
      String password = jsonObject["password"];
      int points = jsonObject["points"];

      if (jsonObject["parking"] != null){
        String address = jsonObject["parking"]["address"];
        String status = jsonObject["parking"]["status"];
        String latString= jsonObject["parking"]["latitude"].toString();
        String lngString= jsonObject["parking"]["longitude"].toString();
        double lat =double.parse(latString);
        double lng =double.parse(lngString);
        LatLng coordinates = LatLng(lat, lng);
        String releaseTime =jsonObject["parking"]["release_time"];
        bool hidden = jsonObject["parking"]["hidden"];
        
        parkingKaholLavan = ParkingKaholLavan(address, status, coordinates, releaseTime,hidden);
      }
      else{
      parkingKaholLavan = null;
      }

      User user = User(name,emailAddress,password,parkingKaholLavan,points);
       return user;
    }


  Future<User> getUser() async{
    const url = "http://10.0.2.2:5000/signInGet";
    final uri = Uri.parse(url);
    final response = await http.post(
        uri, body: json.encode(
        {'email': emailController.text,
          'password': passwordController.text,
          }));
    
    final message = json.decode(response.body);
    User user = extractJsonValues(message);        
    return user;
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
      if (message != "not exist"){
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
          Container(
  alignment: Alignment.center,
  padding: const EdgeInsets.symmetric(vertical: 20),
  child: Column(
    children: const [
       Text(
        "Parking Spot",
        style: TextStyle(
          fontSize: 32,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

          const SizedBox(height: 45),
          AppTextField( "מייל", "הכנס מייל", Icons.people,emailController,false),
          const SizedBox(height: 20),
          AppTextField("סיסמא", "הכנס סיסמא", Icons.lock,passwordController,true),
          const SizedBox(height: 40),
           ElevatedButton(
        child: Text("כניסה", style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          primary:Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        onPressed: () async {
            bool c = await checkData();
            if (c){
              User user = await getUser();
              clearText();
              Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(user: user)),
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
                  child: const Text("הירשם כאן",style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold,))
              ),
            ],
          ),
        ],
      ),
    );
  }
}