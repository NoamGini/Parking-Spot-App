// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:parking_spot_app/parking_info.dart';
// import 'package:parking_spot_app/single_park_card.dart';
// import 'package:parking_spot_app/pages/signup_page.dart';
// import 'package:parking_spot_app/widget/AppTextField.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class SearchPage extends StatelessWidget {
//   static const routeName = "SearchPage";
//   var parkingLots=[];
//   List<String> searchHistory=[];
//   String url='http://10.0.2.2:5000/closest_parking/';
//   final searchController = TextEditingController();

//   Future<bool> getParkingLots() async{
//       try{
//       final response = await http.get(Uri.parse(url));
//       final decode = jsonDecode(response.body) as List;
//       parkingLots=decode;
//       return true;
//       }catch(err){
//         return false;
//       }
//   }

//    @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const Drawer(),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         actions: [ IconButton(
//             icon: const Icon(Icons.search),
//             padding: const EdgeInsets.only(top: 10),
//             iconSize: 35.0,
//             color: Colors.black,
//             onPressed: () {
//               //final prefs = await SharedPreferences.getInstance();
//               //final searchHistory = prefs.getStringList('searchHistory') ?? [];

//               // url+=searchController.text;
//               // bool result = await getParkingLots();
//               // if(result){
//               //   Navigator.push(
//               //           context,
//               //           MaterialPageRoute(builder: (context) => const SignUpPage()),
//               //       );
//               // }
//               // method to show the search bar
//               showSearch(
//                 context: context,
//                 // delegate to customize the search bar
//                 delegate: MySearchDelegate(searchHistory),
//               );
//             },
//         )]

//           )
//       );
//   }
// }

// class MySearchDelegate extends SearchDelegate<String>{
//   List<String> searchResults=[];
//   // List<String> searchResults =[
//   //   'Brazil','Israel','china',
//   // ];

//   MySearchDelegate(List<String> searchHistory) {
//     searchResults = List.from(searchHistory);
//   }
// @override
// Widget? buildLeading(BuildContext context) => IconButton(
//   icon: const Icon(Icons.arrow_back),
//   onPressed:() =>  Navigator.pop(context),);

// @override
// List<Widget>? buildActions(BuildContext context) => [
//   IconButton(icon: const Icon( Icons.clear),
//   onPressed: (){
//     if(query.isEmpty){
//       close(context, "");
//     }
//     else{
//     query="";
//     }
//   } )
// ];

// @override
// Widget buildResults(BuildContext context)=>Center(
//   child: Text(query,
//   style:const TextStyle(fontSize: 64,fontWeight: FontWeight.bold)),);

// @override
// Widget buildSuggestions(BuildContext context){
//   List<String> history=searchResults.where((searchResult){
//     final result =searchResult.toLowerCase();
//     final input = query.toLowerCase();
//     return result.contains(input);
//   }).toList();

//   return ListView.builder(itemCount: history.length,
//   itemBuilder: (context,index){
//     final address = history[index];
//     return ListTile(
//       title :Text(address),
//       onTap: (){
//         query= address;
//         //here to enter a navigation that gets all parkings
//         showResults(context);
//       });
//   },
//   );
// }

// @override
//   void showResults(BuildContext context) async {
//     // This method is called when the user taps a suggestion or taps the "search" button on the keyboard.
//     // You can perform the search here and return the results.
//     // In this example, we're just adding the search query to the search history.
//     print(query);
//     if (query.isNotEmpty) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       searchResults = prefs.getStringList('searchHistory') ?? [];
//       //print(searchResults);
//       print(query);
//       if (!searchResults.contains(query)) {
//         print("hey");
//         searchResults.insert(0, query);
//         prefs.setStringList('searchHistory', searchResults);
//         print('Search history: $searchResults');
//       }
//     }
//     super.showResults(context);
//   }

//   @override
//   void close(BuildContext context, String result) {
//     _saveSearchHistory(); // save the search history to shared preferences
//     super.close(context, result);
//   }

//   void _saveSearchHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('searchHistory', searchResults);
//   }

// }

// import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart' as english_words;
// import 'package:parking_spot_app/map_services.dart' as map_services;
// import 'package:parking_spot_app/auto_complete_result.dart' as autocompleter;
// import 'dart:developer' as developer;
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// // Adapted from search demo in offical flutter gallery:
// // https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/search_demo.dart
// class AppBarSearchExample extends StatefulWidget {
//     static const routeName = "AppBarSearchExample";

//   const AppBarSearchExample({super.key});

//   @override
//   _AppBarSearchExampleState createState() => _AppBarSearchExampleState();
// }

// class _AppBarSearchExampleState extends State<AppBarSearchExample> {
//   //final List<String> kEnglishWords;
//   late _MySearchDelegate _delegate;
//   //final List<String> bla=["try","bye","hi"];
//   List<String> placesdata;
//   final String _sessionToken='122344';

//   _AppBarSearchExampleState()
//   :placesdata=[],
//       //  : kEnglishWords = List.from(Set.from(english_words.all))
//       //     ..sort(
//       //       (w1, w2) => w1.toLowerCase().compareTo(w2.toLowerCase()),
//       //     ),
//         super();

//   void getSuggestion(String input) async {
//     String kPLACES_API_KEY =
//         "AIzaSyDKupYcq3t0hyHTn-YQRriH57ch-Ekw0cs"; //?Important!!!<<Place your API key Here,pass it as string>>
//     String baseURL =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     String request =
//         '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
//     var response = await http.get(Uri.parse(request));
//     var body = response.body.toString();
//     developer.log(body);
//     if (response.statusCode == 200) {
//       placesdata =  json.decode(response.body);
//       print(placesdata);
//      // return placesdata;
//     } else {
//       throw Exception('Error loading autocomplete Data');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getSuggestion("New York");
//     List<String> googlemapsSuggest= placesdata;
//     final List<String> bla=["try","bye","hi"];
//     _delegate = _MySearchDelegate(bla);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('English Words'),
//         actions: <Widget>[
//           IconButton(
//             tooltip: 'Search',
//             icon: const Icon(Icons.search),
//             onPressed: () async {
//               getSuggestion("ישראל");
//               final String? selected = await showSearch<String>(
//                 context: context,
//                 delegate: _delegate,
//               );
//               if (mounted && selected != null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('You have selected the word: $selected'),
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: Text("כאן תהיה המפה")
//       // , Scrollbar(
//       //   child: ListView.builder(
//       //     itemCount: kEnglishWords.length,
//       //     itemBuilder: (context, idx) => ListTile(
//       //       title: Text(kEnglishWords[idx]),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }

// // Defines the content of the search page in `showSearch()`.
// // SearchDelegate has a member `query` which is the query string.
// class _MySearchDelegate extends SearchDelegate<String> {
//   final List<String> _words;
//   final List<String> _history;
//   String _sessionToken = '122344';

//   _MySearchDelegate(List<String> words)

//        :_words = words,
//         _history = <String>['apple', 'hello', 'world', 'flutter'],
//         super();

//   // Leading icon in search bar.
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       tooltip: 'Back',
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         // SearchDelegate.close() can return vlaues, similar to Navigator.pop().
//         this.close(context, '');
//       },
//     );
//   }

//   // Widget of result page.
//   @override
//   Widget buildResults(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Text('You have selected the word:'),
//             GestureDetector(
//               onTap: () {
//                 // Returns this.query as result to previous screen, c.f.
//                 // `showSearch()` above.
//                 close(context, query);
//               },
//               child: Text(
//                 query,
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineMedium!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   //! funtion to retreive the autocompleter data from getplaces API of google maps
//   Future<List<String>> getSuggestion(String input) async {
//     String kPLACES_API_KEY =
//         "AIzaSyA4DV1zbLCECX_kcZAWA4vCoti9Hm156W4"; //?Important!!!<<Place your API key Here,pass it as string>>
//     String baseURL =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     String request =
//         '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
//     var response = await http.get(Uri.parse(request));
//     var body = response.body.toString();
//     developer.log(body);
//     if (response.statusCode == 200) {
//       final placesdata =  json.decode(response.body);
//       return placesdata;
//     } else {
//       throw Exception('Error loading autocomplete Data');
//     }
//   }

//   // Suggestions list while typing (this.query).
//   @override
//   Widget buildSuggestions(BuildContext context) {

//     // if (query.isEmpty){
//     //   final Iterable<String> suggestions= _history;
//     // }
//     // else{
//     //   Iterable<String> listHistory =_history.where((word) => word.startsWith(query));
//     //   Iterable<String> listwords =_words.where((word) => word.startsWith(query));
//     //   final Iterable<String> suggestions=  listHistory.(listwords);
//     // }
//     final List<String> suggestions = query.isEmpty
//         ? _history
//         : (_history.where((word) => word.startsWith(query))).toList()+ (_words.where((word) => word.startsWith(query))).toList();

//     return _SuggestionList(
//       query: query,
//       suggestions: suggestions,
//       onSelected: (String suggestion) {
//         query = suggestion;
//         _history.insert(0, suggestion);
//         showResults(context);
//       },
//     );
//   }

//   // Action buttons at the right of search bar.
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return <Widget>[
//       if (query.isEmpty)
//         IconButton(
//           tooltip: 'Voice Search',
//           icon: const Icon(Icons.mic),
//           onPressed: () {
//             query = 'TODO: implement voice input';
//           },
//         )
//       else
//         IconButton(
//           tooltip: 'Clear',
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//             query = '';
//             showSuggestions(context);
//           },
//         )
//     ];
//   }
// }

// // Suggestions list widget displayed in the search page.
// class _SuggestionList extends StatelessWidget {
//   const _SuggestionList(
//       {required this.suggestions,
//       required this.query,
//       required this.onSelected});

//   final List<String> suggestions;
//   final String query;
//   final ValueChanged<String> onSelected;

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme.titleMedium!;
//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (BuildContext context, int i) {
//         final String suggestion = suggestions[i];
//         return ListTile(
//           leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
//           // Highlight the substring that matched the query.
//           title: RichText(
//             text: TextSpan(
//               text: suggestion.substring(0, query.length),
//               style: textTheme.copyWith(fontWeight: FontWeight.bold),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: suggestion.substring(query.length),
//                   style: textTheme,
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             onSelected(suggestion);
//           },
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

// class AppBarSearchExample extends StatefulWidget{
//   static const routeName = "AppBarSearchExample";
//   @override
//   _AppBarSearchExample createState() => _AppBarSearchExample();
// }

// class _AppBarSearchExample extends State<AppBarSearchExample> {
//    String googleApikey = "AIzaSyDKupYcq3t0hyHTn-YQRriH57ch-Ekw0cs";
//   GoogleMapController? mapController; //contrller for Google map
//   CameraPosition? cameraPosition;
//   LatLng startLocation = LatLng(27.6602292, 85.308027);
//   String location = "Search Location";

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//           appBar: AppBar(
//              title: Text("Place Search Autocomplete Google Map"),
//              backgroundColor: Colors.deepPurpleAccent,
//           ),
//           body: Stack(
//             children:[

//             //   GoogleMap( //Map widget from google_maps_flutter package
//             //       zoomGesturesEnabled: true, //enable Zoom in, out on map
//             //       initialCameraPosition: CameraPosition( //innital position in map
//             //         target: startLocation, //initial position
//             //         zoom: 14.0, //initial zoom level
//             //       ),
//             //       mapType: MapType.normal, //map type
//             //       onMapCreated: (controller) { //method called when map is created
//             //         setState(() {
//             //           mapController = controller;
//             //         });
//             //       },
//             //  ),

//              //search autoconplete input
//              Positioned(  //search input bar
//                top:10,
//                child: InkWell(
//                  onTap: () async {
//                   var place = await PlacesAutocomplete.show(
//                           context: context,
//                           apiKey: googleApikey,
//                           mode: Mode.overlay,
//                           types: [],
//                           strictbounds: false,
//                           //components: [Component(Component.country, 'is')],
//                                       //google_map_webservice package
//                           onError: (err){
//                              print(err);
//                           }
//                       );

//                    if(place != null){
//                         setState(() {
//                           location = place.description.toString();
//                         });

//                        //form google_maps_webservice package
//                        final plist = GoogleMapsPlaces(apiKey:googleApikey,
//                               apiHeaders: await GoogleApiHeaders().getHeaders(),
//                                         //from google_api_headers package
//                         );
//                         String placeid = place.placeId ?? "0";
//                         final detail = await plist.getDetailsByPlaceId(placeid);
//                         final geometry = detail.result.geometry!;
//                         final lat = geometry.location.lat;
//                         final lang = geometry.location.lng;
//                         var newlatlang = LatLng(lat, lang);

//                         //move map camera to selected place with animation
//                        //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
//                    }
//                  },
//                  child:Padding(
//                    padding: EdgeInsets.all(15),
//                     child: Card(
//                        child: Container(
//                          padding: EdgeInsets.all(0),
//                          width: MediaQuery.of(context).size.width - 40,
//                          child: ListTile(
//                             title:Text(location, style: TextStyle(fontSize: 18),),
//                             trailing: Icon(Icons.search),
//                             dense: true,
//                          )
//                        ),
//                     ),
//                  )
//                )
//              )

//             ]
//           )
//        );
//   }
// }
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:parking_spot_app/pages/resultspage.dart';
import 'package:parking_spot_app/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:parking_spot_app/parking_info.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../sidebar/sidebar.dart';
import '../widget/background.dart';

Future<Position> getCurrentLocation() async {
  return await Geolocator.getCurrentPosition();
}

Future<String?> getAddressFromLatLng(double lat, double lng) async {
  final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  late Placemark place = placemarks.first;
  return place.name;
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const String routeName = '/search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '122344';
  List<String> _history = [];
  final FocusNode _focusNode = FocusNode();
  bool _searchByLocation = false;
  bool _searchByParkingLotName = false;

  //List<Map<String, dynamic>> _placesList = [];
  List<dynamic> _placesList = [];
  List<dynamic> parkingLots = [];

  // Add a variable to hold the list of parking lot names
  List<String> _parkingLotNames = [];
  String url = 'http://10.0.2.2:5000/closest_parking/';

  late GoogleMapController? _googleController;
  static CameraPosition initialPosition =
      const CameraPosition(target: LatLng(32.0751963659, 34.7750069), zoom: 16);
  Set<Marker> markers = {};
  late Position _currentPosition;

  // void _getCurrentLocation (){
  //   lctn.Location location = lctn.Location();
  //
  //   location.getLocation().then((location) {
  //     currentLocation = location;
  //   },);
  //
  // }

  // void _addMarker(LatLng latLng) {
  //   final marker = Marker(
  //     markerId: MarkerId('user-location'),
  //     position: latLng,
  //   );
  //   setState(() {
  //     _markers.add(marker);
  //   });
  // }

  Future<List<String>> getParkingLots(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body) as List;
      parkingLots = decode;
      List<String> finalList = extractFromJsonNames(parkingLots);
      // Update the state with the list of parking lot names
      setState(() {
        _parkingLotNames = finalList;
      });
      return finalList;
    } else {
      throw Exception("error from server");
    }
  }

  List<String> extractFromJsonNames(List<dynamic> parkingLots) {
    List<String> parkingNamesList = [];
    print("extracting");
    for (var i = 0; i < parkingLots.length; i++) {
      var jsonObject = parkingLots[i];
      String parkingName = jsonObject["Name"];
      parkingNamesList.add(parkingName);
    }
    print(parkingNamesList);
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
    // this what i need to add so the list will change to the parking lots list
    getParkingLots(url); // fetch the list of parking lots on initialization
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
        .where((name) => name.toLowerCase().contains(input.toLowerCase()))
        .toList();
    setState(() {
      _placesList = suggestions.map((name) => {'description': name}).toList();
    });
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyDKupYcq3t0hyHTn-YQRriH57ch-Ekw0cs";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    // developer.log(body);
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(data)['predictions'];
      });
      //return placesdata;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void addToHistory(String address) {
    _history.insert(0, address);

    //showResults(context);
  }

  void onSearchSubmitted(String input) async {
    if (input.isNotEmpty) {
      addToHistory(input);
    }
    if (_searchByParkingLotName) {
      try {
        final parkingLots = await getParkingLots(url);
        final parkingLotName = parkingLots.firstWhere(
          (name) => name.contains(input),
          orElse: () => '',
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(address: parkingLotName),
            settings: RouteSettings(
              arguments: parkingLotName,
            ),
          ),
        );
      } catch (e) {
        print('Failed to get parking lots: $e');
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(address: input),
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
    print(position);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    final showOptions = _focusNode.hasFocus;
    return Scaffold(
      drawer: const SideBar(),
      extendBodyBehindAppBar: false,
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
                //padding: const EdgeInsets.only(top: 105),
                child: Column(
                  children: [
                    Container(
                      //padding: const EdgeInsets.only(left: 10, right: 20),
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'הכנס כתובת',
                              ),
                              onChanged: (value) => onChange(),
                              // onSubmitted: (input) {
                              //   // Only save the input when the user hits the Enter key
                              //   if (input.isNotEmpty) {
                              //     addToHistory(input);
                              //   }
                              // },
                              onSubmitted: onSearchSubmitted,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () =>
                                  onSearchSubmitted(_controller.text),
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
                          // Add a GestureDetector widget to handle the tap event on the location search option
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
                                      builder: (context) =>
                                          ResultsPage(address: address),
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
                                        builder: (context) =>
                                            ResultsPage(address: address),
                                      ),
                                    );
                                  } else {
                                    // Handle permission denied
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0), // Adjust the padding value as needed
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
                          // Add a GestureDetector widget to handle the tap event on the parking lot search option
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
                              padding: EdgeInsets.all(8),
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0), // Adjust the padding value as needed
                                    child: Icon(Icons.local_parking,
                                        color: _searchByParkingLotName ? Colors.grey : Colors.black),
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
                      // child: Column(
                      //   children:[
                      //     const Divider(thickness: 1, height: 10, color: Colors.black,),
                          child: ListView.builder(
                            itemCount: _placesList.length,
                            itemBuilder: (context, index) {
                              final String suggestion =
                              _placesList[index]['description'];
                              return Container(
                                color: Colors.white.withOpacity(0.8),
                                child: ListTile(
                                  horizontalTitleGap: -25,
                                  contentPadding: const EdgeInsets.only(right: -200, left: 25.0),
                                  title: Text(_placesList[index]['description'], style: TextStyle(fontSize: 16,),),
                                  leading: _controller.text.isEmpty
                                      ? const Icon(Icons.history)
                                      : const Icon(null),
                                  onTap: () {
                                    if (_controller.text.isNotEmpty) {
                                      addToHistory(suggestion);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResultsPage(
                                              address: _placesList[index]
                                              ['description']),
                                          settings: RouteSettings(
                                            arguments: suggestion,
                                          ),
                                        ),
                                      );
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
