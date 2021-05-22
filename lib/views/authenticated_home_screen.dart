import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter/services.dart';
// import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// import 'package:zz_assetplus_flutter_mysql/views/location.dart';
import 'package:zz_assetplus_flutter_mysql/views/view_images.dart';
import '../constants/strings.dart';
import 'package:exif/exif.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:intl/intl.dart';

class AuthenticatedHomeScreen extends StatefulWidget {
  @override
  _AuthenticatedHomeScreenState createState() =>
      _AuthenticatedHomeScreenState();
}

class _AuthenticatedHomeScreenState extends State<AuthenticatedHomeScreen> {
  Position thisLoc;
  bool _imgHasLocation = false;
  String imagePathForCheckGps = "null";
  File image;
  final picker = ImagePicker();
  GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(); //Key to get context to show snackbar;
  bool imageUploaded = false;
  Geolocator _geolocator = Geolocator();
  static int count = 0;

  // Future<GeoFirePoint> _checkGPSData(String imageForCheckGps) async {
  //   print('runs check');
  //   Map<String, IfdTag> imgTags =
  //       await readExifFromBytes(File(imageForCheckGps).readAsBytesSync());
  //   print('this ran');
  //   if (imgTags.containsKey('GPS GPSLongitude')) {
  //     _imgHasLocation = true;
  //     thisLoc = exifGPSToGeoFirePoint(imgTags);
  //     return thisLoc;
  //   } else {
  //     print('Nope, no location');
  //   }
  // }

  // GeoFirePoint exifGPSToGeoFirePoint(Map<String, IfdTag> tags) {
  //   print('runs GeoFire');
  //   final latitudeValue = tags['GPS GPSLatitude']
  //       .values
  //       .map<double>(
  //           (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
  //       .toList();
  //   final latitudeSignal = tags['GPS GPSLatitudeRef'].printable;

  //   final longitudeValue = tags['GPS GPSLongitude']
  //       .values
  //       .map<double>(
  //           (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
  //       .toList();
  //   final longitudeSignal = tags['GPS GPSLongitudeRef'].printable;

  //   double latitude =
  //       latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

  //   double longitude = longitudeValue[0] +
  //       (longitudeValue[1] / 60) +
  //       (longitudeValue[2] / 3600);

  //   if (latitudeSignal == 'S') latitude = -latitude;
  //   if (longitudeSignal == 'W') longitude = -longitude;

  //   return GeoFirePoint(latitude, longitude);
  // }

  _showSnackBar(BuildContext context, String message) {
    print('WORKS');
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<PickedFile> _clickImg() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        _saveImage();
      });
      // Navigator.of(context).pop();
    }
  }

  // _pickImg() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       image = File(pickedFile.path);
  //       _saveImage();
  //     });
  //     // Navigator.of(context).pop();
  //   }
  // }

  Future<bool> getLocPermission() async {
    await Geolocator.requestPermission();
    count++;
    LocationPermission status = await Geolocator.checkPermission();
    print(status);
    if (status == LocationPermission.always) {
      thisLoc = await Geolocator.getCurrentPosition();
      return true;
    } else if ((status == LocationPermission.denied ||
            status == LocationPermission.deniedForever) &&
        count < 2) {
      getLocPermission();
    } else {
      print("returning false");
      return false;
    }
  }

  _saveImage() async {
    imageUploaded = false;

    print(
        "The date is ${DateFormat.yMMMd().format(DateTime.now()).toString()}");
    // imagePathForCheckGps =
    //     await FlutterAbsolutePath.getAbsolutePath(image.path);
    // thisLoc = await _checkGPSData(imagePathForCheckGps);

    //
    _imgHasLocation = await getLocPermission();
    print("$_imgHasLocation -> THIS IS FINAL VALUE");
    if (_imgHasLocation == null) {
      _imgHasLocation = await getLocPermission();
    }

    var request = http.MultipartRequest('POST', Uri.parse(UPLOAD_URL));

    request.fields["latitude"] =
        _imgHasLocation == false ? "Not Found" : thisLoc.latitude.toString();
    request.fields["longitude"] =
        _imgHasLocation == false ? "Not Found" : thisLoc.longitude.toString();
    print("THIS ALREADY DONE");
    request.fields["date"] =
        "${DateFormat.yMMMd().format(DateTime.now()).toString()}";
    request.fields["time"] = DateFormat.Hm().format(DateTime.now()).toString();

    var pic = await http.MultipartFile.fromPath("image", image.path);
    request.files.add(pic);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('image uploaded succesfully');
      _showSnackBar(context, "Image Uploaded Successfully");
      setState(() {
        imageUploaded = true;
      });
    } else {
      print(response.statusCode);
      _showSnackBar(context, "Error Occured!");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Image Upload'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.camera),
                      label: Text(
                        "Pick an image",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        _clickImg();
                      },
                    ),
                  ],
                ),
                image != null
                    ? Container(
                        padding: EdgeInsets.all(18),
                        child: Image.file(image),
                      )
                    : Container(
                        // height: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(
                          'Pick an image',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                imageUploaded == true
                    ? Container(
                        // height: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        child: Text(
                          'Image Uploaded Successfully',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ))
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    child: Text("View Uploaded Images"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => ViewImages()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Modal Bottom Sheet
// showModalBottomSheet(
//   // enableDrag: true,
//   // elevation: 20,

//   isScrollControlled: true,
//   context: context,
//   builder: (context) => Padding(
//     padding: EdgeInsets.symmetric(vertical: 15),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         IconButton(
//           icon: Icon(Icons.image),
//           iconSize: 33,
//           color: Theme.of(context).primaryColor,
//           onPressed: _pickImg,
//         ),
//         IconButton(
//           icon: Icon(Icons.camera),
//           iconSize: 33,
//           color: Theme.of(context).primaryColor,
//           onPressed: _clickImg,
//         ),
//       ],
//     ),
//   ),
// );
