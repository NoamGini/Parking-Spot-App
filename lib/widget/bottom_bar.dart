import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_spot_app/controllers/home_controller.dart';
import 'package:parking_spot_app/controllers/navigation_controller.dart';
import 'package:parking_spot_app/constants.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationMapController navigationMapController = Get.find();
    NavigationController navigationController = Get.find();
  
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    navigationMapController.distanceLeft.value,
                    style: TextStyle(color: Colors.green[900]),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "(${navigationMapController.timeLeft.value})",
                    style: const TextStyle(color: Colors.black38),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (navigationMapController.mapStatus.value == Constants.route) {
                    navigationController.navigateToDestination();
                  } else {
                    navigationController.stopNavigation();
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: navigationMapController.mapStatus.value == Constants.route
                          ? Colors.blueAccent
                          : Colors.redAccent,
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                      navigationMapController.mapStatus.value == Constants.route
                          ? "התחל ניווט"
                          : "הפסק ניווט",
                      style: const TextStyle(color: Colors.white)),
                ),
              )
            ],
          )),
    );
  }
}