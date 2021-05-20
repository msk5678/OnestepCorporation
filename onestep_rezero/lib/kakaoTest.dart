import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/link.dart';

class LinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(title: Text("Default"), onTap: onTapDefault),
      ],
    );
  }

  void onTapDefault() async {
    try {
      print("1111");
      var template = FeedTemplate(
          Content(
              "딸기 치즈 케익",
              Uri.parse(
                  "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png"),
              Link(
                  webUrl: Uri.parse("https://developers.kakao.com"),
                  mobileWebUrl: Uri.parse("https://developers.kakao.com"))),
          buttons: [
            Button("웹으로 보기",
                Link(webUrl: Uri.parse("https://developers.kakao.com"))),
            Button("앱으로 보기",
                Link(webUrl: Uri.parse("https://developers.kakao.com"))),
          ]);
      print("2222");
      var uri = await LinkClient.instance.defaultWithTalk(template);
      print("3333");
      await LinkClient.instance.launchKakaoTalk(uri);
      print("4444");
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }
}
