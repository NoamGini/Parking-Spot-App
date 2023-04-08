import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../sidebar/menu_item.dart';
import 'package:rxdart/rxdart.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar>{
  late AnimationController _animationController;
  late StreamController<bool> isSideBarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSideBarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSideBarOpenedStreamController.stream;
    isSidebarOpenedSink = isSideBarOpenedStreamController.sink;

  }

  @override
  void dispose() {
    _animationController.dispose();
    isSideBarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed(){
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSidebarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          right: isSidebarOpenedAsync.data ?? false ? 0 : -screenWidth,
          left: isSidebarOpenedAsync.data ?? false ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Align(
                  alignment: const Alignment(0, -0.9),
                  child: GestureDetector(
                    onTap: (){
                      onIconPressed();
                    },
                    child: ClipPath(
                      clipper: CustomMenuClipper(),
                      child: Container(
                        width: 35,
                        height: 110,
                        color: const Color(0xFF262AAA),
                        alignment: Alignment.centerRight,
                        child: AnimatedIcon(
                          progress: _animationController.view,
                          icon: AnimatedIcons.menu_close,
                          color: Colors.lightBlueAccent,
                          size: 25,
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color(0xFF262AAA),
                  child: Column(
                    children: const <Widget>[
                      SizedBox(height: 100,),
                      ListTile(
                        title: Text("שלום, משתמש",
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        subtitle: Text("user123@gmail.com",
                        style: TextStyle(color: Colors.white,
                            fontSize: 20,),
                          textDirection: TextDirection.rtl,
                        ),

                        trailing: CircleAvatar(
                          radius: 40,
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Color(0xA1FFFFFF),
                        indent: 32,
                        endIndent: 32,
                      ),
                      MenuItem(
                        title: 'עמוד הבית',
                        icon: Icons.home,

                      ),
                      MenuItem(
                        title:'חיפוש',
                        icon: Icons.search,
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: Color(0xA1FFFFFF),
                        indent: 32,
                        endIndent: 32,
                      ),
                      MenuItem(
                        title:'הגדרות',
                        icon: Icons.settings,
                      ),
                      MenuItem(
                        title:'התנתקות',
                        icon: Icons.logout,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(width, 0);
    path.quadraticBezierTo(width, 8, width-10, 16);
    path.quadraticBezierTo(1, height/2 - 20, 0, height/2);
    path.quadraticBezierTo(-1, height/2 + 20, width-10, height-16);
    path.quadraticBezierTo(width, height-8, width, height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
  
}
