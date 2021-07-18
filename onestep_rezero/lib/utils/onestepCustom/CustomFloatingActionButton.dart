import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFloatingActionButton {
  static Widget scrollToTopButton(
      {@required ScrollController scrollController,
      @required StreamController streamController}) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: StreamBuilder<bool>(
            stream: streamController.stream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Visibility(
                visible: snapshot.data,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 40.0.h,
                  width: 40.0.w,
                  child: FittedBox(
                    child: FloatingActionButton(
                      elevation: 0,
                      heroTag: null,
                      onPressed: () {
                        scrollController.position
                            .moveTo(0.5, duration: Duration(milliseconds: 200));
                      },
                      child: Icon(Icons.keyboard_arrow_up_rounded,
                          color: Colors.black),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
