import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingInfo {
  ParkingInfo(
    this._parkingCode,
    this._parkingName,
    this._address,
    this._status,
    this._parkingLotCompany,
    this._distanceFromDestination,
    this._walkingTime,
    this._coordinates,
  );

  final String _parkingCode;
  final String _parkingName;
  final String _address;
  final String? _status;
  final String _parkingLotCompany;
  final String _distanceFromDestination;
  String _walkingTime;
  final LatLng _coordinates;


  String get getParkingCode {
    return _parkingCode;
  }
   String get getParkingName {
    return _parkingName;
  }

  String get getDistanceFromDestination {
    return _distanceFromDestination;
  }

  LatLng get getCoordinates {
    return _coordinates;
  }

  String get getwalkingTime{
    List<String> spliting = _walkingTime.split(" ");
    if (spliting[1]=="mins"){
      _walkingTime = spliting[0]+" דק'";
    }
    return _walkingTime;
  }

  String get getParkingLotCompany{
    return _parkingLotCompany;
  }

  String? get getStatus {
    return _status;
  }

  String get getAddress {
    return _address;
  }
}