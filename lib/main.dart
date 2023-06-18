import 'package:flutter/material.dart';
import 'package:parking_spot_app/pages/homepage.dart';
import 'package:parking_spot_app/pages/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parking_spot_app/pages/resultspage.dart';
import 'package:parking_spot_app/pages/search_kahol_lavan.dart';
import 'package:parking_spot_app/pages/signup_page.dart';
import 'package:parking_spot_app/models/parking_info.dart';
import 'package:parking_spot_app/widget/single_park_card.dart';
import 'package:parking_spot_app/pages/search_page.dart';
import 'package:parking_spot_app/pages/navigationpage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/user.dart';

//import 'package:login_signup_page/start_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user =User ("amit", "amit@gmail.com","12345678",null,0);
    return MaterialApp(
      title: 'login_signup',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("he", "IS"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      theme: ThemeData(
        primaryColor: Color(0xFF262AAA),
      ),
      initialRoute: LogInPage.routeName,
      routes: {
        //StartPage.routeName : (context) => const StartPage(),
        
        //CurrentLocationScreen.routeName: (context) => const CurrentLocationScreen(),
      // SearchPage.routeName: (context) =>  SearchPage(user: user,flagKaholLavan: false),
          // NavigationPage.routeName : (context) =>  NavigationPage(
          //  destinationAddress:"לילינבלום 4, תל אביב",destinationCoordinates: LatLng(32.0617856,34.7675207), user: user),

        HomePage.routeName: (context) =>  HomePage(user: user,),
       // SearchKaholLavan.routeName : (context) => SearchKaholLavan(user: user, flagKaholLavan: true),

        //SingleParkCard.routeName : (context) => SingleParkCard(),
        LogInPage.routeName : (context) => const LogInPage(),
        SignUpPage.routeName : (context) => const SignUpPage()
      },
    );
  }
}