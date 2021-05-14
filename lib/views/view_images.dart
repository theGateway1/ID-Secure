import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:zz_assetplus_flutter_mysql/widgets/widgets.dart';
import '../constants/strings.dart';

class ViewImages extends StatefulWidget {
  @override
  _ViewImagesState createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  var dio = Dio();
  List responseList = [];

  Future<List> getImages() async {
    var response = await dio.get(DOWNLOAD_URL);
    if (response.statusCode == 200) {
      responseList = json.decode(response.data);

      print(responseList);
      return responseList;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body:
          // responseList.isNotEmpty
          //     ? Center(
          //         child: Text(
          //           'Start Uploading images to the database.',
          //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //           textAlign: TextAlign.center,
          //         ),
          //       )
          //     :
          FutureBuilder<List>(
        future: getImages(),
        builder: (context, snapshot) {
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              List receivedList = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID: ${receivedList[index]['id']}",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      SelectableText(
                        "Latitude: ${receivedList[index]['latitude']}",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      SelectableText(
                        "Longitude: ${receivedList[index]['longitude']}",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      Container(
                          child: Image.network(
                              "$IMAGE_URL/${responseList[index]["image"]}")),
                      DividerHere(),
                    ],
                  ),
                ),
              );
            },
            itemCount: snapshot.data.length,
          );
        },
      ),
    );
  }
}
