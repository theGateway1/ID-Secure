import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:dio/dio.dart';
import 'package:zz_assetplus_flutter_mysql/views/view_images.dart';
import '../constants/strings.dart';
import 'package:exif/exif.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class AuthenticatedHomeScreen extends StatefulWidget {
  @override
  _AuthenticatedHomeScreenState createState() =>
      _AuthenticatedHomeScreenState();
}

class _AuthenticatedHomeScreenState extends State<AuthenticatedHomeScreen> {
  List<Asset> images = <Asset>[];
  var dio = Dio();
  GeoFirePoint thisLoc;
  bool _imgHasLocation = false;
  String imagePathForCheckGps = "null";
  GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey(); //Key to get context to show snackbar;

  Future<GeoFirePoint> _checkGPSData(String imageForCheckGps) async {
    print('runs check');
    Map<String, IfdTag> imgTags =
        await readExifFromBytes(File(imageForCheckGps).readAsBytesSync());
    print('this ran');
    if (imgTags.containsKey('GPS GPSLongitude')) {
      _imgHasLocation = true;
      thisLoc = exifGPSToGeoFirePoint(imgTags);
      return thisLoc;
    } else {
      print('Nope, no location');
    }
  }

  // _showSnackBar(BuildContext context, String message) {
  //   print('WORKS');
  //   // ScaffoldMessenger.of(context).removeCurrentSnackBar();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }

  GeoFirePoint exifGPSToGeoFirePoint(Map<String, IfdTag> tags) {
    print('runs GeoFire');
    final latitudeValue = tags['GPS GPSLatitude']
        .values
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final latitudeSignal = tags['GPS GPSLatitudeRef'].printable;

    final longitudeValue = tags['GPS GPSLongitude']
        .values
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final longitudeSignal = tags['GPS GPSLongitudeRef'].printable;

    double latitude =
        latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

    double longitude = longitudeValue[0] +
        (longitudeValue[1] / 60) +
        (longitudeValue[2] / 3600);

    if (latitudeSignal == 'S') latitude = -latitude;
    if (longitudeSignal == 'W') longitude = -longitude;

    return GeoFirePoint(latitude, longitude);
  }

  _saveImages() async {
    if (images != null) {
      for (var i = 0; i < images.length; i++) {
        _imgHasLocation = false;
        ByteData byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asInt8List();

        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: images[i].name,
          contentType: MediaType('image', 'jpg'),
        );
        imagePathForCheckGps =
            await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
        thisLoc = await _checkGPSData(imagePathForCheckGps);

        FormData formdata = FormData.fromMap(
          {
            "image": multipartFile,
            "latitude": _imgHasLocation == false
                ? "Not Found"
                : thisLoc.latitude.toString(),
            "longitude": _imgHasLocation == false
                ? "Not Found"
                : thisLoc.longitude.toString(),
          },
        );

        var response = await dio.post(UPLOAD_URL, data: formdata);
        if (response.statusCode == 200) {
          print(response.data);
          // _showSnackBar(context, "Image Uploaded Successfully");
        } else {
          print(response.data);
          // _showSnackBar(context, "Error Occured!");
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      padding: EdgeInsets.all(15),
      mainAxisSpacing: 10,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print("1. ${images[index].identifier}, 2. ${images[index].name}");
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'None';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#abcdef",
          actionBarTitle: "Pick Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
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
            height: MediaQuery.of(context).size.height * 0.89,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: images.isNotEmpty
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Pick images"),
                      onPressed: loadAssets,
                    ),
                    images.isNotEmpty
                        ? ElevatedButton(
                            child: Text("Upload Images"),
                            onPressed: _saveImages,
                          )
                        : Container(),
                  ],
                ),
                Expanded(
                  child: buildGridView(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text("View Uploaded Images"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ViewImages()));
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
