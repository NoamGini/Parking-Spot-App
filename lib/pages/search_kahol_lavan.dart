import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/models/parking_kahol_lavan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parking_spot_app/widget/parking_info_box.dart';
import '../constants.dart';
import '../models/socketService.dart';
import '../models/user.dart';
import '../widget/LegendItem.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SearchKaholLavan extends StatefulWidget {
  User user;
  bool flagKaholLavan; 
  SocketService socketService;

    SearchKaholLavan({super.key,
    required this.user, required this.flagKaholLavan, required this.socketService});
  static const routeName = "SearchKaholLavan";
  @override
  _SearchKaholLavanState createState() => _SearchKaholLavanState();
}

class _SearchKaholLavanState extends State<SearchKaholLavan> {
  late GoogleMapController googleMapController;
  //decode
  List<ParkingKaholLavan> parkingsKaholLavan=[];
  List<dynamic> decodedList=[];
  Set<Marker> markers={};
  ParkingKaholLavan? selectedParking;
  late Position currentposition;
  String drivingTime="";


  @override
  void initState() {
    super.initState();
    getParkingsKaholLavan().then((parkingLots) {
      parkingsKaholLavan = parkingLots;
      createMarkers();
    }).catchError((error) {
      print('Error: $error');
    });
    widget.socketService.addParkingUpdateHandler(handleParkingUpdate);
  }


  void handleParkingUpdate(dynamic data) {
    print('trigger the handler');
    print(data);
    String dataString =  utf8.decode(data);
    // Parse the received data
    print(dataString);
    final jsonObject = json.decode(dataString);
    print(jsonObject);
    // int points = jsonObject["points"];
    String address = jsonObject["address"];
    print(address);
    String status = jsonObject["status"];
    String latString= jsonObject["latitude"].toString();
    String lngString= jsonObject["longitude"].toString();
    print(latString);
    double lat =double.parse(latString);
    double lng =double.parse(lngString);
    LatLng coordinates = LatLng(lat, lng);
    print(coordinates);
    String releaseTime =jsonObject["release_time"];
    print(releaseTime);
    
    ParkingKaholLavan parkingKaholLavan = ParkingKaholLavan(address, status, coordinates, releaseTime);


      // Find the grabbed parking in the list and update its status
      final releasedParking = parkingsKaholLavan.firstWhere((parking) => parking.getAddress == address);

    if (mounted){
      //set state
      setState(() {
        //remove from list
        parkingsKaholLavan.remove(releasedParking);

        // Add the new parking to the list
        parkingsKaholLavan.add(parkingKaholLavan);
      });
    }
      print("creating maekers");
      // Refresh the map to reflect the updated state
      createMarkers();

}


  // void connectToServer() {
  // // Define the server URL and namespace
  // final serverUrl = 'http://10.0.2.2:5000/';
  // final namespace = '/parkingUpdate';

  // // Create the WebSocket connection
  // IO.Socket socket = IO.io(serverUrl, <String, dynamic>{
  //   'transports': ['websocket'],
  //   'autoConnect': true,
  //   //'query': {'namespace': namespace},
  // });
  

  // // Set up event listeners for the desired events
  // socket.on('grabbed_parking_update', handleParkingUpdate);
  // socket.on('release_parking_update', handleParkingUpdate);

  // // Connect to the server
  // socket.connect();
// }


  static const CameraPosition initialCameraPosition =  CameraPosition(
    target: LatLng(32.0636787,34.7636925),
    zoom: 16,
  );


  Future<List<ParkingKaholLavan>> getParkingsKaholLavan() async{
    String url='http://10.0.2.2:5000/parking_kahol_lavan';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode ==200){
      final decode = jsonDecode(response.body) as List;
      decodedList = decode;
      List<ParkingKaholLavan> finalList= extractJsonValues(decodedList);
      return finalList;
      }
      else{
        throw Exception("error from server");
      }
 }

  List<ParkingKaholLavan> extractJsonValues(parkingsKaholLavan) {

    List<ParkingKaholLavan> parkingKaholLavanList = [];
    for (var i = 0; i < parkingsKaholLavan.length; i++) {

      var jsonObject = parkingsKaholLavan[i];
      String address = jsonObject["address"];
      String status = jsonObject["status"];
      String latString= jsonObject["latitude"].toString();
      String lngString= jsonObject["longitude"].toString();
      double lat =double.parse(latString);
      double lng =double.parse(lngString);
      LatLng coordinates = LatLng(lat, lng);
      String releaseTime =jsonObject["release_time"];
      
      ParkingKaholLavan parkingKaholLavan = ParkingKaholLavan(address, status, coordinates, releaseTime);
      parkingKaholLavanList.add(parkingKaholLavan);
    }
    return parkingKaholLavanList;
  }


  Future getMyCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position location = await Geolocator.getCurrentPosition(); 
    // print(location.latitude);
    // print(location.longitude);
    currentposition = location;
    return location;
  }

  Future<List<ParkingKaholLavan>> getClosestParking(List<ParkingKaholLavan> parkingList) async {
  List<ParkingKaholLavan> closestParkings = [];
  Position currentLoc = await getMyCurrentLocation();
  for (var parking in parkingList) {
    String drivingTime = await calculateDrivingTime(LatLng(currentLoc.latitude,currentLoc.longitude), parking.getCoordinates);
    if (drivingTime != null) {
      print(drivingTime);
      int minutes = int.parse(drivingTime.split(' ')[0]);
      if (minutes != null && minutes < 7) {
        closestParkings.add(parking);
      }
    }
  }

  return closestParkings;
}

  void createMarkers() async {
    print("creates markerssss");
    markers.clear();
   // List<ParkingKaholLavan> parkingList = await getClosestParking(parkingsKaholLavan);
    for (var parking in parkingsKaholLavan) {
      BitmapDescriptor markerIcon;
      if (parking.getStatus == 'פנוי') {
        markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen); // Use default marker for available parking
      } else if (parking.getStatus == 'תפוס') {
        markerIcon = BitmapDescriptor.defaultMarker; // Use red marker for occupied parking
      } else {
        markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange); // Use yellow marker for parking about to be vacated
      }
      Marker marker = Marker(
        markerId: MarkerId(parking.getAddress),
        position: parking.getCoordinates,
        icon: markerIcon,
        onTap: () => onMarkerTapped(parking)
      );
      markers.add(marker);
    }
    setState(() {});
  }

  
   Future<String> calculateDrivingTime(LatLng origin, LatLng destination) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=${Constants.googleApiKey}&language=he';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      String durationText = decoded['routes'][0]['legs'][0]['duration']['text'];
      return durationText;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  void onMarkerTapped(ParkingKaholLavan parking) async {
   // showParkingInfoBox = true;
    selectedParking = parking;
    String drivingTimeToPark = await calculateDrivingTime(LatLng(currentposition.latitude, currentposition.longitude), parking.getCoordinates);
    setState(() {
      selectedParking = parking;
      if (drivingTimeToPark.contains("mins") || drivingTimeToPark.contains("min")){
        List timeInEnglish;
        timeInEnglish = drivingTimeToPark.split(" ");
        drivingTime = timeInEnglish[0]+" דקות";
      }
      else{
        drivingTime = drivingTimeToPark;
      }
    });
  
  }

  void hideInfoBox() {
    print("tap");
    setState(() {
      print("hi");
      selectedParking = null;
      drivingTime="";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
         actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body:
      //  GestureDetector(
      //   onTap: hideInfoBox, // Call hideInfoBox when the user taps anywhere on the screen
      //   behavior: HitTestBehavior.translucent,
      //   child:
         Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) async {
                googleMapController = controller;
                Position position = await getMyCurrentLocation();
                googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 14,
                    ),
                  ),
                );
              },
            ),
            // Legend Widget
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              // child: Align(
              //   alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                      Text(
                        'מקרא:', // Title of the legend
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    SizedBox(height: 8),
                    LegendItem(
                      color: Color.fromARGB(255, 105, 237, 109), // Marker type color
                      label: 'חניה פנויה', // Marker type label
                    ),
                    SizedBox(height: 5),
                    LegendItem(
                      color: Colors.red, // Marker type color
                      label: 'חניה תפוסה', // Marker type label
                    ),
                    SizedBox(height: 5),
                    LegendItem(
                      color: Color.fromARGB(255, 232, 143, 28), // Marker type color
                      label: 'חניה מתפנה בקרוב', // Marker type label
                    ),
                  ],
                ),
            //  ),
              ),
            ),
            // if (selectedParking != null)
      // GestureDetector(
      //   onTap: hideInfoBox,
      //   child: Container(
      //     color: Colors.transparent,
      //     width: MediaQuery.of(context).size.width,
      //     height: MediaQuery.of(context).size.height,
      //   ),
      // ),
    if (selectedParking != null)
      ParkingInfoBox(
        parking: selectedParking!,
        drivingTime: drivingTime,
        user: widget.user,
        flagKaholLavan: widget.flagKaholLavan
      ),

        
//           Visibility(
//   visible: selectedParking != null,
//   child: selectedParking != null
//     ? ParkingInfoBox(
//         parking: selectedParking!,
//         drivingTime: drivingTime,
//         //user: widget.user,
//         // controller: googleMapController,
//       )
//     : SizedBox.shrink(),
// ),
          
        ],
      ),
  );
}
}