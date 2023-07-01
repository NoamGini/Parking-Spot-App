import 'package:flutter/material.dart';
import 'package:parking_spot_app/models/parking_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ParkingFilterWidget extends StatefulWidget {
  final String? address;
  final Function(Future<List<ParkingInfo>>, bool) updateParkingLots;
  final Function(List<dynamic>) extract;
  ParkingFilterWidget({required this.address, required this.updateParkingLots, required this.extract});

  @override
  _ParkingFilterWidgetState createState() => _ParkingFilterWidgetState();
}

class _ParkingFilterWidgetState extends State<ParkingFilterWidget> {
  // define the initial state of the filters
  String filterByCompany = 'reset';
  String filterByStatus = 'reset';
  bool filterByWalkingTime = false;
  String walkingTime ='reset';
  String filterByWalkingDistance = 'reset';
  Future<List<ParkingInfo>> listByCompany=  Future.value([]);
  Future<List<ParkingInfo>> listByStatus=Future.value([]);
  Future<List<ParkingInfo>> listByTime=Future.value([]);
  Future<List<ParkingInfo>> listByDistance=Future.value([]);
  String basicUrl='http://10.0.2.2:5000/';

String getUrl(String filter,String newAddress){
  if (filter=='distance'){
    String distance = 'closest_parking/';
    return basicUrl+distance+newAddress+'/';
  }
  if(filter=='company'){
    String company= 'closest_parking_company/';
    return basicUrl+company+newAddress+'/';
  }
   if(filter=='status'){
    String status= 'closest_parking_status/';
    return basicUrl+status+newAddress+'/';
  }
  if(filter=='duration'){
    String duration= 'closest_parking_duration/';
    return basicUrl+duration+newAddress+'/';
  }
  else{
    return 'hi';
  }
}

void resetFilters(String pressedFilter,Map<String, dynamic> filterState) {
  List<String> filtersNameList=["filterByCompany","filterByStatus","filterByWalkingDistance","filterByWalkingTime"];
  if (pressedFilter== "reset all"){
    filterByCompany='reset';
    filterByStatus='reset';
    filterByWalkingDistance='reset';
    filterByWalkingTime=false;
    walkingTime='reset';
  }
  
  for (String filterName in filtersNameList) {
    if (filterName != pressedFilter && filterName != "filterByWalkingTime") {
      filterState[filterName][0] ='reset';
    }
    if (filterName != pressedFilter && filterName == "filterByWalkingTime"){
     filterState[filterName][0] =false;
     filterByWalkingTime=false;
     walkingTime='reset';
    }
  }
  listByCompany= Future.value([]);
  listByStatus=Future.value([]);
  listByTime=Future.value([]);
  listByDistance=Future.value([]);
}


Future<List<ParkingInfo>> filterCombo(Map<String, dynamic> filtersNameList,String currentFilter ) async {
  List<Future<List<ParkingInfo>>> comboList=[];
    filtersNameList.forEach((key, value) {
      if(key != "filterByWalkingTime" && value[0] != "reset"){   
        comboList.add(value[1]);
      }
      if(key == "filterByWalkingTime" && value [0]!= false){
        comboList.add(value[1]);

      }
    });
   if (comboList.length ==1 || comboList.isEmpty){
    if (comboList.isEmpty){
      return filtersNameList[currentFilter][1];
    }
    else{
      return comboList[0];
    }
   }

  Future<List<ParkingInfo>> shortestList = comboList.reduce((a, b) async {
    int aLength = (await a).length;
    int bLength = (await b).length;
    return aLength < bLength ? a : b;
  });

  List<ParkingInfo> commonObjects = [];
  List<ParkingInfo> shortestListValue = await shortestList;

  // Iterate through each object in the shortest list
  for (int i = 0; i < shortestListValue.length; i++) {
    ParkingInfo currentObject = shortestListValue[i];

    // Check if the current object appears in all other lists
    bool foundInAll = true;
    for (int j = 0; j < comboList.length; j++) {
      if (comboList[j] == shortestList) {
        continue;
      }

      bool foundInCurrentList = false;
      List<ParkingInfo> comboListJ = await comboList[j];
      print("after await");
      for (int k = 0; k < comboListJ.length; k++) {
        print("i have an element");
        print(currentObject.getParkingName.toString());
        print(comboListJ[k].getParkingName);
        if (currentObject.getParkingName == comboListJ[k].getParkingName) {
          foundInCurrentList = true;
          break;
        }
      }

      if (!foundInCurrentList) {
        foundInAll = false;
        break;
      }
    }

    // Add the current object to the common objects list if it appears in all lists
    if (foundInAll) {
      commonObjects.add(currentObject);
    }
  }
    return Future.value(commonObjects);
    
}


Future<List<ParkingInfo>> getParkingByFilter(String filter, String? value) async{
    String addressUrl= getUrl(filter,widget.address!);
    String urlFilter="";
    if( value != null){
    urlFilter = addressUrl+value;
    }
    List<dynamic> parkingLots=[];

    final response = await http.get(Uri.parse(urlFilter));
    if (response.statusCode ==200){
      final decode = jsonDecode(response.body) as List;
      parkingLots = decode;
      List<ParkingInfo> finalList= widget.extract(parkingLots);
      return finalList;
    }
    else{
      throw Exception("error from server");
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> filterVariables = {
    'filterByCompany': [filterByCompany,listByCompany],
    'filterByStatus': [filterByStatus,listByStatus],
    'filterByWalkingTime': [filterByWalkingTime,listByTime],
    'filterByWalkingDistance': [filterByWalkingDistance,listByDistance]
  };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: 37,
                padding: EdgeInsets.only(right: 6.0),
                decoration:BoxDecoration(
                  color:  Colors.grey[200],
                  borderRadius: BorderRadius.circular(5) ,
                  border: Border.all(width:2, color: Color.fromARGB(255, 16, 19, 116)),
                    ),
              child: DropdownButton<String>(
                value: walkingTime,
                hint: const Text('זמן הליכה',),
               style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.grey[200], // Change the background color of the dropdown menu
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                underline: Container( // Remove the underline
                  height: 0,
                  color: Colors.transparent,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value == "reset"){
                    filterByWalkingTime= false;
                    }
                    else{
                    filterByWalkingTime= true;
                    }
                    walkingTime = value!;
                    filterVariables["filterByWalkingTime"][0]=filterByWalkingTime;
                  });
                  Future<List<ParkingInfo>> newList= getParkingByFilter('duration',walkingTime);
                  listByTime=newList;
                  filterVariables["filterByWalkingTime"][1]=newList;               
                  Future<List<ParkingInfo>> combinationList= filterCombo(filterVariables,"filterByWalkingTime");
                  widget.updateParkingLots(combinationList,filterByWalkingTime);
                },
                items: const [
                  DropdownMenuItem(
                    value: 'reset',
                    child: Text('זמן הליכה'),
                  ),
                  DropdownMenuItem(
                    value: '5 mins',
                    child: Text('5 דקות'),
                  ),
                  DropdownMenuItem(
                    value: '10 mins',
                    child: Text('10 דקות'),
                  ),
                  DropdownMenuItem(
                    value: '20 mins',
                    child: Text('20 דקות'),
                  ),
                  DropdownMenuItem(
                    value: '30 mins',
                    child: Text('30 דקות'),
                  ),
                ],
              )
              ),
              const SizedBox(width: 10),
              Container(
                height: 37,               
               padding: const EdgeInsets.only(right: 6.0),
              decoration:BoxDecoration(
                 color:  Colors.grey[200],
                  borderRadius: BorderRadius.circular(5) ,
                  border: Border.all(width:2, color: const Color.fromARGB(255, 16, 19, 116)),
                    ),
              child: DropdownButton<String>(
                value: filterByWalkingDistance,
                hint: const Text('עד מרחק'),
                style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.grey[200], // Change the background color of the dropdown menu
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                underline: Container( // Remove the underline
                  height: 0,
                  color: Colors.transparent,
                ),
                onChanged: (value) {
                  setState(() {
                    filterByWalkingDistance = value!;
                    filterVariables["filterByWalkingDistance"][0]=filterByWalkingDistance;
                  });
                  Future<List<ParkingInfo>> newList= getParkingByFilter('distance',filterByWalkingDistance);
                  listByDistance= newList;
                  filterVariables["filterByWalkingDistance"][1]=newList;
                  Future<List<ParkingInfo>> combinationList= filterCombo(filterVariables,"filterByWalkingDistance");
                  widget.updateParkingLots(combinationList,filterByWalkingTime);
                },
                items: const [
                  DropdownMenuItem(
                    value: 'reset',
                    child: Text('עד מרחק'),
                  ),
                  DropdownMenuItem(
                    value: '500',
                    child: Text(' 500 מטר'),
                  ),
                  DropdownMenuItem(
                    value: '1000',
                    child: Text(' 1 ק"מ'),
                  ),
                  DropdownMenuItem(
                    value: '2000',
                    child: Text(' 2 ק"מ'),
                  ),
                  DropdownMenuItem(
                    value: '5000',
                    child: Text(' 5 ק"מ'),
                  ),
                ],
              )
              ),
              const SizedBox(width: 10),
              Container(
              height: 37,
              padding: const EdgeInsets.only(right: 6.0),
              decoration:BoxDecoration(
                 color:  Colors.grey[200],
                  borderRadius: BorderRadius.circular(5) ,
                  border: Border.all(width:2, color: const Color.fromARGB(255, 16, 19, 116)),
                    ),
              child: DropdownButton<String>(
                value: filterByCompany,
                hint: const Text('חברת חניונים',),
                style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.grey[200], // Change the background color of the dropdown menu
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                underline: Container( // Remove the underline
                  height: 0,
                  color: Colors.transparent,
                ),
                onChanged: (value) {
                  setState(() {
                    filterByCompany = value!;
                    filterVariables["filterByCompany"][0]=filterByCompany;
                  });
                  Future<List<ParkingInfo>> newList= getParkingByFilter('company',filterByCompany);
                  listByCompany= newList;
                  filterVariables["filterByCompany"][1]=newList;
                  Future<List<ParkingInfo>> combinationList= filterCombo(filterVariables,"filterByCompany");
                  widget.updateParkingLots(combinationList,filterByWalkingTime);
                },
                items: const [
                  DropdownMenuItem(
                    value: 'reset',
                    child: Text('חברת חניונים'),
                  ),
                  DropdownMenuItem(
                    value: 'אחוזת החוף',
                    child: Text('אחוזת החוף'),
                  ),
                  DropdownMenuItem(
                    value: 'סנטרל פארק',
                    child: Text('סנטרל פארק'),
                  )
                ],
              )
              ),
              const SizedBox(width: 10),
               Container(
              
              height: 37,
              padding: const EdgeInsets.only(right: 6.0),
              decoration:BoxDecoration(
                  color:  Colors.grey[200],
                  borderRadius: BorderRadius.circular(5) ,
                  border: Border.all(width:2, color: const Color.fromARGB(255, 16, 19, 116)),
                    ),
              
              child: DropdownButton<String>(
                value: filterByStatus,
                hint: const Text('סטטוס',),
                style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.grey[200], // Change the background color of the dropdown menu
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black), // Change the color of the dropdown icon
                underline: Container( // Remove the underline
                  height: 0,
                  color: Colors.transparent,
                ),
                onChanged: (value) {
                  setState(() {
                    filterByStatus = value!;
                    filterVariables["filterByStatus"][0]=filterByStatus;
                  });
                  Future<List<ParkingInfo>> newList= getParkingByFilter('status',filterByStatus);
                  listByStatus= newList;
                  filterVariables["filterByStatus"][1]=newList;
                  Future<List<ParkingInfo>> combinationList= filterCombo(filterVariables,"filterByStatus");
                  widget.updateParkingLots(combinationList,filterByWalkingTime);
                },
                items: const [
                  DropdownMenuItem(
                    value: 'reset',
                    child: Text('סטטוס'),
                  ),
                  DropdownMenuItem(
                    value: 'פנוי',
                    child: Text('פנוי'),
                  ),
                  DropdownMenuItem(
                    value: 'מעט',
                    child: Text('מעט'),
                  ),
                  DropdownMenuItem(
                    value: 'מלא',
                    child: Text('מלא'),
                  )
                ],
              )
              ),
            ],
          ),
        ),
        
        Center(
          child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 15,),
            primary: Colors.grey[200],
            side: const BorderSide(color: Color.fromARGB(255, 16, 19, 116), width: 2), // Add a border color
          ),
            onPressed:(){ resetFilters("reset all",filterVariables);
            Future<List<ParkingInfo>> newList= getParkingByFilter('company','reset');
                  widget.updateParkingLots(newList,false);},
            child: const Text('איפוס',  style: TextStyle(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}
