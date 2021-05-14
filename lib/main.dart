import 'package:flutter/material.dart';
import 'package:zz_assetplus_flutter_mysql/views/authenticated_home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: AuthenticatedHomeScreen(),
    );
  }
}
