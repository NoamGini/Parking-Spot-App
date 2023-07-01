import 'dart:ui';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  Widget data;
  Background(this.data);

  @override
  // this page has the background design
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: double.infinity,
          decoration: const BoxDecoration(

          ),
        ),
        SizedBox(
          height: double.infinity,
          child: ClipRRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container()
            ),
          ),
        ),
        data
      ],
    );
  }
}