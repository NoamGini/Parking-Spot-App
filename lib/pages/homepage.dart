// import 'package:flutter/material.dart';
// import 'package:parking_spot_app/pages/search_page.dart';
// import '../widget/CircularButton.dart';
// import '../widget/background.dart';
// import '../sidebar/sidebar.dart';

// // class HomePage extends StatelessWidget {
// //
// //   //static const String routeName = '/home';
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //         children: const <Widget>[
// //           SideBar(),
// //           Scaffold(
// //             body: Center(
// //               child: Text('Home Page Content',
// //                   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
// //             ),
// //           ),
// //         ],
// //     );
// //   }
// // }


// class HomePage extends StatefulWidget {

//   static const routeName = "HomePage";

//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _StartPageState();
// }

// class _StartPageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: const SideBar(),
//       body: Background(
//          Directionality(
//           textDirection: TextDirection.rtl,
//           child: Center(
//             child: startPageDesign(context),
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         leadingWidth: 400,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           alignment: Alignment.topRight,
//           icon: const Icon(Icons.menu, color: Colors.black,),
//           onPressed: () {
//             Scaffold.of(context).openEndDrawer();
//           },
//         ),
//       ),
//     );
//   }

//   Column startPageDesign(BuildContext context) {
//     return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // SizedBox(
//           //   height: 50,
//           //   width: MediaQuery.of(context).size.width - 100,
//           //   child: ElevatedButton.icon(
//           //     style: ElevatedButton.styleFrom(
//           //       backgroundColor: Colors.white,),
//           //     onPressed: () {
//           //       Scaffold.of(context).openEndDrawer();
//           //       },
//           //     icon: const Icon(Icons.menu, color: Colors.black),
//           //     label: const Text(
//           //       '',
//           //       style: TextStyle(color: Colors.white),
//           //     ),
//           //   ),
//           // ),
//           const Text("שלום!", style: TextStyle(fontSize: 60, color: Colors.black, fontWeight: FontWeight.bold),),
//           const SizedBox(height: 15,),
//           const Text("מה הפעולה שתרצו לעשות?", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w100),
//             textAlign: TextAlign.center,),
//           const SizedBox(height: 50,),
//           CircularButton("חפש חניון", 200, const Color(0xFF262AAA), (){Navigator.of(context).pushNamed(SearchPage.routeName);}),
//           const SizedBox(height: 20),
//           // todo: change to chhol lavan
//           CircularButton("חפש כחול לבן", 200, const Color(0xFF262AAA), (){Navigator.of(context).pushNamed(SearchPage.routeName);})
//         ]
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:parking_spot_app/pages/search_page.dart';
import '../widget/CircularButton.dart';
import '../widget/background.dart';
import '../sidebar/sidebar.dart';
import 'package:parking_spot_app/models/user.dart';


// class HomePage extends StatelessWidget {
//
//   //static const String routeName = '/home';
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//         children: const <Widget>[
//           SideBar(),
//           Scaffold(
//             body: Center(
//               child: Text('Home Page Content',
//                   style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
//             ),
//           ),
//         ],
//     );
//   }
// }


class HomePage extends StatefulWidget {

  static const routeName = "HomePage";
  User user;
  HomePage({super.key,
    required this.user,});

  @override
  State<HomePage> createState() => _StartPageState();
}

class _StartPageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: SideBar(user: widget.user),
      body: Background(
         Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: startPageDesign(context),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              alignment: Alignment.topRight,
              icon: const Icon(Icons.menu_rounded, color: Colors.black,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
    );
  }

  Column startPageDesign(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 50,
          //   width: MediaQuery.of(context).size.width - 100,
          //   child: ElevatedButton.icon(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.white,),
          //     onPressed: () {
          //       Scaffold.of(context).openEndDrawer();
          //       },
          //     icon: const Icon(Icons.menu, color: Colors.black),
          //     label: const Text(
          //       '',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
          const Text("שלום!", style: TextStyle(fontSize: 60, color: Colors.black, fontWeight: FontWeight.bold),),
          const SizedBox(height: 15,),
          const Text("איפה מחנים היום?", style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w100),
            textAlign: TextAlign.center,),
          const SizedBox(height: 50,),
          CircularButton("חפש חניון", 170, const Color(0xFF262AAA), (){Navigator.of(context).pushNamed(SearchPage.routeName);}),
          const SizedBox(height: 20),
          // todo: change to chhol lavan
          CircularButton("חפש כחול לבן", 170, const Color(0xFF262AAA), (){Navigator.of(context).pushNamed(SearchPage.routeName);})
        ]
    );
  }
}