import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zz_assetplus_flutter_mysql/services/firebase_methods.dart';

import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zz_assetplus_flutter_mysql/utils/utils.dart';
import 'package:zz_assetplus_flutter_mysql/views/view_images.dart';
import 'package:zz_assetplus_flutter_mysql/widgets/widget_to_img.dart';
import '../widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticatedHomeScreen extends StatefulWidget {
  @override
  _AuthenticatedHomeScreenState createState() =>
      _AuthenticatedHomeScreenState();
}

class _AuthenticatedHomeScreenState extends State<AuthenticatedHomeScreen> {
  UploadTask task;
  GlobalKey key1;
  static int runstimes = 0;
  Uint8List bytes1;
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
  static int urlcount = 0;
  String downUrl = "";
  Widget thisWasCardWidget = null;
  String loadingString = "LOADING WIDGET";

  _showSnackBar(BuildContext context, String message) {
    print('WORKS');
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  getPng() async {
    final bytes1 = await Utils().capture(key1);
    setState(() {
      this.bytes1 = bytes1;
    });
  }

  Future<PickedFile> _clickImg() async {
    setNullAgain();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        // _saveImage();
        _fetchImageDetails();
      });
    }
  }

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

  Future<Widget> _fetchImageDetails() async {
    runstimes++;
    if (runstimes < 3) {
      //Was 3
      _imgHasLocation = await getLocPermission();
      print("$_imgHasLocation -> THIS IS FINAL VALUE");
      if (_imgHasLocation == null) {
        _imgHasLocation = await getLocPermission();
      }
      String latitudeForStackedImage =
          _imgHasLocation == false ? "Not Found" : thisLoc.latitude.toString();
      String longitudeForStackedImage =
          _imgHasLocation == false ? "Not Found" : thisLoc.longitude.toString();

      String dateForStackedImage =
          DateFormat.yMMMd().format(DateTime.now()).toString();
      String timeForStackedImage =
          DateFormat.Hm().format(DateTime.now()).toString();

      // print("IT RUNS $runstimes");

      return stackedImage(
        image,
        latitudeForStackedImage,
        longitudeForStackedImage,
        dateForStackedImage,
        timeForStackedImage,
        runstimes,
      );
    }
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  Widget buildImage(Uint8List bytes) {
    uploadBytes();
    return bytes != null
        // ? Image.memory(bytes)
        ? Container(
            child: downUrl == ""
                ? Text(
                    "Starting Upload",
                    style: columnElementTextStyle(),
                  )
                : downUrl.contains("firebasestorage")
                    ? Text("Upload Successful", style: columnElementTextStyle())
                    : Text(
                        'Error Occured!',
                        style: columnElementTextStyle(),
                      ))
        : image != null
            // ? Container(
            //     child: Text("IMAGE NOT FOUND"),
            //   )
            ? Container()
            : Container();
  }

  Future uploadBytes() async {
    if (bytes1 == null) {
      print("null ret");
    }
    final destination = 'files/';
    task = FirebaseAPI.uploadBytes(destination, bytes1, urlcount);
    if (task == null) {
      print("Task is null");
      return;
    }
    final snapshot = await task.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    if (downloadUrl.contains("firebasestorage")) {
      urlcount++;
      setState(() {
        downUrl = downloadUrl;
      });
    }
    print("Download Here: $downloadUrl");
  }

  // void anyHowGetPng() {
  //   if (loadingString != "Loading") {
  //     print("IT EVEN RUNS");
  //     getPng();
  //   } else {
  //     Timer(Duration(seconds: 10), () {
  //       anyHowGetPng();
  //     });
  //   }
  // }
  // _saveImage() async {
  //   imageUploaded = false;

  //   print(
  //       "The date is ${DateFormat.yMMMd().format(DateTime.now()).toString()}");

  //   // _imgHasLocation = await getLocPermission();
  //   // print("$_imgHasLocation -> THIS IS FINAL VALUE");
  //   // if (_imgHasLocation == null) {
  //   //   _imgHasLocation = await getLocPermission();
  //   // }

  //   var request = http.MultipartRequest('POST', Uri.parse(UPLOAD_URL));

  //   // request.fields["latitude"] =
  //   //     _imgHasLocation == false ? "Not Found" : thisLoc.latitude.toString();
  //   // request.fields["longitude"] =
  //   //     _imgHasLocation == false ? "Not Found" : thisLoc.longitude.toString();
  //   request.fields["date"] =
  //       "${DateFormat.yMMMd().format(DateTime.now()).toString()}";
  //   request.fields["time"] = DateFormat.Hm().format(DateTime.now()).toString();

  //   var pic = await http.MultipartFile.fromPath("image", image.path);
  //   request.files.add(pic);

  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     print('image uploaded succesfully');
  //     _showSnackBar(context, "Image Uploaded Successfully");
  //     setState(() {
  //       imageUploaded = true;
  //     });
  //   } else {
  //     print(response.statusCode);
  //     _showSnackBar(context, "Error Occured!");
  //   }
  // }

  setNullAgain() {
    task = null;
    key1 = null;
    runstimes = 0;
    bytes1 = null;
    image = null;
    count = 0;
    urlcount = 0;
    downUrl = "";
    loadingString = "LOADING WIDGET";
    thisWasCardWidget = null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Color.fromARGB(1, 238, 254, 257),
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text(
                    "Pick an image",
                    style: TextStyle(fontSize: 19),
                  ),
                  onPressed: () {
                    _clickImg().then((value) {
                      Timer(Duration(seconds: 4), () {
                        getPng();
                      });
                    });
                  },
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(7),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2)),
                child: downUrl != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            image == null
                                ? "Pick an image"
                                : downUrl.contains("firebasestorage")
                                    ? "Image URL:"
                                    : "Fetching",
                            style: image == null
                                ? TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)
                                : imageUrlStyle(Colors.black, FontWeight.bold),
                          ),
                          image == null
                              ? Container()
                              : SizedBox(
                                  height: 2,
                                ),
                          image != null && downUrl.contains("firebasestorage")
                              ? SelectableLinkify(
                                  onOpen: _onOpen,
                                  text: downUrl,
                                  options: LinkifyOptions(humanize: false),
                                  style: imageUrlStyle(
                                      Colors.blue, FontWeight.normal),
                                )
                              : Container(),
                        ],
                      )
                    : Text("Currently NULL"),
              ),
            ),
            image != null
                // && runstimes < 90
                ? WidgetToImage(
                    builder: (key) {
                      this.key1 = key;
                      return Container(
                        padding: EdgeInsets.all(15),
                        child: FutureBuilder(
                            future: _fetchImageDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  (snapshot.connectionState ==
                                          ConnectionState.active ||
                                      snapshot.connectionState ==
                                          ConnectionState.done)) {
                                thisWasCardWidget = snapshot.data;
                                return snapshot.data;
                              }
                              return thisWasCardWidget == null
                                  ? Text('Loading')
                                  : thisWasCardWidget;
                            }),

                        //  Image.file(image),
                      );
                    },
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage(bytes1),
              ],
            ),
            imageUploaded == true
                ? Container(
                    // height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: Text(
                      'Image Uploaded Successfully',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ))
                : Container(),
            Row(
              children: [
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                      child: Text("Get PNG"),
                      onPressed: () {
                        uploadBytes();
                      }),
                ),
              ],
            ),
          ],
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
