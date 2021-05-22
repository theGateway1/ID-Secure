// import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zz_assetplus_flutter_mysql/widgets/widgets.dart';

class StackedImage extends ChangeNotifier {
  File image;
  String latitudeForStackedImage;
  String longitudeForStackedImage;
  String dateForStackedImage;
  String timeForStackedImage;
  final picker = ImagePicker();
  bool _imgHasLocation = false;
  Position thisLoc;

  Future<PickedFile> _clickImg() async {
    print("1 - Click Image is running");
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // setState(() {
      image = File(pickedFile.path);
      // _saveImage();
      _fetchImageDetails();

      // });
    }
    notifyListeners();
  }

  Future<Widget> _fetchImageDetails() async {
    _imgHasLocation = await getLocPermission();

    if (_imgHasLocation == null) {
      _imgHasLocation = await getLocPermission(); //get location
    }
    String latitudeForStackedImage =
        _imgHasLocation == false ? "Not Found" : thisLoc.latitude.toString();
    String longitudeForStackedImage =
        _imgHasLocation == false ? "Not Found" : thisLoc.longitude.toString();

    String dateForStackedImage =
        DateFormat.yMMMd().format(DateTime.now()).toString();
    String timeForStackedImage =
        DateFormat.Hm().format(DateTime.now()).toString();

    print("2- Fetch Image is running");

    return stackedImageNotModel(
      image,
      latitudeForStackedImage,
      longitudeForStackedImage,
      dateForStackedImage,
      timeForStackedImage,
    );
    // });
  }

  Future<bool> getLocPermission() async {
    await Geolocator.requestPermission();

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
}
