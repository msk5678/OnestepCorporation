import 'package:flutter/material.dart';
import 'package:onestep_rezero/reportDialog.dart';

Widget buildBottomSheet(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            )),
        child: Column(
          children: [
            ListTile(
              title: Center(
                  child: Text(
                "낚시/도배",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportFirstDialog("낚시/도배", context),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "욕설/비하",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportSecondDialog("욕설/비하", context),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "상업적 광고 및 피해",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportThirdDialog("상업적 광고 및 피해", context),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "정당/정치인 비하 및 선거운동",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => reportFourthDialog("정당/정치인 비하 및 선거운동", context),
            ),
            Divider(
              height: 10,
              thickness: 2,
            ),
            ListTile(
              title: Center(
                  child: Text(
                "기타",
                style: TextStyle(fontSize: 20),
              )),
              onTap: () => showModalBottomSheet(
                  context: context,
                  builder: buildBottomEtcSheet,
                  isScrollControlled: false),
            )
          ],
        ),
      ),
    ),
  );
}
