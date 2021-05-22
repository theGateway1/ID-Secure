import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zz_assetplus_flutter_mysql/views/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeNamed = 'FirstPage';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => SignInScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset('icon/icon/appstore.png'),
        ),
      ),
    );
  }
}
