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
