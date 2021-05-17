// File videoFile;
//   File imageFile;

//   TextEditingController _controller = new TextEditingController();
//   final picker = ImagePicker();

//   _takeVid() async {
//     final pickedFile = await picker.getVideo(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         videoFile = File(pickedFile.path);
//       });
//       Navigator.of(context).pop();
//     }
//   }

//   _pickVid() async {
//     final pickedFile = await picker.getVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         videoFile = File(pickedFile.path);
//       });
//       Navigator.of(context).pop();
//     }
//   }

//   _clickImg() async {
//     final pickedFile = await picker.getImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path);
//       });
//       Navigator.of(context).pop();
//     }
//   }

//   _pickImg() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         imageFile = File(pickedFile.path);
//       });
//       Navigator.of(context).pop();
//     }
//   }

//   _chatBubble(Message message, bool isMe, bool isSameUser) {
//     if (isMe) {
//       return Column(
//         children: <Widget>[
//           Container(
//             // decoration: BoxDecoration(
//             //     border: Border.all(
//             //   color: Colors.red,
//             //   width: 2,
//             // )),
//             alignment: Alignment.topRight,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.80,
//               ),
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 message.text,
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           !isSameUser
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Text(
//                       message.time,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black45,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         radius: 15,
//                         backgroundImage: AssetImage(message.sender.imageUrl),
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(
//                   child: null,
//                 ),
//         ],
//       );
//     } else {
//       return Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topLeft,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.80,
//               ),
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 message.text,
//                 style: TextStyle(
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//           ),
          
//               : Container(
//                   child: null,
//                 ),
//         ],
//       );
//     }
//   }

//   _sendMessageArea() {
//     return Container(
//         padding: EdgeInsets.symmetric(horizontal: 8),
//         height: 70,
//         color: Colors.white,
//         child: Row(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.attach_file),
//               iconSize: 33,
//               color: Theme.of(context).primaryColor,
//               onPressed: () {
//                 showModalBottomSheet(
//                   // enableDrag: true,
//                   // elevation: 20,

//                   isScrollControlled: true,
//                   context: context,
//                   builder: (context) =>  Padding(
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.image),
//                                 iconSize: 33,
//                                 color: Theme.of(context).primaryColor,
//                                 onPressed: _pickImg,
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.camera),
//                                 iconSize: 33,
//                                 color: Theme.of(context).primaryColor,
//                                 onPressed: _clickImg,
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.video_collection),
//                                 iconSize: 33,
//                                 color: Theme.of(context).primaryColor,
//                                 onPressed: _pickVid,
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.video_call),
//                                 iconSize: 33,
//                                 color: Theme.of(context).primaryColor,
//                                 onPressed: _takeVid,
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.attachment),
//                                 iconSize: 33,
//                                 color: Theme.of(context).primaryColor,
//                                 onPressed: () {},
//                               ),
//                             ],
//                           ),
//                         )
//                 );
//               },
//             ),
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'Send a message..',
//                 ),
//                 textCapitalization: TextCapitalization.sentences,
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.send),
//               iconSize: 33,
//               color: Theme.of(context).primaryColor,
//               onPressed: () {},
//             ),
//           ],
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     int prevUserId;
//     return Scaffold(
//       backgroundColor: Color(0xFFF6F6F6),
//       body: videoFile == null && imageFile == null
//           ? Stack(
//               children: [
//                 Positioned.fill(
//                   child: ListView.builder(
//                     itemBuilder: (context, index) => Column(
//                       children: [
//                         Divider(
//                           thickness: 3,
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                       ],
//                     ),
//                     itemCount: (MediaQuery.of(context).size.height - 110) ~/ 23,
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       child: ListView.builder(
//                         reverse: true,
//                         padding: EdgeInsets.all(20),
//                         itemCount: messages.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           final Message message = messages[index];
//                           final bool isMe = message.sender.id == currentUser.id;
//                           final bool isSameUser =
//                               prevUserId == message.sender.id;
//                           prevUserId = message.sender.id;
//                           return _chatBubble(message, isMe, isSameUser);
//                         },
//                       ),
//                     ),
//                     _sendMessageArea(),
//                   ],
//                 ),
//               ],
//             )
//           : imageFile == null
//               ? PlayVideo(videoFile)
//               : ShowImage(imageFile),
//     );
//   }
// }