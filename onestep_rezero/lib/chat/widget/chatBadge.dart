import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

Widget chatCountBadge(int readCount) {
  if (readCount > 0)
    return Badge(
      toAnimate: false,
      borderRadius: BorderRadius.circular(8),
      badgeColor: Colors.red,
      badgeContent: Text(
        readCount.toString()
        //+ snapshot.data.docs[1]['isRead'].toString()
        ,
        style: TextStyle(fontSize: 8, color: Colors.white),
      ),
      //child: Icon(Icons.ac_unit, color: Colors.white),
    );
  else
    return Text("");
}
