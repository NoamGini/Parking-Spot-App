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
      duration: const Duration(milliseconds: 500), // Adjust the animation duration as needed
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1), // Start from the bottom of the screen
      end: const Offset(0, 0), // Move to the middle of the screen
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
      duration: const Duration(milliseconds: 500), // Adjust the animation duration as needed
      curve: Curves.easeOut, // Adjust the animation curve as needed
      bottom: _animation.value.dy * MediaQuery.of(context).size.height, // Apply the vertical animation
      left: 0,
      right: 0,
      child: Container(
        width: 200, // Adjust the width as needed
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.parking.getAddress,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Text(widget.parking.getStatus,style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 5),

            Text("זמן נסיעה משוער: ${widget.drivingTime}", style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 5),
            if(widget.parking.getStatus == 'מתפנה בקרוב')
            const Text("זמן פינוי משוער:", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
            child: Container(
              width: 170, // Set the desired width
              height: 40, // Set the desired height
              child: ElevatedButton(
                onPressed: () {
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