import 'package:flutter/material.dart';

import '../sidebar/sidebar.dart';

class SearchPage extends StatelessWidget {

  static const String routeName = '/search';

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      endDrawer: SideBar(),
      body: Center(
        child: Text('Search Page Content',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28)),
      ),
    );
  }
}
