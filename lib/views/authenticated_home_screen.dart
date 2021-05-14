import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:dio/dio.dart';
import '../constants/strings.dart';

class AuthenticatedHomeScreen extends StatefulWidget {
  @override
  _AuthenticatedHomeScreenState createState() =>
      _AuthenticatedHomeScreenState();
}

class _AuthenticatedHomeScreenState extends State<AuthenticatedHomeScreen> {
  List<Asset> images = <Asset>[];
  String _error = 'None';
  var dio = Dio();
  String _futureGpsLocation = 'DELHI';

  _saveImages() async {
    if (images != null) {
      for (var i = 0; i < images.length; i++) {
        ByteData byteData = await images[i].getByteData();
        List<int> imageData = byteData.buffer.asInt8List();

        MultipartFile multipartFile = MultipartFile.fromBytes(
          imageData,
          filename: images[i].name,
          contentType: MediaType('image', 'jpg'),
        );

        FormData formdata = FormData.fromMap({
          "image": multipartFile,
          "userlocation": _futureGpsLocation,
        });

        var response = await dio.post(UPLOAD_URL, data: formdata);
        if (response.statusCode == 200) {
          print(response.data);
        } else {
          print(response.data);
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
          actionBarColor: "#abcdef",
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
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Upload'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.89,
            child: Column(
              children: <Widget>[
                _error == 'None'
                    ? Container()
                    : Center(child: Text('Error: $_error')),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
