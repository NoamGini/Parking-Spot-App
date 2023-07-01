import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/controllers/home_controller.dart';
import 'package:parking_spot_app/controllers/navigation_controller.dart';
import 'package:parking_spot_app/widget/direction_status_bar.dart';
import 'package:parking_spot_app/constants.dart';
import 'package:parking_spot_app/widget/bottom_bar.dart';
import 'package:parking_spot_app/widget/destination_box.dart';
import 'package:parking_spot_app/models/user.dart';

class NavigationPage extends StatefulWidget {
  static const routeName = "NavigationPage";
  final String destinationAddress;
  final LatLng destinationCoordinates;
  User user;
  bool flagKaholLavan;

  NavigationPage({super.key, required this.destinationAddress, required this.destinationCoordinates,
   required this.user, required this.flagKaholLavan});

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late final NavigationMapController homeController;

  @override
  Widget build(BuildContext context) {
    NavigationMapController homeController = Get.put(NavigationMapController(widget.destinationAddress,widget.destinationCoordinates));
    homeController.setDestination(widget.destinationAddress, widget.destinationCoordinates);     
    Get.put(NavigationController());

    return Obx(() => Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: homeController.initialCameraPosition,
                myLocationEnabled: homeController.mapStatus.value != Constants.onDestination,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: homeController.markers.values.toSet(),
                polylines: Set<Polyline>.of(homeController.polyline),
                onMapCreated: (GoogleMapController controller) async {
                  if (!homeController.googleMapsController.isCompleted) {
                  homeController.googleMapsController.complete(controller);
                  }
                  Position position =
                      await homeController.getMyCurrentLocation();
                  homeController.mapStatus.value = Constants.idle;
                  homeController.moveMapCamera(LatLng(position.latitude, position.longitude));
                  homeController.setDestination(widget.destinationAddress, widget.destinationCoordinates);
                },
              ),
               Visibility(
                visible: homeController.mapStatus.value == Constants.route,
                child: const Positioned(
                  top: 0,
                  left: 0,
                  child: DestinationBox(),
                ),
              ),
              Visibility(
                visible: homeController.mapStatus.value == Constants.onDestination,
                child:  Positioned(
                  top: 31,
                  left:0,
                  child:  DirectionsStatusBar(user: widget.user, address: widget.destinationAddress, flagKaholLavan:widget.flagKaholLavan)
                  ),
              ),
              Visibility(
                visible: homeController.mapStatus.value == Constants.idle,
                child: Positioned(
                    bottom: 30,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () async {
                        Position position =
                            await homeController.getMyCurrentLocation();
                        homeController.moveMapCamera(LatLng(
                            position.latitude, position.longitude));
                      },
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        Constants.locateMeIcon,
                        scale: 4,
                      ),
                    )),
              ),
               Visibility(
                visible: homeController.mapStatus.value != Constants.idle,
                child: const Positioned(
                  bottom: 0,
                  left: 0,
                  child: BottomBar(),
                ),
              )
            ],
          ),
        ));
  }
  
   @override
  void dispose() {
    Get.delete<NavigationMapController>();
    Get.delete<NavigationController>();
    super.dispose();
  }
}