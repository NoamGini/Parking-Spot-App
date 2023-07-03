import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:parking_spot_app/models/socketService.dart';
import 'package:parking_spot_app/models/user.dart';
import 'package:parking_spot_app/pages/resultspage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../sidebar/sidebar.dart';
import '../widget/background.dart';
import 'package:parking_spot_app/constants.dart';

Future<Position> getCurrentLocation() async {
  return await Geolocator.getCurrentPosition();
}

Future<String?> getAddressFromLatLng(double lat, double lng) async {
  final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  late Placemark place = placemarks.first;
  String? address = "${place.street!}, תל אביב";
  return address;
}

class SearchPage extends StatefulWidget {
  User user;
  bool flagKaholLavan;
  SocketService socketService;

  SearchPage(
      {super.key,
      required this.user,
      required this.flagKaholLavan,
      required this.socketService});

  static const String routeName = '/search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '122344';
  final FocusNode _focusNode = FocusNode();
  bool _searchByLocation = false;
  bool _searchByParkingLotName = false;

  List<dynamic> _placesList = [];
  List<dynamic> parkingLots = [];

  // Add a variable to hold the list of parking lot names
  List<List<String>> _parkingLotNames = [];
  String url = 'http://10.0.2.2:5000/closest_parking/';

  late GoogleMapController? _googleController;
  static CameraPosition initialPosition =
      const CameraPosition(target: LatLng(32.0751963659, 34.7750069), zoom: 16);
  Set<Marker> markers = {};
  late Position _currentPosition;

  Future<List<List<String>>> getParkingLots(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body) as List;
      parkingLots = decode;
      List<List<String>> finalList = extractFromJsonNames(parkingLots);
      // Update the state with the list of parking lot names
      setState(() {
        _parkingLotNames = finalList;
      });
      return finalList;
    } else {
      throw Exception("error from server");
    }
  }

  List<List<String>> extractFromJsonNames(List<dynamic> parkingLots) {
    List<List<String>> parkingNamesList = [];
    for (var i = 0; i < parkingLots.length; i++) {
      String parkingAddress = "";

      var jsonObject = parkingLots[i];
      String parkingName = jsonObject['Name'];
      if (jsonObject.containsKey('AhuzotCode')) {
        parkingAddress = jsonObject["Address"];
      } else {
        parkingAddress = jsonObject["address"];
      }
      parkingNamesList.add([parkingName, parkingAddress]);
    }
    return parkingNamesList;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    _controller.addListener(() {
      onChange();
    });

    getParkingLots(url);
  }

  void onChange() {
    setState(() {
      _sessionToken = uuid.v4();
    });
    if (_searchByParkingLotName) {
      getParkingLotSuggestions(_controller.text);
    } else {
      getSuggestion(_controller.text);
    }
  }

  void getParkingLotSuggestions(String input) {
    if (input.isEmpty) {
      setState(() {
        _placesList = [];
      });
      return;
    }
    final suggestions = _parkingLotNames
        .where((name) => name[0].toLowerCase().contains(input.toLowerCase()))
        .toList();
    setState(() {
      _placesList =
          suggestions.map((name) => {'description': name[0]}).toList();
    });
  }

  String getAddressFromName(String parkingName) {
    print("inGET");
    List<String> parkingInfo = _parkingLotNames.firstWhere(
      (name) => name[0].contains(parkingName),
      orElse: () => [],
    );
    print(parkingInfo);
    return parkingInfo[1];
  }

  void getSuggestion(String input) async {
    //String kPLACES_API_KEY = Constants.googleApiKey;
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=${Constants.googleApiKey}&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(data)['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void onSearchSubmitted(String input, User user) async {
    if (_searchByParkingLotName) {
      try {
        final parkingLots = await getParkingLots(url);
        final parkingLotName = parkingLots.firstWhere(
          (name) => name[0].contains(input),
          orElse: () => [],
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              address: parkingLotName[1],
              user: user,
              flagKaholLavan: widget.flagKaholLavan,
              socketService: widget.socketService,
            ),
            settings: RouteSettings(
              arguments: parkingLotName,
            ),
          ),
        );
      } catch (e) {}
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
              address: input,
              user: user,
              flagKaholLavan: widget.flagKaholLavan,
              socketService: widget.socketService),
          settings: RouteSettings(
            arguments: input,
          ),
        ),
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
    return position;
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    final showOptions = _focusNode.hasFocus;
    return Scaffold(
      drawer: SideBar(
        user: user,
        socketService: widget.socketService,
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              alignment: Alignment.topRight,
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Background(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                behavior: HitTestBehavior.opaque,
                child: GoogleMap(
                  onMapCreated: (controller) async {
                    _googleController = controller;
                    Position position = await _determinePosition();
                    _googleController!
                        .animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 16,
                      ),
                    ));
                    markers.clear();
                    markers.add(
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: LatLng(position.latitude, position.longitude),
                      ),
                    );
                    setState(() {
                      initialPosition = CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 16,
                      );
                    });
                  },
                  initialCameraPosition: initialPosition,
                  mapType: MapType.normal,
                  zoomControlsEnabled: true,
                  markers: markers,
                  myLocationEnabled: true,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'הכנס כתובת',
                              ),
                              onChanged: (value) => onChange(),
                              onSubmitted: (user) => onSearchSubmitted,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () =>
                                  onSearchSubmitted(_controller.text, user),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showOptions)
                      Column(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (_searchByLocation) {
                                setState(() {
                                  _searchByLocation = false;
                                  _controller.text = '';
                                  _placesList.clear();
                                });
                              } else {
                                setState(() {
                                  _searchByLocation = true;
                                  _searchByParkingLotName = false;
                                  _controller.text = 'מיקום נוכחי';
                                  _placesList.clear();
                                });
                                if (await Permission.location.isGranted) {
                                  final Position position =
                                      await getCurrentLocation();
                                  final String? address =
                                      await getAddressFromLatLng(
                                          position.latitude,
                                          position.longitude);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultsPage(
                                          address: address,
                                          user: user,
                                          flagKaholLavan: widget.flagKaholLavan,
                                          socketService: widget.socketService),
                                    ),
                                  );
                                } else {
                                  final status =
                                      await Permission.location.request();
                                  if (status == PermissionStatus.granted) {
                                    final Position position =
                                        await getCurrentLocation();
                                    final String? address =
                                        await getAddressFromLatLng(
                                            position.latitude,
                                            position.longitude);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultsPage(
                                            address: address,
                                            user: user,
                                            flagKaholLavan:
                                                widget.flagKaholLavan,
                                            socketService:
                                                widget.socketService),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.location_on,
                                        color: _searchByLocation
                                            ? Colors.grey
                                            : Colors.black),
                                  ),
                                  Text('מיקום נוכחי',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: _searchByLocation
                                              ? Colors.grey
                                              : Colors.black)),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_searchByParkingLotName) {
                                setState(() {
                                  _searchByParkingLotName = false;
                                  _controller.text = '';
                                  _placesList.clear();
                                });
                              } else {
                                setState(() {
                                  _searchByParkingLotName = true;
                                  _searchByLocation = false;
                                  _controller.text = '';
                                  _placesList.clear();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Icon(Icons.local_parking,
                                        color: _searchByParkingLotName
                                            ? Colors.grey
                                            : Colors.black),
                                  ),
                                  Text('שם חניון',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: _searchByParkingLotName
                                              ? Colors.grey
                                              : Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _placesList.length,
                        itemBuilder: (context, index) {
                          final String suggestion =
                              _placesList[index]['description'];
                          return Container(
                            color: Colors.white.withOpacity(0.8),
                            child: ListTile(
                              horizontalTitleGap: -25,
                              contentPadding: const EdgeInsets.only(
                                  right: -200, left: 25.0),
                              title: Text(
                                _placesList[index]['description'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              leading: _controller.text.isEmpty
                                  ? const Icon(null)
                                  : const Icon(null),
                              onTap: () {
                                if (_controller.text.isNotEmpty) {
                                  if (_searchByParkingLotName) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultsPage(
                                            flagKaholLavan:
                                                widget.flagKaholLavan,
                                            socketService: widget.socketService,
                                            address: getAddressFromName(
                                                _placesList[index]
                                                    ['description']),
                                            user: user),
                                        settings: RouteSettings(
                                          arguments: suggestion,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultsPage(
                                            flagKaholLavan:
                                                widget.flagKaholLavan,
                                            socketService: widget.socketService,
                                            address: _placesList[index]
                                                ['description'],
                                            user: user),
                                        settings: RouteSettings(
                                          arguments: suggestion,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
