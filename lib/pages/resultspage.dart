import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/models/parking_info.dart';
import 'package:parking_spot_app/models/socketService.dart';
import 'package:parking_spot_app/sidebar/sidebar.dart';
import 'package:parking_spot_app/widget/single_park_card.dart';
import 'package:parking_spot_app/widget/ParkingFilter.dart';
import 'package:http/http.dart' as http;
import 'package:parking_spot_app/models/user.dart';

class ResultsPage extends StatefulWidget {
  final String? address;
  final User user;
  final bool flagKaholLavan;
  final SocketService socketService;
  const ResultsPage(
      {super.key,
        required this.address,required this.user, required this.flagKaholLavan,
         required this.socketService});
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

  void updateParkingList(Future<List<ParkingInfo>> newList, filterTimeBool) {
    setState(() {
      parkingInfoList = newList;
      timeFilter = filterTimeBool;
    });
  }

  Future<List<ParkingInfo>> getParkingLots(url,address) async{
    String addressUrl="";
    if (address.contains(",")){
      List<String> spliting = address.split(",");
      String newAddress = spliting[0]+spliting[1];
      addressUrl= url+newAddress;
    }
    else{
      addressUrl= url+address;
    }

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
      String latString= jsonObject["GPSLattitude"].toString();
      String lngString= jsonObject["GPSLongitude"].toString();
      double lat =double.parse(latString);
      double lng =double.parse(lngString);
      LatLng coordinates = LatLng(lat, lng);

      String distanceFromDestination = "${parkingLots[i][1]} מ'";
      String walkingTime =parkingLots[i][2];
      ParkingInfo parkingInfo= ParkingInfo(
          parkingCode, parkingName, parkingAddress,status, parkingLotCompany,distanceFromDestination,walkingTime,coordinates
      );

      parkingInfoList.add(parkingInfo);
    }
    return parkingInfoList;
  }
  void reloadFunction() {
    // Implement your reload logic here
    setState(() {
      parkingInfoList = getParkingLots(url,widget.address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(user: widget.user,socketService: widget.socketService,),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                       child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.address!,
                                   style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon:const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ]))])),
          Padding(
            padding: const EdgeInsets.all(5),
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
                        return SingleParkCard(parkingInfo, timeFilter, widget.user, widget.flagKaholLavan);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ 
                        IconButton(
                          onPressed: reloadFunction, // Call your reload function here
                          icon: const Icon(Icons.refresh), // Replace with your reload icon
                          iconSize: 36,
                        ),
                      ],
                    );
                  }
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