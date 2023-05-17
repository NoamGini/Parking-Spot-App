import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_spot_app/controllers/home_controller.dart';
import 'package:parking_spot_app/controllers/navigation_controller.dart';

class DestinationBox extends StatelessWidget {
  const DestinationBox({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationMapController navigationMapController = Get.find();
    NavigationController navigationController = Get.find();
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 40,bottom: 20),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                 navigationMapController.clearDestination();
                 navigationController.directions.clear();
                 //navigationController.reset();
                  Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.back)
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(6)
              ),
              padding: const EdgeInsets.all(10),
              child: Obx(()=>Text(navigationMapController.destination.value, overflow: TextOverflow.ellipsis, maxLines: 1,)),
            ),
          ),
          const SizedBox(width: 10,),
        ],
      ),
    );
  }
}