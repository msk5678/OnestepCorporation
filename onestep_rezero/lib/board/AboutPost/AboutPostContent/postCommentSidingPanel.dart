// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:onestep_rezero/chat/widget/appColor.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

// class CommentSlidingPanel extends StatefulWidget {
//   final callback;
//   CommentSlidingPanel({Key key, this.callback}) : super(key: key);

//   @override
//   _CommentSlidingPanelState createState() => _CommentSlidingPanelState();
// }

// class _CommentSlidingPanelState extends State<CommentSlidingPanel> {
//   double deviceHeight;
//   double deviceWidth;
//   PanelController panelController = PanelController();
//   TextEditingController textEditingController = TextEditingController();
//   Function saveCommentCallback;
//   @override
//   void initState() {
//     super.initState();
//     saveCommentCallback = widget.callback;
//   }

//   @override
//   void didChangeDependencies() {
//     deviceHeight = MediaQuery.of(context).size.height;
//     deviceWidth = MediaQuery.of(context).size.width;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlidingUpPanel(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
//       minHeight: deviceWidth / 30,
//       maxHeight: deviceHeight / 2.5,
//       controller: panelController,
//       panel: Column(
//         children: [
//           Center(
//               child: Container(
//                   margin: EdgeInsets.only(top: 5, bottom: 20),
//                   height: deviceHeight / 130,
//                   width: deviceWidth / 10,
//                   decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.all(Radius.circular(5))))),
//           Center(
//             child: TextField(
//               controller: textEditingController,
//               // onChanged: (value) => saveCommentCallback(value),
//               minLines: 5,
//               maxLines: null,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: '댓글을 입력하세요.',
//               ),
//             ),
//           ),
//           ElevatedButton.icon(
//             onPressed: () => saveCommentCallback(textEditingController.text),
//             label: Text(
//               "저장",
//               style: TextStyle(color: Colors.grey),
//             ),
//             icon: Icon(
//               Icons.comment,
//               color: Colors.grey,
//             ),
//             style: ElevatedButton.styleFrom(
//                 elevation: 0, primary: OnestepColors().fifColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
