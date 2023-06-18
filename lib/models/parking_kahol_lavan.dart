import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingKaholLavan {
  ParkingKaholLavan(
    this._address,
    this._status,
    this._coordinates,
    this._release_time,

  );

  final String _address;
  String _status;
  String _release_time;
  final LatLng _coordinates;


  LatLng get getCoordinates {
    return _coordinates;
  }

  String get getStatus {
    return _status;
  }

  String get getAddress {
    return _address;
  }

  String get getReleaseTime{
    return _release_time;
  }

}