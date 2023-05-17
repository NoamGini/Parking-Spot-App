import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  User(
    this._name,
    this._emailAddress,
    this._password,
    this._parkingHistory,
    this._parkingLocation,
  );

  final String _name;
  final String _emailAddress;
  final String _password;
  final List _parkingHistory;
  //maybe should be coordinates
  final String _parkingLocation;


  String get getName {
    return _name;
  }
   String get getEmailAddress {
    return _emailAddress;
  }
   String get getPassword {
    return _password;
  }
   List get getParkingHistory {
    return _parkingHistory;
  }
    String get getparkingLocation {
    return _parkingLocation;
  }
}
