import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/models/parking_kahol_lavan.dart';
import 'package:parking_spot_app/pages/search_kahol_lavan.dart';
import 'package:parking_spot_app/pages/search_page.dart';
import 'package:parking_spot_app/widget/AppRaisedButton.dart';
import '../models/socketService.dart';
import '../widget/CircularButton.dart';
import '../widget/background.dart';
import '../sidebar/sidebar.dart';
import 'package:parking_spot_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parking_spot_app/constants.dart';


class HomePage extends StatefulWidget {
  static const routeName = "HomePage";
  User user;
  
  HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _StartPageState();
}

class _StartPageState extends State<HomePage> {
  late Uri url;
  late SocketService socketService;
  final List<String> dropdownItems = Constants.dropdownItems;

  String dropdownValue = Constants.pickTime;
  bool finalResponse = false;

  bool isOptionSelected = false;

  late User updateUser;
  bool shouldShowAnimatedOpacity = false;

  get onPressed => null;

  @override
  void initState(){
    super.initState();
    socketService = SocketService();
    socketService.connectToServer();
  }

  User extractJsonValues(jsonObject) {
    ParkingKaholLavan? parkingKaholLavan;
    String name = jsonObject["name"];
    String emailAddress = jsonObject["email"];
    String password = jsonObject["password"];
    int points = jsonObject["points"];

    if (jsonObject["parking"] != null) {
      String address = jsonObject["parking"]["address"];
      String status = jsonObject["parking"]["status"];
      String latString = jsonObject["parking"]["latitude"].toString();
      String lngString = jsonObject["parking"]["longitude"].toString();
      double lat = double.parse(latString);
      double lng = double.parse(lngString);
      LatLng coordinates = LatLng(lat, lng);
      String releaseTime = jsonObject["parking"]["release_time"];
      bool hidden = jsonObject["parking"]["hidden"];

      parkingKaholLavan =
          ParkingKaholLavan(address, status, coordinates, releaseTime,hidden);
    } else {
      parkingKaholLavan = null;
    }

    User user = User(name, emailAddress, password, parkingKaholLavan, points);
    return user;
  }

  Future<User> updateReleaseTimeInDatabases(
      User user, ParkingKaholLavan parking, String releaseTime) async {
    const url = 'http://10.0.2.2:5000/parking_kahol_lavan/release_time';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: json.encode({
          'email': user.emailAddress,
          'address': parking.getAddress,
          'release_time': releaseTime,
        }));
    final jsonResponse = json.decode(response.body);

    User updatedUser = extractJsonValues(jsonResponse);
    return updatedUser;
  }

  Future<User> updateReleaseParkingInDatabases(
      User user, ParkingKaholLavan parking) async {
    const url = 'http://10.0.2.2:5000/parking_kahol_lavan/release_parking';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: json.encode({
          'email': user.emailAddress,
          'address': parking.getAddress,
        }));
    final jsonResponse = json.decode(response.body);
    User updatedUser = extractJsonValues(jsonResponse);
    return updatedUser;
  }

  Future<User> updateReleaseTime(User user, ParkingKaholLavan? parking) async {
    User updatedUser;
    if (dropdownValue == 'עכשיו') {
      updatedUser = await updateReleaseParkingInDatabases(user, parking!);
      return updatedUser;
    }

    if (dropdownValue != 'עכשיו' && dropdownValue != "בחר מועד") {
      int minutes = int.parse(dropdownValue.split(' ')[1]);
      DateTime futureTime = DateTime.now().add(Duration(minutes: minutes));
      String formattedTime = '${futureTime.hour.toString().padLeft(2, '0')}:${futureTime.minute.toString().padLeft(2, '0')}';

      updatedUser =
          await updateReleaseTimeInDatabases(user, parking!, formattedTime);
      return updatedUser;
    }

    // Return a default value or throw an error if needed
    throw Exception('Unexpected code path');


  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    ParkingKaholLavan? parking = user.getparking;
    DateTime currentTime = DateTime.now();
    DateTime releaseTime;
    bool hasParkingExpired = false;

    if (parking != null) {
      if (parking.getReleaseTime != '') {
        List<String> timeComponents = parking.getReleaseTime.split(':');
        int hour = int.parse(timeComponents[0]);
        int minute = int.parse(timeComponents[1]);
        releaseTime = DateTime(currentTime.year, currentTime.month, currentTime.day, hour, minute);
    
        // Compare the current time with the parking release time
        hasParkingExpired = releaseTime.isBefore(currentTime);
      }
    }

    shouldShowAnimatedOpacity =
        user.getparking?.getStatus == "מתפנה בקרוב" ||  user.getparking?.getStatus == "תפוס";

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: SideBar(user: user,
      socketService : socketService),
      body: Background(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(children: [
            Center(
              child: startPageDesign(context, user),
            ),
            if (shouldShowAnimatedOpacity)
              AnimatedOpacity(
                opacity: 0.95,
                duration: Duration(milliseconds: 300),
                onEnd: () {
                  if (dropdownValue != 'בחר מועד' || updateUser != null) {
                    setState(() {
                      shouldShowAnimatedOpacity = false;
                    });
                  }
                },
                child: Center(
                  child: Container(
                    width: 450,
                    height: 300,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ' עלייך לשחרר את החנייה ברחוב: \n ${parking?.getAddress} \nבטרם תמשיך פעולותיך באפליקציה \n',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'אשחרר את החנייה',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            DropdownButton<String>(
                              value: dropdownValue,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              alignment: AlignmentDirectional.center,
                              onChanged: (String? newValue) async {
                                setState(() {
                                  dropdownValue = newValue!;
                                });

                                updateUser = await updateReleaseTime(user, parking);

                                setState(() {
                                  if (updateUser.getparking == null){
                                    shouldShowAnimatedOpacity = false;
                                  }
                                  dropdownValue = newValue!;
                                  isOptionSelected = true;
                                });
                              },

                              items: dropdownItems
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                        AppRaisedButton("אישור", () async {
                          if (updateUser.getparking != null && dropdownValue != "בחר מועד") {
                            updateUser = await updateReleaseTime(user, parking);
                          }
                          if (updateUser.getparking == null || updateUser.getparking?.getReleaseTime != "") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage(user: updateUser)),
                              );
                            }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              alignment: Alignment.topRight,
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
    );
  }

  Column startPageDesign(BuildContext context, User user) {
    if (user.getparking != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "שלום!",
            style: TextStyle(
              fontSize: 60,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "איפה מחנים היום?",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w100,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          IgnorePointer(
            ignoring: true,
            child: CircularButton(
              "חפש חניון",
              170,
              const Color(0xFF262AAA),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(user: user, flagKaholLavan: false, socketService: socketService)),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          IgnorePointer(
            ignoring: true,
            child: CircularButton(
              "חפש כחול לבן בסביבתי",
              170,
              const Color(0xFF262AAA),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchKaholLavan(user: user,
                       flagKaholLavan: true,
                       socketService : socketService
                       )),
                );
              },
            ),
          ),
        ],
      );
    } else {
      // Return the original Column widget if user.getParkingLocation is null
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "שלום!",
            style: TextStyle(
              fontSize: 60,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "איפה מחנים היום?",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w100,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          CircularButton(
            "חפש חניון",
            170,
            const Color(0xFF262AAA),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage(user: user,flagKaholLavan: false, socketService: socketService)),
              );
            },
          ),
          const SizedBox(height: 20),
          CircularButton(
            "חפש כחול לבן בסביבתי",
            170,
            const Color(0xFF262AAA),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchKaholLavan(user: user,
                 flagKaholLavan: true,
                 socketService : socketService
                 )),
              );
            },
          ),
        ],
      );
    }
  }
}