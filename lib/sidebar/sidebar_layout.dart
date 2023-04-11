import 'package:flutter/material.dart';
import 'sidebar.dart';

class SideBarLayout extends StatelessWidget {
  const SideBarLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const SideBar(),
        body: Builder(
            builder: (context) {
              return Center(
                child: SizedBox(
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 100,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.open_in_new, color: Colors.white),
                    label: const Text(
                      'Open Navigation Drawer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}
