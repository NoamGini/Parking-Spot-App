import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_spot_app/constants.dart';
import 'dart:ui' as ui;

class NavigationMapController extends GetxController with GetTickerProviderStateMixin {
  LatLng destinationCoordinates;
  String destinationAddress;
  NavigationMapController(this.destinationAddress,
    this.destinationCoordinates);
  late Completer<GoogleMapController> googleMapsController = Completer();
  var destination = Constants.emptyString.obs;
  var distanceLeft = Constants.emptyString.obs;
  var timeLeft = Constants.emptyString.obs;
  var mapStatus = Constants.route.obs;
  var arrived = false.obs;
  var gettingRoute = false.obs;
  var markers = <MarkerId, Marker>{}.obs;
  List<LatLng> polylineCoordinates = <LatLng>[].obs;
  Set<Polyline> polyline = <Polyline>{}.obs;
  Animation<double>? animation;


  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(Constants.initialLat,Constants.initialLon),
    zoom: Constants.initialZoom,
  );

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DirectionsService.init(Constants.googleApiKey);
    });
    super.onInit();
  }

  Future moveMapCamera(LatLng target,
      {double zoom = Constants.initialZoom, double bearing = 0}) async {

    CameraPosition newCameraPosition =
        CameraPosition(target: target, zoom: zoom, bearing: bearing, tilt: Constants.tilt);

    final GoogleMapController controller = await googleMapsController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future getMyCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(Constants.locationDisable);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(Constants.permissionsDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          Constants.cannotRequestPermissions);
    }
    return await Geolocator.getCurrentPosition();
  }

  
  clearDestination() async {
    destinationAddress=Constants.emptyString;
    destinationCoordinates= const LatLng(0,0);
    destination.value = Constants.emptyString;
    mapStatus.value = Constants.idle;
    polyline.clear();
    polylineCoordinates.clear();
    markers.clear();
  }

  setDestination(String address, LatLng coordinates ) async {
    destination.value =address;
    destinationAddress =address;
    destinationCoordinates=coordinates;
    mapStatus.value = Constants.route;
    await drawRoute(coordinates);
    await addDestinationMarker(coordinates);
    getTotalDistanceAndTime(coordinates);
  }

  drawRoute(LatLng destination) async {
    try {
      if (polyline.isNotEmpty) {
        polyline.clear();
        polylineCoordinates.clear();
        update();
      }
      if(gettingRoute.value) return;

      gettingRoute.value = true;

      final directionsService = DirectionsService();
      Position myCurrentLocation = await getMyCurrentLocation();

      final request = DirectionsRequest(
        origin: "${myCurrentLocation.latitude},${myCurrentLocation.longitude}",
        destination: "${destination.latitude},${destination.longitude}",
        travelMode: TravelMode.driving,
      );

      await directionsService.route(request,
          (DirectionsResult response, status) {
        if (status == DirectionsStatus.ok) {
          for (GeoCoord value
              in response.routes!.asMap().values.single.overviewPath!) {
            polylineCoordinates.add(LatLng(value.latitude, value.longitude));
          }
        }
      });

      PolylineId id = const PolylineId( Constants.route);

      Polyline myPolyline = Polyline(
          width: 4,
          visible: true,
          polylineId: id,
          color: Colors.blueAccent,
          points: polylineCoordinates);
      polyline.add(myPolyline);
      if (mapStatus.value != Constants.onDestination) {
        await positionCameraToRoute(polyline);
      }
    }finally{
       gettingRoute.value = false;
    }
  }

  positionCameraToRoute(Set<Polyline> polylines) async {
    try {
      double minLat = polylines.first.points.first.latitude;
      double minLong = polylines.first.points.first.longitude;
      double maxLat = polylines.first.points.first.latitude;
      double maxLong = polylines.first.points.first.longitude;
      for (var poly in polylines) {
        for (var point in poly.points) {
          if (point.latitude < minLat) minLat = point.latitude;
          if (point.latitude > maxLat) maxLat = point.latitude;
          if (point.longitude < minLong) minLong = point.longitude;
          if (point.longitude > maxLong) maxLong = point.longitude;
        }
      }
      var c = await googleMapsController.future;
      c.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(minLat, minLong),
              northeast: LatLng(maxLat, maxLong)),
          120));
    } catch (e) {}
  }

  addDestinationMarker(LatLng destination) {
    LatLng position = LatLng(destination.latitude, destination.longitude);
    MarkerId id = const MarkerId(Constants.destination);
    Marker destinationMarker =
        Marker(markerId: id, position: position, rotation: 0, visible: true);
    markers[id] = destinationMarker;
  }

  addDriverMarker(LatLng oldPos, LatLng newDriverPos) async {
    final Uint8List markerIcon =
       await getBytesFromAsset(Constants.driverCarImage, 100);
     MarkerId id = const MarkerId(Constants.driverMarker);

    AnimationController animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false);

    Tween<double> tween = Tween(begin: 0, end: 1);

    animation = tween.animate(animationController)
      ..addListener(() {
        final v = animation!.value;

        double lng = v * newDriverPos.longitude + (1 - v) * oldPos.longitude;

        double lat = v * newDriverPos.latitude + (1 - v) * oldPos.latitude;

        LatLng newPos = LatLng(lat, lng);
        Marker newCar = Marker(
            markerId: id,
            position: newPos,
            visible: true,
            rotation: 0,
            icon: BitmapDescriptor.fromBytes(markerIcon));
        markers[id] = newCar;
        update();
      });
    animationController.forward();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getTotalDistanceAndTime(LatLng destination) async {
    Position myCurrentLocation = await getMyCurrentLocation();
    String origin =
        "${myCurrentLocation.latitude},${myCurrentLocation.longitude}";
    String destinations = "${destination.latitude},${destination.longitude}";

    Dio dio = Dio();
    var response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$origin&destinations=$destinations&key=${Constants.googleApiKey}&language=he");
    var data = response.data;
    double distance = 0.0;
    double duration = 0.0;
    List<dynamic> elements = data[Constants.rows][0][Constants.elements];
    for (var i = 0; i < elements.length; i++) {
      distance = distance + elements[i][Constants.distance][Constants.value];
      duration = duration + elements[i][Constants.duration][Constants.value];
    }
    if (distance < Constants.maxDistance) {
      arrived.value = true;
    } else {
      arrived.value = false;
    }
    distanceLeft.value =
        "${(distance / Constants.oneKm).toStringAsFixed(Constants.two)}${Constants.kilometersString}"; // in kilometers
    timeLeft.value = "${(duration / Constants.hour).toStringAsFixed(0)}${Constants.minsString}"; // in minutes
  }
}