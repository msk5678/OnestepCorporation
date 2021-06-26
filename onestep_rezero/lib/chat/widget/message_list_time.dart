import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestep_rezero/chat/boardchat/model/productMessage.dart';
import 'package:onestep_rezero/chat/productchat/model/productChatMessage.dart';

Widget getMessageTime(String timestamp) {
  return Text(
    _getMessageTime(timestamp),
    style: TextStyle(
      color: Colors.grey,
      fontSize: 12.0,
      //  fontStyle: FontStyle.italic,
    ),
  );
}

Widget getMessageDate(String timestamp) {
  var nowtime = DateFormat("yyyy년 MM월 dd일 /EEEE")
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  var nowTimeList = nowtime.split('/');
  var dayoftheweek = _getMessageDayOfTheWeek((nowTimeList[1]));

  var resultTime = nowTimeList[0] + dayoftheweek;
  return Container(
    padding: EdgeInsets.only(
      bottom: 8,
    ),
    child: Row(
      children: [
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
        Text(
          resultTime,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
            //  fontStyle: FontStyle.italic,
          ),
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
      ],
    ),
  );
}

Widget compareToMessageDate(
    ProductMessage productMessage, ProductMessage nextProductMessage) {
  // xxxx년 2월 1일 월요일

  var pastTime = DateFormat("yyyy년 MM월 dd일 /EEEE").format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(productMessage.timestamp)));
  var pastTimeList = pastTime.split('/');

  var nextTime = DateFormat("yyyy년 MM월 dd일 /EEEE").format(
      DateTime.fromMillisecondsSinceEpoch(
          int.parse(nextProductMessage.timestamp)));
  var nextTimeList = nextTime.split('/');

  var resultTime = pastTimeList[0] + _getMessageDayOfTheWeek((pastTimeList[1]));
  // print("##messaage pastTime $pastTimeList // nextTime $nextTimeList");

  if (pastTimeList[0] == nextTimeList[0]) {
    return Container();
  } else
    return Text(
      resultTime,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12.0,
        //  fontStyle: FontStyle.italic,
      ),
    );
}

Widget compareToProductMessageDate(
    ProductChatMessage productMessage, ProductChatMessage nextProductMessage) {
  // xxxx년 2월 1일 월요일

  var pastTime = DateFormat("yyyy년 MM월 dd일 /EEEE").format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(productMessage.sendTime)));
  var pastTimeList = pastTime.split('/');

  var nextTime = DateFormat("yyyy년 MM월 dd일 /EEEE").format(
      DateTime.fromMillisecondsSinceEpoch(
          int.parse(nextProductMessage.sendTime)));
  var nextTimeList = nextTime.split('/');

  var resultTime = pastTimeList[0] + _getMessageDayOfTheWeek((pastTimeList[1]));
  // print("##messaage pastTime $pastTimeList // nextTime $nextTimeList");

  if (pastTimeList[0] == nextTimeList[0]) {
    return Container();
  } else
    return Container(
      padding: EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Divider(
                  color: Colors.black,
                  height: 36,
                )),
          ),
          Text(
            resultTime,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
              //  fontStyle: FontStyle.italic,
            ),
          ),
          Expanded(
            child: new Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Divider(
                  color: Colors.black,
                  height: 36,
                )),
          ),
          // Divider(
          //   color: Colors.black,
          //   height: 36,
          // ),
        ],
      ),
    );
}

String _getMessageTime(String timestamp) {
  var time;
  var meridiem;

  var nowtime = DateFormat("yyyy년 MM월 dd일/EEEE/a/kk:mm").format(
      DateTime.fromMillisecondsSinceEpoch(
          int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
  // var nowtimelist = nowtime.split('/');

  var gettime = DateFormat("yyyy년 MM월 dd일/EEEE/a/kk:mm")
      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  var gettimelist = gettime.split('/');

  //if (nowtimelist[0] == gettimelist[0]) {
  // print(nowtimelist[0] + gettimelist[0]);
  //오늘날짜일 경우 시간 보여준다.
  meridiem = _getMessageMeridiem((gettimelist[2]));
  time = gettimelist[3]; //오전 오후 12시 기준
  //dayoftheweek = _getDayOfTheWeek((gettimelist[1]));

  return meridiem + " " + time;
}

String _getMessageMeridiem(String meridiem) {
  return meridiem == "PM" ? "오후" : "오전";
}

String _getMessageDayOfTheWeek(String dayoftheweek) {
  //String dayoftheweek;
  switch (dayoftheweek) {
    case 'Monday':
      dayoftheweek = "월요일";
      break;
    case 'Tuesday':
      dayoftheweek = "화요일";
      break;
    case 'Wednesday':
      dayoftheweek = "수요일";
      break;
    case 'Thursday':
      dayoftheweek = "목요일";
      break;
    case 'Friday':
      dayoftheweek = "금요일";
      break;
    case 'Saturday':
      dayoftheweek = "토요일";
      break;
    case 'Sunday':
      dayoftheweek = "일요일";
      break;
    default:
      dayoftheweek = "요일 오류";
      break;
  }
  return dayoftheweek;
}
