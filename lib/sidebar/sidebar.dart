import 'package:flutter/material.dart';
import 'package:parking_spot_app/pages/homepage.dart';
import 'package:parking_spot_app/pages/search_page.dart';
import 'menu_item.dart';
import 'package:parking_spot_app/models/user.dart';

class SideBar extends StatelessWidget {
  User user;
  SideBar({super.key,
    required this.user,});

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
              // MenuItem(
              //     title: 'Chats',
              //     icon: Icons.message_outlined,
              //     onTap: ()=> onItemPressed(context, index: 2)
              // ),
              const SizedBox(height: 40,),
              // MenuItem(
              //     title: 'Favourites',
              //     icon: Icons.favorite_outline,
              //     onTap: ()=> onItemPressed(context, index: 3)
              // ),
              const SizedBox(height: 30,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              const SizedBox(height: 30,),
              MenuItem(
                  title: 'הגדרות',
                  icon: Icons.settings,
                  onTap: ()=> onItemPressed(context, index: 4)
              ),
              const SizedBox(height: 30,),
              MenuItem(
                  title: 'התנתקות',
                  icon: Icons.logout,
                  onTap: ()=> onItemPressed(context, index: 5)
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
        break;
    }
  }

  Widget headerWidget() {
    // we can add to the database also a profile image if we want
    //const url = 'https://media.istockphoto.com/photos/learn-to-love-yourself-first-picture-id1291208214?b=1&k=20&m=1291208214&s=170667a&w=0&h=sAq9SonSuefj3d4WKy4KzJvUiLERXge9VgZO-oqKUOo=';
    return Row(
      children: [
        const SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('שלום, ${user.getName}', style: TextStyle(fontSize: 15, color: Colors.white), textDirection: TextDirection.rtl),
            SizedBox(height: 10,),
            Text(user.getEmailAddress, style: TextStyle(fontSize: 15, color: Colors.white), textDirection: TextDirection.rtl)
          ],
        ),
        const SizedBox(width: 20,),
        const SizedBox(
          width: 70,  // specify the width between the text and the icon
          child: CircleAvatar(
            radius: 35,
            child: Icon(
              Icons.perm_identity,
              color: Colors.white,
              size: 40,
            ),
            //child: backgroundImage: NetworkImage(url),
          ),
        ),
      ],
    );
  }
}
