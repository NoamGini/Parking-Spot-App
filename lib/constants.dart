import 'package:flutter/material.dart';
class Constants {
  Constants._();
  static const googleApiKey ="AIzaSyDGG3PgHwpThGyw-BeKsaTs3mS5eS3BZXE";
  static const kDefaultCameraZoom = 15.0;
  static const kRouteWidth = 5;
  static const kRouteColor = Colors.indigo;
  static const kDefaultMarkerSize = Size.square(150);
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
  static const serverUrl = 'http://10.0.2.2:5000/';
  static const transports = 'transports';
  static const websocket = 'websocket';
  static const autoConnect = 'autoConnect';
  static const connectedToServer = 'Connected to server';
  static const errorConnectingToServer = 'Error connecting to server:';
  static const disconnectedFromServer = 'Disconnected from server';
  static const grabbedParkingUpdate = 'grabbed_parking_update';
  static const releaseParkingUpdate = 'release_parking_update';
  static const releaseTimeUpdate = 'release_time_update';
  static const hiddenParkingUpdate = 'hidden_parking_update';
  static const address = 'address';
  static const status = 'status';
  static const latitude = 'latitude';
  static const longitude = 'longitude';
  static const releaseTime = 'release_time';
  static const hidden = 'hidden';
  static const error ='error';
  static const urlParkingKaholLavan ='http://10.0.2.2:5000/parking_kahol_lavan';
  static const errorFromServer = "error from server";
  static const searchKaholLavanRoute ="SearchKaholLavan";
  static const emptyString="";
  static const initialLat = 32.0636787;
  static const initialLon = 34.7636925;
  static const initialZoom = 16.0;
  static const okStatus = 200;
  static const locationDisable = "Location services are disabled.";
  static const permissionsDenied = "Location permissions are denied";
  static const cannotRequestPermissions = "Location permissions are permanently denied, we cannot request permissions.";
  static const drivingTimeLimit = 7;
  static const whiteSpace = ' ';
  static const statusFree = 'פנוי';
  static const statusGrabbed = 'תפוס';
  static const calculateDrivingTimeURL= "https://maps.googleapis.com/maps/api/directions/json?";
  static const routes = 'routes';
  static const legs = 'legs';
  static const duration = 'duration';
  static const text = 'text';
  static const mins = 'mins';
  static const min = 'min';
  static const minsString = " דקות";
  static const legendString = 'מקרא:';
  static const freeParkingString = 'חניה פנויה';
  static const grabbedParkingString = 'חניה תפוסה';
  static const releaseSoonParkingString = 'חניה מתפנה בקרוב';
  static const greenMarker = Color.fromARGB(255, 105, 237, 109);
  static const orangeMarker = Color.fromARGB(255, 232, 143, 28);
  static const List<String> dropdownItems = [
    'בחר מועד',
    'עכשיו',
    'בעוד 5 דק\'',
    'בעוד 10 דק\'',
    'בעוד 15 דק\'',
    'בעוד 20 דק\'',
  ];
  static const pickTime = 'בחר מועד';
  static const navigationPageRoute = "NavigationPage";
  static const tilt = 45.0;
  static const destination = "destination";
  static const driverMarker = "driverMarker";
  static const rows = "rows";
  static const elements = "elements";
  static const distance = "distance";
  static const value = "value";
  static const maxDistance = 5;
  static const kilometersString =" קמ'";
  static const oneKm = 1000;
  static const hour = 60;
  static const two = 2;
  static const distanceFilter = 1;
  static const navigationZoom = 18.0;
  static const steps = 'steps';
  static const instructions = 'instructions';
  static const startLocation = 'start_location';
  static const htmlInstructions = 'html_instructions';
  static const lat = 'lat';
  static const lng = 'lng';
  static const hebrew = "he";
  static const israel = "IS";
  static const title = 'login_signup';
  // static const startLocation = 'start_location';
  // static const htmlInstructions = 'html_instructions';
  // static const lat = 'lat';
  // static const lng = 'lng';
  static const Map colorDict={"פנוי": Colors.green,"מעט":Colors.orange , "מלא":Colors.red,};



}