import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_spot_app/models/parking_kahol_lavan.dart';

class User {
  User(
    this.name,
    this.emailAddress,
    this.password,
    this.parking,
    this.points,
  );

  final String name;
  final String emailAddress;
  final String password;
  ParkingKaholLavan? parking;
  int points;


  String get getName {
    return name;
  }
   String get getEmailAddress {
    return emailAddress;
  }
   String get getPassword {
    return password;
  }

    ParkingKaholLavan? get getparking {
    return parking;
  }
    int get getPoints{
      return points;
  }

  set setParking(newParking){
      parking=newParking;
  }
  

  addPoints(int addedPoints){
    points=addedPoints;
  }

}
