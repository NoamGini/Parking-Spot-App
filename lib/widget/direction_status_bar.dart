import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/controllers/home_controller.dart';
import 'package:parking_spot_app/controllers/navigation_controller.dart';
import 'package:parking_spot_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:parking_spot_app/models/parking_kahol_lavan.dart';
import 'dart:convert';
import 'package:parking_spot_app/pages/homepage.dart';
import '../models/directions_model.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'dart:math';
import 'package:parking_spot_app/models/user.dart';


class DirectionsStatusBar extends StatelessWidget {
  User user;
  final String address;
  bool flagKaholLavan;
   DirectionsStatusBar({super.key,
    required this.user, required this.address, required this.flagKaholLavan});
        

  calculateDistance(currentLat,currentLng, directionLat,directionLng){
  return SphericalUtils.computeDistanceBetween(
              Point(currentLat, currentLng),
              Point(directionLat,directionLng)); 
  }


  User extractJsonValues(jsonObject, theUser) {
      ParkingKaholLavan? parkingKaholLavan;
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

      theUser.addPoints(points);
       return theUser;
    }


  Future<User> grabbedParking(User user, String address) async{

    const url = "http://10.0.2.2:5000/parking_kahol_lavan/grabbing_parking";
    final uri = Uri.parse(url);
    final response = await http.post(
        uri, body: json.encode(
        {'email': user.getEmailAddress,
          'address': address,
          }));
    
    final message = json.decode(response.body);
    User updatedUser = extractJsonValues(message,user);
    return updatedUser;
    }



showAlertDialog(BuildContext context, NavigationController navigationController) {
  if(flagKaholLavan) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 241, 238, 238),
        title: const Text('הגעת ליעד!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
            onPressed: () async {
              User theUser = await grabbedParking(user, address);
              user = theUser;
              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(user: user,)),
                      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children:  [
                SizedBox(
                  width: 40.0, // Adjust the width of the SizedBox to provide space for the icon
                  child: Icon(Icons.monetization_on_rounded, size: 40, color: Colors.amber),
                ),
                SizedBox(width: 5.0),
                Flexible(
                child: Text(
                  '${user.getName}, קיבלת 2 נקודות!',
                  overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                ),
              ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:  [
                SizedBox(height: 10.0),
                Text(
                  '+2',
                  style: TextStyle(fontSize: 30.0, color:Colors.amber, fontWeight: FontWeight.bold, ),
                ),
                Text('סך הכל נקודות: ${user.getPoints}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                    
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(user: user,)),
                      );
                },
                child: const Text('אישור'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary:  Color(0xFF262AAA),
                onPrimary: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              child: const Text('חניתי בחנייה'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(user: user)),
                      );
              },
              style: ElevatedButton.styleFrom(
                primary:  Color(0xFF262AAA),
                onPrimary: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('חפש מחדש'),
                  SizedBox(width: 6.0),
                  Icon(Icons.refresh, color: Colors.white), // Add the refresh icon
                ],
              ),
            ),
          ],
        ),
      );
    });
    },
  );
}
else{
  WidgetsBinding.instance.addPostFrameCallback((_) {
   showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 241, 238, 238),
      title: const Text('הגעת ליעד!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
          onPressed: () async {
           MaterialPageRoute(builder: (context) => HomePage(user: user));
          },
          child: const Text('אישור'),
          ),
        ]
      )
    );
  }
   );});
}
}


  @override
  Widget build(BuildContext context) {
    NavigationController navigationController = Get.find();
    NavigationMapController navigationMapController = Get.find();
    return Obx((){
    if(navigationController.directions.isEmpty) return Container();
    DirectionModel directionModel = DirectionModel.fromJson(navigationController.directions[0]);
    
    double distance = calculateDistance(
      navigationController.newLocation.latitude,
       navigationController.newLocation.longitude,
        directionModel.distance?.lat,
         directionModel.distance?.lng);
    int distanceInt = distance.toInt();

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ]),
            child: navigationMapController.arrived.value ?
            showAlertDialog(context, navigationController)
              : Row(
              children: [
                 Padding(
                  padding: const EdgeInsets.only(left: 5, right: 10),
                  child:  Icon(getIcon(directionModel.instructions!), color: Colors.white, size: 25,),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(data:"""<span>${directionModel.instructions}</span>""",
                      style: {
                        'span':Style(color: Colors.white)
                      }
                     ),
                      Text(" בעוד ${distanceInt.toString()} מטר",
                        style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      );
    });
  }

  IconData getIcon(String instruction){
    if(instruction.contains(Constants.northWest)){
      return Icons.north_west;
    }else if(instruction.contains(Constants.northEast)){
      return Icons.north_east;
    }else if(instruction.contains(Constants.southEast)){
      return Icons.south_east;
    }else if(instruction.contains(Constants.southWest)){
      return Icons.south_west;
    }else if(instruction.contains(Constants.north) || instruction.contains(Constants.straight) ){
      return Icons.north;
    }else if(instruction.contains(Constants.west) || instruction.contains(Constants.left)){
      return Icons.west;
    }else if(instruction.contains(Constants.east) || instruction.contains(Constants.right)){
      return Icons.east;
    }else if(instruction.contains(Constants.south)){
      return Icons.south;
    }
    return Icons.north;
  }
}