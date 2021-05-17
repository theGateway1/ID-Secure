import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:zz_assetplus_flutter_mysql/constants/strings.dart';
import 'package:zz_assetplus_flutter_mysql/views/authenticated_home_screen.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool signin = true;
  var dio = Dio();
  TextEditingController namectrl, emailctrl, passctrl;

  bool processing = false;

  _showSnackBar(BuildContext context, message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namectrl = new TextEditingController();
    emailctrl = new TextEditingController();
    passctrl = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 200,
                  color: Colors.blue,
                ),
                boxUi(),
              ],
            ),
          )),
    );
  }

  void changeState() {
    if (signin) {
      setState(() {
        signin = false;
      });
    } else
      setState(() {
        signin = true;
      });
  }

  void registerUser() async {
    setState(() {
      processing = true;
    });

    print(emailctrl.text.toString());
    print("is the email");

    var data = {
      "email": emailctrl.text.toString(),
      "name": namectrl.text.toString(),
      "pass": passctrl.text.toString(),
    };

    var reso = await http.post(Uri.parse(SIGN_UP_URL), body: data);
    String res = reso.body.toString();
    // String res = json.decode(reso.data);

    if (res.toString().trim() == "account already exists") {
      _showSnackBar(context, "Account already Exists - Please Sign In");
    } else if (res.toString().trim().contains("true")) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AuthenticatedHomeScreen()),
          (route) => false);
    } else {
      print(res.toString());
      _showSnackBar(context, "Some Error Occured!");
    }

    setState(() {
      processing = false;
    });
  }

  void userSignIn() async {
    setState(() {
      processing = true;
    });

    var data = {
      "email": emailctrl.text,
      "pass": passctrl.text,
    };

    var reso = await http.post(Uri.parse(SIGN_IN_URL), body: data);
    String res = reso.body.toString();
    // String res = json.decode(reso.data);

    if (res.toString().trim().contains("Dont have an account")) {
      _showSnackBar(context, "Account doesn't exist, Create a new account");
    } else {
      if (res.toString().trim() == "true") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => AuthenticatedHomeScreen()),
            (route) => false);
      }
      if (res.toString().trim().contains("false")) {
        _showSnackBar(context, "Wrong Credentials");
      } else {
        print((res.toString()));
      }
    }

    setState(() {
      processing = false;
    });
  }

  Widget boxUi() {
    return Container(
      padding: EdgeInsets.only(top: 70),
      child: Card(
        elevation: 10.0,
        color: Colors.grey[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: () => changeState(),
                    child: Text(
                      'SIGN IN',
                      style: GoogleFonts.varelaRound(
                        color: signin == true ? Colors.blue : Colors.grey,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => changeState(),
                    child: Text(
                      'SIGN UP',
                      style: GoogleFonts.varelaRound(
                        color: signin != true ? Colors.blue : Colors.grey,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              signin == true ? signInUi() : signUpUi(),
            ],
          ),
        ),
      ),
    );
  }

  Widget signInUi() {
    return Column(
      children: <Widget>[
        TextField(
          controller: emailctrl,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_box,
              ),
              hintText: 'email'),
        ),
        TextField(
          controller: passctrl,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
              ),
              hintText: 'pass'),
        ),
        SizedBox(
          height: 10.0,
        ),
        MaterialButton(
          onPressed: () => userSignIn(),
          child: processing == false
              ? Text(
                  'Sign In',
                  style: GoogleFonts.varelaRound(
                      fontSize: 18.0, color: Colors.blue),
                )
              : CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget signUpUi() {
    return Column(
      children: <Widget>[
        TextField(
          controller: namectrl,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_box,
              ),
              hintText: 'name'),
        ),
        TextField(
          controller: emailctrl,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_box,
              ),
              hintText: 'email'),
        ),
        TextField(
          controller: passctrl,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
              ),
              hintText: 'pass'),
        ),
        SizedBox(
          height: 10.0,
        ),
        MaterialButton(
          onPressed: () => registerUser(),
          child: processing == false
              ? Text(
                  'Sign Up',
                  style: GoogleFonts.varelaRound(
                      fontSize: 18.0, color: Colors.blue),
                )
              : CircularProgressIndicator(),
        ),
      ],
    );
  }
}
