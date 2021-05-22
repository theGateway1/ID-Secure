import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zz_assetplus_flutter_mysql/widgets/widgets.dart';
import '../constants/strings.dart';

class ViewImages extends StatefulWidget {
  @override
  _ViewImagesState createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  var dio = Dio();
  List responseList = [];
  List receivedList = ['123'];
  List reversedList = [];

  Future<List> getImages() async {
    var response = await dio.get(DOWNLOAD_URL);
    if (response.statusCode == 200) {
      responseList = json.decode(response.data);

      print(responseList);
      return responseList;
    }
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
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
      body: FutureBuilder<List>(
        future: getImages(),
        builder: (context, snapshot) {
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              receivedList = snapshot.data;
              reversedList = receivedList.reversed.toList();
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(6, 12, 6, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID: ${reversedList[index]['id']}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      SelectableText(
                        "Latitude: ${reversedList[index]['latitude']}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      SelectableText(
                        "Longitude: ${reversedList[index]['longitude']}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      SelectableText(
                        "Date: ${reversedList[index]['date']}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      SelectableText(
                        "Time: ${reversedList[index]['time']}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      Row(
                        children: [
                          Text(
                            'Image Url: ',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Linkify(
                            onOpen: _onOpen,
                            text: "${reversedList[index]["downurl"]}",
                            overflow: TextOverflow.ellipsis,
                            options: LinkifyOptions(humanize: false),
                            style:
                                imageUrlStyle(Colors.blue, FontWeight.normal),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),
                      Container(
                          child: Image.network(
                              "${reversedList[index]["downurl"]}")),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.016,
                      ),

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
