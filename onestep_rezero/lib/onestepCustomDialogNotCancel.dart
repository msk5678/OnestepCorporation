import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';

class OnestepCustomDialogNotCancel extends StatefulWidget {
  final String title, description;
  final String confirmButtonText;
  final Function confirmButtonOnPress;
  OnestepCustomDialogNotCancel(
      {Key key,
      @required this.title,
      this.description,
      @required this.confirmButtonText,
      @required this.confirmButtonOnPress})
      : super(key: key);

  @override
  _OnestepCustomDialogNotCancelState createState() =>
      _OnestepCustomDialogNotCancelState();
}

class _OnestepCustomDialogNotCancelState
    extends State<OnestepCustomDialogNotCancel> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (widget.description != null)
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: widget.confirmButtonOnPress,
                      child: Text(
                        widget.confirmButtonText,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: OnestepColors().mainColor,
                        onPrimary: Colors.white,
                        textStyle: TextStyle(fontSize: 17),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
