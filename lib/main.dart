import 'package:flutter/material.dart';
import 'package:parking_spot_app/pages/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.title,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale(Constants.hebrew, Constants.israel),
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF262AAA),
      ),
      initialRoute: LogInPage.routeName,
      routes: {
        LogInPage.routeName : (context) => const LogInPage(),
      },
    );
  }
}