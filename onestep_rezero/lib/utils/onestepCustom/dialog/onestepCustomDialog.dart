import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';

class OnestepCustomDialog {
  static show(
    BuildContext context, {
    @required String title,
    String description,
    @required String confirmButtonText,
    @required String cancleButtonText,
    @required Function confirmButtonOnPress,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  if (description != null)
                    Text(
                      description,
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(cancleButtonText),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black26,
                            onPrimary: Colors.white,
                            textStyle: TextStyle(fontSize: 17),
                            elevation: 0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: confirmButtonOnPress,
                          child: Text(
                            confirmButtonText,
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
      },
    );
  }
}
