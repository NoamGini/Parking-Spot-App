import 'package:flutter/material.dart';
import 'package:parking_spot_app/models/parking_kahol_lavan.dart';
import '../models/user.dart';
import '../pages/navigationPage.dart';

class ParkingInfoBox extends StatefulWidget {
  final ParkingKaholLavan parking;
  final String drivingTime;
  final bool flagKaholLavan;
  User user;

 ParkingInfoBox({super.key, required this.parking,required this.drivingTime, required this.user, required this.flagKaholLavan});


  @override
  ParkingInfoBoxState createState() => ParkingInfoBoxState();
}

class ParkingInfoBoxState extends State<ParkingInfoBox> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Adjust the animation duration as needed
    );

    _animation = Tween<Offset>(
      begin: Offset(0, -1), // Start from the bottom of the screen
      end: Offset(0, 0), // Move to the middle of the screen
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Adjust the animation curve as needed
    ));

    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

   void dismissInfoBox() {
    _animationController.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500), // Adjust the animation duration as needed
      curve: Curves.easeOut, // Adjust the animation curve as needed
      bottom: _animation.value.dy * MediaQuery.of(context).size.height, // Apply the vertical animation
      left: 0,
      right: 0,
      child: Container(
        width: 200, // Adjust the width as needed
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.parking.getAddress,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Text(widget.parking.getStatus,style: TextStyle(fontSize: 18),),
            const SizedBox(height: 5),

            Text("זמן נסיעה משוער: ${widget.drivingTime}", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 5),
            if(widget.parking.getStatus == 'מתפנה בקרוב')
              Text("זמן פינוי משוער:", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
            child: Container(
              width: 170, // Set the desired width
              height: 40, // Set the desired height
              child: ElevatedButton(
                onPressed: () {
                  //navigate to the navigation page 
                // Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) =>  NavigationPage(destinationAddress: widget.parking.getAddress, destinationCoordinates: widget.parking.getCoordinates,)),
                //       );
                 Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  NavigationPage(destinationAddress: widget.parking.getAddress, destinationCoordinates: widget.parking.getCoordinates, user: widget.user, flagKaholLavan: widget.flagKaholLavan)),
                      );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF262AAA),
                onPrimary: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Set the desired border radius
                  ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('נווט לחנייה'),
                  SizedBox(width: 6.0),
                  Icon(Icons.navigation_rounded, color: Colors.white), // Add the refresh icon
                ],
              ),
            ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}




// class ParkingInfoBox extends StatelessWidget {
//   final ParkingKaholLavan parking;
//   final GoogleMapController controller;

//   const ParkingInfoBox({super.key,required this.parking, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getMarkerPixelPosition(context),
//       builder: (BuildContext context, AsyncSnapshot<Offset> snapshot) {
//         if (snapshot.hasData) {
//           final Offset markerPosition = snapshot.data!;
//           return Positioned(
//             top: markerPosition.dy - 100, // Adjust the vertical position as needed
//             left: markerPosition.dx + 20, // Adjust the horizontal position as needed
//             child: Container(
//               width: 200, // Adjust the width as needed
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     parking.getAddress,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   Text(parking.getStatus),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return Container(); // Placeholder widget or loading indicator
//         }
//       },
//     );
//   }

//   Future<Offset> getMarkerPixelPosition(BuildContext context) async {
//     // final GoogleMapController controller =
//     //     await GoogleMapController.of(context);
//     final LatLng markerLatLng = parking.getCoordinates;
//     final ScreenCoordinate markerScreenCoordinate =
//         await controller.getScreenCoordinate(markerLatLng);
//     return Offset(markerScreenCoordinate.x.toDouble(),
//         markerScreenCoordinate.y.toDouble());
//   }
// }



// class ParkingInfoBox extends StatelessWidget {
//   final ParkingKaholLavan parking;
//   final GoogleMapController controller;
//   final double markerSize = 48.0; // Adjust the marker size as needed

//   const ParkingInfoBox({required this.parking, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ScreenCoordinate?>(
//       future: getMarkerScreenCoordinate(),
//       builder: (BuildContext context, AsyncSnapshot<ScreenCoordinate?> snapshot) {
//         if (snapshot.hasData && snapshot.data != null) {
//           final ScreenCoordinate markerScreenCoordinate = snapshot.data!;
//           final LatLng markerLatLng = parking.getCoordinates;
//           final double markerPixelX = markerScreenCoordinate.x.toDouble();
//           final double markerPixelY = markerScreenCoordinate.y.toDouble();

//           return Positioned(
//             left: markerPixelX - (markerSize / 2),
//             top: markerPixelY - markerSize,
//             child: Container(
//               width: 50,
//               height:100, // Adjust the width as needed
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     parking.getAddress,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   Text(parking.getStatus),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           return Container(
//             child:
//             Text("nothing"),
            
//           ); // Placeholder widget or loading indicator
//         }
//       },
//     );
//   }

//   Future<ScreenCoordinate?> getMarkerScreenCoordinate() async {
//     final LatLng markerLatLng = parking.getCoordinates;
//     final double zoomLevel = await controller.getZoomLevel();
//     final ScreenCoordinate markerScreenCoordinate = await controller.getScreenCoordinate(markerLatLng);
//     print("screen coordinates");
//     print(markerScreenCoordinate.toString());
//     return markerScreenCoordinate;
//   }
// }