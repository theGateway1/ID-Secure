import 'dart:io';

import 'package:flutter/material.dart';

Widget DividerHere() {
  return Text(
    '________________________________________________________________________________________',
    softWrap: false,
    overflow: TextOverflow.clip,
    style: TextStyle(
        color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
  );
}

TextStyle columnElementTextStyle() {
  return TextStyle(
      fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500);
}

Widget stackedImage(
    File image, String latitude, String longitude, String date, String time) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.grey, width: 2)),
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'Latitude: $latitude',
                style: columnElementTextStyle(),
              ),
              SelectableText(
                'Longitude: $longitude',
                style: columnElementTextStyle(),
              ),
              SelectableText(
                'Date: $date',
                style: columnElementTextStyle(),
              ),
              SelectableText(
                'Time: $time',
                style: columnElementTextStyle(),
              ),
            ],
          ),
        ),
        Image.file(image),
      ],
    ),
  );
}


// // child: Stack(
//       // fit: StackFit.expand,
//       alignment: Alignment.topLeft,
//       children: [
//         Image.file(image),
//         Container(
//           padding: EdgeInsets.all(5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SelectableText(
//                 'Latitude: $latitude',
//                 style: columnElementTextStyle(),
//               ),
//               SelectableText(
//                 'Longitude: $longitude',
//                 style: columnElementTextStyle(),
//               ),
//               SelectableText(
//                 'Date: $date',
//                 style: columnElementTextStyle(),
//               ),
//               SelectableText(
//                 'Time: $time',
//                 style: columnElementTextStyle(),
//               ),
//             ],
//           ),
//         ),
//       ],
    // ),