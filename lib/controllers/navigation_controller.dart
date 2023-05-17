import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/controllers/home_controller.dart';
import 'package:parking_spot_app/constants.dart';
import 'package:google_maps_utils/google_maps_utils.dart';

class NavigationController extends GetxController {
  NavigationMapController navigationMapController = Get.find();
  late StreamSubscription<Position>? positionStream;
  var oldLatitude = 0.0.obs;
  var oldLongitude = 0.0.obs;
  var directions = [].obs;
  late LatLng newLocation;

  navigateToDestination() async {
    navigationMapController.mapStatus.value = Constants.onDestination;
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async{
              LatLng newPosition = LatLng(position!.latitude, position.longitude);
              newLocation=newPosition;
              print(newPosition.latitude);
              navigationMapController.addDriverMarker(LatLng(oldLatitude.value, oldLongitude.value), newPosition);
              oldLatitude.value = position.latitude;
              oldLongitude.value = position.longitude;      
              navigationMapController.moveMapCamera(newPosition, zoom: 18, bearing: position.heading);
              navigationMapController.getTotalDistanceAndTime(navigationMapController.destinationCoordinates);
              bool isOnRoute = getRouteDeviation(newPosition);
              if(!isOnRoute || directions.isEmpty){
                print("directions empty");
                await navigationMapController.drawRoute(navigationMapController.destinationCoordinates);
                await getDirections(LatLng(position.latitude, position.longitude), navigationMapController.destinationCoordinates);
              }
              getNextDirection(LatLng(position.latitude, position.longitude));
    });
  }

  reset(){
    directions.clear();
    positionStream?.cancel();
    positionStream = null;
    oldLatitude.value = 0.0;
    oldLongitude .value= 0.0;
    newLocation= LatLng(0, 0);

  }

  stopNavigation()async{
    positionStream?.cancel();
    navigationMapController.mapStatus.value = Constants.route;
    navigationMapController.positionCameraToRoute(navigationMapController.polyline);
    navigationMapController.markers.remove(const MarkerId("driverMarker"));
  }

  getRouteDeviation(LatLng location) {
    List<Point<num>> points = [];
    List<LatLng> list = navigationMapController.polylineCoordinates.toList();
    for (var i = 0; i < list.length; i++) {
      points.add(Point(list[i].latitude, list[i].longitude));
    }
    bool r = PolyUtils.isLocationOnEdgeTolerance(
        Point(location.latitude, location.longitude), points, false, 100);

    return r;
  }

  getDirections(LatLng from, LatLng to) async {
    String origin = "${from.latitude},${from.longitude}";
    String destinations = "${to.latitude},${to.longitude}";
    print(origin);
    print(destinations);
    Dio dio = Dio();
    var response = await dio.get(
        "https://maps.googleapis.com/maps/api/directions/json?units=imperial&origin=$origin&destination=$destinations&key=${Constants.googleApiKey}&language=he");
    var data = response.data;
    if(data == null){
      print("im empty");
    }
    final dir = data['routes'][0]['legs'][0]['steps']
        .map((h) => {
              "instructions": h['html_instructions'],
              "distance": h['start_location']
            })
        .toList();
    directions.value = [...dir];
    print("hello");
    print(directions[0]);
    print(directions[1]);
    print(directions[2]);
    update();
  }

    getNextDirection(LatLng from) {
    if (directions.length > 1) {
      var closestDirectionIndex = directions.where((direction) =>
          SphericalUtils.computeDistanceBetween(
              Point(from.latitude, from.longitude),
              Point(
                  direction['distance']['lat'], direction['distance']['lng'])) <
          7);
      if (closestDirectionIndex.isNotEmpty) {
        directions.removeAt(0);
        update();
      }
    }
  }
}