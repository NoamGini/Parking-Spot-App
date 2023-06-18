import 'package:flutter/material.dart';
import 'package:parking_spot_app/pages/homepage.dart';
import 'package:parking_spot_app/pages/login_page.dart';
import 'package:parking_spot_app/pages/search_kahol_lavan.dart';
import 'package:parking_spot_app/pages/search_page.dart';
import '../models/socketService.dart';
import 'menu_item.dart';
import 'package:parking_spot_app/models/user.dart';

class SideBar extends StatelessWidget {
  User user;
  SocketService socketService;
  SideBar({super.key,
    required this.user, required this.socketService 
    });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color(0xFF262AAA),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
          child: Column(
            children: [
              headerWidget(),
              const SizedBox(height: 40,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              const SizedBox(height: 40,),
              MenuItem(
                title: 'עמוד הבית',
                icon: Icons.home,
                onTap: ()=> onItemPressed(context, index: 0),
              ),
              const SizedBox(height: 30,),
              MenuItem(
                  title: 'חיפוש חניון',
                  icon: Icons.local_parking_rounded,
                  onTap: ()=> onItemPressed(context, index: 1)
              ),
              const SizedBox(height: 40,),
              MenuItem(
                  title: 'חיפוש כחול לבן',
                  icon: Icons.local_parking_rounded,
                  onTap: ()=> onItemPressed(context, index: 2)
              ),
              const SizedBox(height: 40,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              const SizedBox(height: 100,),
              MenuItem(
                  title: 'התנתקות',
                  icon: Icons.logout,
                  onTap: ()=> onItemPressed(context, index: 3)
              ),

            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}){
    Navigator.pop(context);

    switch(index){
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage(user: user)));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(user:user, flagKaholLavan: false,socketService: socketService)));
        break;
      case 2:
       Navigator.push(context, MaterialPageRoute(builder: (context) => SearchKaholLavan(user:user, flagKaholLavan: true, socketService: socketService,)));
      break;
      case 3:
       Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInPage()));
      break;

    }
  }

  Widget headerWidget() {
   return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        const SizedBox(width: 20,),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('שלום,  ${user.getName}', style: TextStyle(fontSize: 20, color: Colors.white), textDirection: TextDirection.rtl),
              const SizedBox(height: 15,),
              Text(user.getEmailAddress, style: TextStyle(fontSize: 15, color: Colors.white), textDirection: TextDirection.rtl),
            ],
          ),
        ),
        const SizedBox(width: 30,),
        const SizedBox(
          width: 70,
          child: CircleAvatar(
            radius: 35,
            child: Icon(
              Icons.perm_identity,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 30,),
    Row (
      children: [
        const SizedBox(width: 20,),
        Text('נקודות שנצברו: ${user.points}', style: TextStyle(fontSize: 20, color: Colors.white), textDirection: TextDirection.rtl),
      ],
    ),
  ],
);

  }
}
