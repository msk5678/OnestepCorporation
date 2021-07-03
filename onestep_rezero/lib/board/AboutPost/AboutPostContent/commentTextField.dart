import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';

class CustomCommentTextField extends StatefulWidget {
  final String hintText;
  final Function iconOnPressCallback;
  CustomCommentTextField({this.iconOnPressCallback, this.hintText});
  @override
  State<StatefulWidget> createState() => new SearchTextFieldState();
}

class SearchTextFieldState extends State<CustomCommentTextField> {
  Function callback;
  String hintText;
  @override
  void initState() {
    callback = widget.iconOnPressCallback;
    hintText = widget.hintText;
    super.initState();
  }

  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.mode_comment_rounded,
          color: _textController.text.length > 0
              ? OnestepColors().mainColor
              : Colors.grey,
        ),
        new SizedBox(
          width: 10.0,
        ),
        new Expanded(
          child: new Stack(
              alignment: const Alignment(1.0, 1.0),
              children: <Widget>[
                new TextField(
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: hintText ?? "",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: OnestepColors().mainColor),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                  controller: _textController,
                ),
                _textController.text.length > 0
                    ? new IconButton(
                        icon: new Icon(
                          Icons.send_rounded,
                          color: OnestepColors().mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            callback(_textController.text);
                            _textController.clear();
                          });
                        })
                    : new Container(
                        height: 0.0,
                      )
              ]),
        ),
      ],
    );
  }
}
