import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/models/parking_info.dart';
import 'package:parking_spot_app/widget/single_park_card.dart';
import 'package:parking_spot_app/pages/signup_page.dart';
import 'package:parking_spot_app/widget/AppTextField.dart';
import 'package:parking_spot_app/widget/ParkingFilter.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  final String? address;
  const ResultsPage(
    {super.key,
    required this.address,});
  static const routeName = "ResultsPage";

  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
   
  List<dynamic> parkingLots=[];
  late Future<List<ParkingInfo>> parkingInfoList;
  bool timeFilter = false;
  String url='http://10.0.2.2:5000/closest_parking/';
  final searchController = TextEditingController();
  late Future<List<ParkingInfo>> basicList;
  
  @override
  void initState() {
    super.initState();
    parkingInfoList = getParkingLots(url,widget.address);
    basicList = parkingInfoList;
  }

//maybe not need
  Future<List<ParkingInfo>> changeState(url,address)async {
      Future<List<ParkingInfo>> currentList =  getParkingLots(url, address);
       setState(() {
      parkingInfoList = currentList;
    });
    return parkingInfoList;
  }

  void updateParkingList(Future<List<ParkingInfo>> newList, filterTimeBool) {
  setState(() {
    //print("im hereeeeee");
    parkingInfoList = newList;
    timeFilter = filterTimeBool;
    });
  }

  Future<List<ParkingInfo>> getParkingLots(url,address) async{
    // print(address);
    List<String> spliting = address.split(",");
    //print(spliting);
    String newAddress = spliting[0]+spliting[1];
    //print(newAddress);
    String addressUrl= url+newAddress;

      final response = await http.get(Uri.parse(addressUrl));
      if (response.statusCode ==200){
      final decode = jsonDecode(response.body) as List;
      parkingLots = decode;
      List<ParkingInfo> finalList= extractJsonValues(parkingLots);
      return finalList;
      }
      else{
        throw Exception("error from server");
      }
    }
  
  List<ParkingInfo> extractJsonValues(parkingLots) {
    List<ParkingInfo>  parkingInfoList = [];
    
    for (var i = 0; i < parkingLots.length; i++) {
      String parkingCode = "";
      String parkingLotCompany ="";
      String parkingAddress="";

      var jsonObject = parkingLots[i][0];
      if (jsonObject.containsKey('AhuzotCode')){
        parkingCode = jsonObject['AhuzotCode'].toString();
        parkingLotCompany ='אחוזת החוף';
        parkingAddress = jsonObject["Address"];
      }
      
      else{
        parkingCode = jsonObject['CentralParkCode'].toString();
        parkingLotCompany ='סנטרל פארק';
        parkingAddress = jsonObject["address"];
      }
      String parkingName = jsonObject["Name"];
      String status = jsonObject["InformationToShow"];
      // print(jsonObject["GPSLattitude"].runtimeType);
      // print(double.parse(jsonObject["GPSLattitude"]));
      // print((double.parse(jsonObject["GPSLattitude"])).runtimeType);
      String latString= jsonObject["GPSLattitude"].toString();
      String lngString= jsonObject["GPSLongitude"].toString();
       double lat =double.parse(latString);
      double lng =double.parse(lngString);
      LatLng coordinates = LatLng(lat, lng);
      // print(coordinates);
     
      String distanceFromDestination = parkingLots[i][1].toString()+" מ'"; // You need to calculate this based on user's current location
      String walkingTime =parkingLots[i][2];
      ParkingInfo parkingInfo= ParkingInfo(
        parkingCode, parkingName, parkingAddress,status, parkingLotCompany,distanceFromDestination,walkingTime,coordinates
      );
      //  ParkingInfo parkingInfo= ParkingInfo(
      //   parkingCode, parkingName, parkingAddress,status, parkingLotCompany,distanceFromDestination,walkingTime
      // );
      print("i pass it");
     // print(parkingInfo.getCoordinates);
      
      parkingInfoList.add(parkingInfo);
    }
    return parkingInfoList;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
          ),
          body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 20),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: widget.address,
                      ),
                      onSubmitted: (input) {
                        // Only save the input when the user hits the Enter key
                        if (input.isNotEmpty) {
                         // addToHistory(input);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  )
                ]))])),
    Padding(
      padding: EdgeInsets.all(5),
      child: ParkingFilterWidget(address: widget.address, updateParkingLots: updateParkingList, extract: extractJsonValues),
    ),
    Expanded(
      child: Center(
        child: FutureBuilder<List<ParkingInfo>>(
          future: parkingInfoList,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black26,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  ParkingInfo parkingInfo = snapshot.data?[index];
                  return SingleParkCard(parkingInfo, timeFilter);
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    ),
  ],
),
    );
    }
}