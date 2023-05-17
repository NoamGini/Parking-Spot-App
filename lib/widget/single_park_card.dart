import 'package:flutter/material.dart';
//import 'package:parking_spot_app/google_map_widget.dart';
// 'package:park_buddy/control/ScreenManager.dart';
//import 'package:park_buddy/entity/CarparkAvailability.dart';
import 'package:parking_spot_app/models/parking_info.dart';
import 'package:parking_spot_app/pages/navigationPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleParkCard extends StatelessWidget {
  static const routeName = "SingleParkCard";
  final ParkingInfo parking;
  bool isTimeFilterActive;
 // final CarparkAvailability carparkAvailability;
 // CarparkCard(this.carpark, this.carparkAvailability);
  SingleParkCard(this.parking,this.isTimeFilterActive);
  Map colorDict={"פנוי": Colors.green,"מעט":Colors.orange , "מלא":Colors.red, "    ":Colors.grey};
  ///Builds the SingleParkCard widget.
  @override
  Widget build(BuildContext context) {
    String? parkingAvalability = parking.getStatus;
    print("status: $parkingAvalability of $parking.getParkingName");
    if (parkingAvalability != "") {
      return GestureDetector(
  onTap: () {
    // Navigate to the next page
    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationPage(destinationAddress: parking.getAddress, destinationCoordinates: parking.getCoordinates),)); 
                 // builder: (context) => NavigationPage(destinationAddress: parking.getAddress, destinationCoordinates: const LatLng(32.0779222,34.7741656)),)); 
  },
  child: Container(
        padding: EdgeInsets.only(
          top: 20,
          right: 10,
          left: 10,
        ),
      //alignment: Alignment.center,
      margin: EdgeInsets.all(7),
      height: 100,
      decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(children: <Widget>[
        Row(children: [
          Column(children: [
            ClipOval(
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.local_parking_rounded,
                    color: Color(0xFF262AAA),
                    size: 40.0,
                  )),
            ),
          ]),
          SizedBox(
            width: 20,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  //parking.getParkingName.substring(0, 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  parking.getParkingName,
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  parking.getAddress,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  parking.getParkingLotCompany,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
              ]),
          Spacer(),
          Column(
              children: [
                Container(
                    child: Stack(children: <Widget>[
                      Column(children: [
                        Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                            ),
                            padding: EdgeInsets.only(right: 15),
                            //alignment: Alignment.center,                                            
                            //margin: EdgeInsets.only(bottom: 20,),
                            height: 40,
                            width: 90,
                            child: Row( children:[                                             
                          CircleAvatar(
                            radius: 5.0,
                            backgroundColor:colorDict[parkingAvalability],
                          ),
                          SizedBox(width: 15),
                          Text(
                            parking.getStatus.toString(),
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight:
                                    FontWeight.bold),
                          )])),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: <Widget>[
                          Text(
                            parking.getDistanceFromDestination,
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          if (isTimeFilterActive) // <-- render time if filter is active
                             SizedBox(width: 10),
                          if (isTimeFilterActive)          
                            Text(
                              parking.getwalkingTime,
                              style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                          ),
                          
                        ])
                      ])
                    ]))
              ])
        ])
      ])));
    }
   return _missingAvailabilityCard();
  }


 ///If the carparkAvailability is missing, it means the API has not finished loading yet, so we show some loading text.
  Widget _missingAvailabilityCard(){
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 25.0,
            //backgroundImage: AssetImage('assets/images/parking-icon.png'),
          ),
          title: Text(parking.getParkingCode),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                parking.getAddress.substring(0, 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
             //   parking.getAddress,
                style: const TextStyle(fontSize: 15.0),
              ),
              Text(
                  parking.getParkingLotCompany,
                  style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  parking.getDistanceFromDestination,
                  style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Loading lot availability...",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
 }