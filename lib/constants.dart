import 'package:flutter/material.dart';
//import 'package:parking_spot_app/google_map_widget.dart';

/// Defines all the constants used by [GoogleMapsWidget].
class Constants {
  Constants._();
  static const googleApiKey ="AIzaSyDKupYcq3t0hyHTn-YQRriH57ch-Ekw0cs";
  static const kDefaultCameraZoom = 15.0;
  static const kRouteWidth = 5;
  static const kRouteColor = Colors.indigo;
  static const kDefaultMarkerSize = Size.square(150);
  //added
  static const locateMeIcon = 'assets/images/locate_me.png';
  static const mapIcon = 'assets/images/map_icon.png';
  static const driverCarImage = 'assets/images/car.png';
  static const idle = "idle";
  static const route = "route";
  static const onDestination = "on destination";
  static const north = 'צפון';
  static const east = 'מזרח';
  static const south = 'דרום';
  static const west = 'מערב';
  static const northEast = 'צפון-מזרח';
  static const northWest = 'צפון-מערב';
  static const southEast = 'דרום-מזרח';
  static const southWest = 'דרום-מערב';
  static const straight = 'ישר';
  static const right = 'ימינה';
  static const left = 'שמאלה';
}