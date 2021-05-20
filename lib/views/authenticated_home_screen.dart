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
  Widget thisImageProb = null;
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
  int isReturningImage = 0;
  String latitudeForStackedImage = "null";
  String longitudeForStackedImage = "null";
  String dateForStackedImage = "null";
  String timeForStackedImage = "null";
  static int runBuildImageOnlyOnce = 0;

  setNullAgain() {
    task = null;
    thisImageProb = null;
    runstimes = 0;
    bytes1 = null;
    image = null;
    imageUploaded = false;
    count = 0;
    isReturningImage = 0;
    urlcount = 0;
    downUrl = "";
    thisWasCardWidget = null;
    loadingString = "LOADING WIDGET";
    latitudeForStackedImage = "null";
    longitudeForStackedImage = "null";
    dateForStackedImage = "null";
    timeForStackedImage = "null";
    runBuildImageOnlyOnce = 0;
  }

  Future<PickedFile> _clickImg() async {
    print("1 - Click Image is running");
    setNullAgain();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        // _saveImage();
        _fetchImageDetails().then((value) => getPng()
            // .then(
            //   (bytesHere) =>
            //       //Get Png is returning null bytes.
            //       uploadBytes(bytesHere),
            // ),
            );
      });
    }
  }

  Future<Widget> _fetchImageDetails() async {
    runstimes++;
    _imgHasLocation = await getLocPermission();

    if (_imgHasLocation == null) {
      _imgHasLocation = await getLocPermission();
    }
    latitudeForStackedImage =
        _imgHasLocation == false ? "Not Found" : thisLoc.latitude.toString();
    longitudeForStackedImage =
        _imgHasLocation == false ? "Not Found" : thisLoc.longitude.toString();

    dateForStackedImage = DateFormat.yMMMd().format(DateTime.now()).toString();
    timeForStackedImage = DateFormat.Hm().format(DateTime.now()).toString();

    print("2- Fetch Image is running");

    return Container();

    //Fetch image doesn't need to return this widget, as stacked image is set as future in future builder.
    // stackedImage(
    //   image,
    //   latitudeForStackedImage,
    //   longitudeForStackedImage,
    //   dateForStackedImage,
    //   timeForStackedImage,
    //   runstimes,
    // );
  }

  Future<bool> getLocPermission() async {
    await Geolocator.requestPermission();
    count++;

    print("permission asked $count times for location");
    LocationPermission status = await Geolocator.checkPermission();
    print(status);
    if (status == LocationPermission.always) {
      thisLoc = await Geolocator.getCurrentPosition();
      return true;
    } else if ((status == LocationPermission.denied ||
        status == LocationPermission.deniedForever)) {
      getLocPermission();
    } else {
      print("returning false");
      return false;
    }
  }

  Future<Uint8List> getPng() async {
    //Get a proper PNG after 5 seconds
    setState(() {});
    print("3 - Get PNG is running: Suspect");
    Timer(Duration(seconds: 1), () async {
      Uint8List bytes2 = null;
      bytes2 = await Utils().capture(key1);
      print(bytes2.toString());
      print("IS BYTES2");

      setState(() {
        thisImageProb = buildImage(bytes2);
      });
      return bytes2;
    });
  }

  Widget buildImage(Uint8List sendMebytes) {
    print(
        "4 - Build Image is running before getting bytes or something: Suspect");
    uploadBytes(sendMebytes);
    if (runBuildImageOnlyOnce < 2) {
      return sendMebytes != null
          ? Image.memory(sendMebytes)
          : Container(
              child: image == null
                  ? Text(
                      "Select an image",
                      style: columnElementTextStyle(),
                    )
                  : downUrl.contains("firebasestorage")
                      ? Text(
                          "Upload Successful",
                          style: columnElementTextStyle(),
                        )
                      : Text(
                          'Loading image file',
                          style: columnElementTextStyle(),
                        ),
            );
      //  image != null
      //     ? Container(
      //         child: Text("IMAGE NOT FOUND"),
      //       )
      //     // ? Container()
      //     : Container();
    }
  }

  Future uploadBytes(Uint8List thisbytes) async {
    print("5 - The upload step");
    if (thisbytes == null) {
      print("null returned");
    }
    final destination = 'files/';
    task = FirebaseAPI.uploadBytes(destination, thisbytes);

//This setstate has been upgraded with setstate(){} in getpngg
    // setState(() {});
    if (task == null) {
      print("Task is null");
      return;
    }

    if (task != null) {
      print("Task was not null");
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

  _showSnackBar(BuildContext context, String message) {
    print('WORKS');
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        print(snapshot.connectionState.toString());
        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.connectionState == ConnectionState.active ||
            snapshot.hasData) {
          final snap = snapshot.data;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = progress * 100;

          return Container(
            child: Text(
              'Progress: ${percentage.toString()}',
              style: columnElementTextStyle(),
            ),
          );
        } else {
          print("IT IS EMPTY IN WIDGET");
          return Container(
              // child:
              // Text('EMPTY EMPTY EMPTY'),
              );
        }
      });

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

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

  @override
  void initState() {
    super.initState();
    getLocPermission();
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
                    _clickImg();
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
                child: image != null
                    // downUrl != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // task != null ? buildUploadStatus(task) : Container(),
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
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Pick an image",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
            ),
            image != null
                // && runstimes < 90
                ? WidgetToImage(
                    builder: (key) {
                      this.key1 = key;
                      return Container(
                        padding: EdgeInsets.all(15),
                        child: FutureBuilder<Widget>(
                            future: stackedImage(
                              //Major Change: Instead of fetchimage, use stacked image widget by converting it to future<Widget>
                              image,
                              latitudeForStackedImage,
                              longitudeForStackedImage,
                              dateForStackedImage,
                              timeForStackedImage,
                              // runstimes,
                            ),
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
                                  ? Text('')
                                  : thisWasCardWidget;
                            }),

                        //  Image.file(image),
                      );
                    },
                  )
                : Container(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.9,
              height: thisImageProb == null ? 400 : 600,
              child: thisImageProb == null
                  ? Center(child: Text(""))
                  : thisImageProb,
            ),
            // ],
            // ),
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
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: ElevatedButton(
            //       child: Text("Get PNG"),
            //       onPressed: () {
            //         uploadBytes();
            //       }),
            // ),
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
