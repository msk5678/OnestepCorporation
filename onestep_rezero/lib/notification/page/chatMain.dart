import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onestep_rezero/notification/page/realtimePage.dart';
import 'package:onestep_rezero/notification/realtime/realtimeProductChatController.dart';
import 'package:onestep_rezero/notification/uploadImage/uploadImage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

class ChatMainPage extends StatefulWidget {
  static const String routeName = '/material/scrollable-tabs';
  @override
  ChatMainPageState createState() => ChatMainPageState();
}

class _Page {
  const _Page({this.icon, this.text});
  final IconData icon;
  final String text;
}

const List<_Page> _allPages = <_Page>[
  _Page(
    icon: Icons.chat,
    text: '장터게시판',
  ),
  _Page(icon: Icons.post_add, text: '일반게시판'),
  // _Page(icon: Icons.check_circle, text: 'SUCCESS'),
];

class ChatMainPageState extends State<ChatMainPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("chat main");
    //chatCount.initChatCount();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(150, 150, 150, 1),
        title: Text(
          'Scrollable tabs ' + "chat main"
          // +
          // chatCount.getProductChatCount().toString() +
          // chatCount.getBoardChatCount().toString()
          ,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),

          ///Note: Here I assigned 40 according to me. You can adjust this size acoording to your purpose.
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: Color.fromRGBO(248, 247, 77, 1),
                  ),
                  insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
              controller: _controller,
              isScrollable: true,
              labelPadding: EdgeInsets.only(left: 8, right: 0),
              tabs: _allPages.map<Tab>((_Page page) {
                // print("####### ${page.text}");
                return Tab(
                    text: page.text,
                    icon:
                        //Icon(Icons.ac_unit),
                        Badge(
                      toAnimate: true,
                      borderRadius: BorderRadius.circular(80),
                      badgeColor: Colors.red,
                      badgeContent:
                          RealtimeProductChatController().getProductCountText(),
                      //Text("d"),
                      child: Icon(page.icon,
                          color: Color.fromRGBO(248, 247, 77, 1)),
                    )

                    // page.text == "장터게시판"
                    //     ? Badge(
                    //         toAnimate: true,
                    //         borderRadius: BorderRadius.circular(80),
                    //         badgeColor: Colors.red,
                    //         badgeContent:
                    //             ProductChatController().getProductCountText(),
                    //         child: Icon(page.icon,
                    //             color: Color.fromRGBO(248, 247, 77, 1)),
                    //       )
                    //     : Badge(
                    //         toAnimate: true,
                    //         borderRadius: BorderRadius.circular(80),
                    //         badgeColor: Colors.red,
                    //         badgeContent:
                    //             BoardChatController().getBoardCountText(),
                    //         child: Icon(page.icon,
                    //             color: Color.fromRGBO(169, 215, 254, 1)),
                    //       ),
                    );
              }).toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: _allPages.map<Widget>((_Page page) {
          return SafeArea(
            top: false,
            bottom: false,
            child: PageView.builder(
              itemBuilder: (context, position) {
                return Container(
                    child: (position == 0 && page.text == '장터게시판')
                        ?
                        //Text("ㄱㄷ")
                        RealTimePage()
                        :
                        //BoardChatPage()
                        StorageExampleApp()
                    //Text("ㄱㄷ")
                    //RealTimePage()
                    );
              },
              itemCount: 1,
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print("플로팅 클릭");
        getImage();
      }),
    );
  }

  var metadata;
  PickedFile pickFile;
  Future getImage() async {
    pickFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickFile != null) {
      print("1이미지 선택 완료");
      metadata = firebase_storage.SettableMetadata(
          contentType: 'Image/jpeg',
          customMetadata: {'fuckPickImage': pickFile.path});
      //isLoading = true;
    }

    //imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    // if (imageFile != null) {
    //   isLoading = true;
    // }

    uploadImageFile();
    print('99이미지 업로드 완료');
  }

  Future uploadImageFile() async {
    print('3이미지 업로드 호출');
    List<firebase_storage.UploadTask> _uploadTasks = [];

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    print('4이미지 이름 $fileName');
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("chat Images")
        .child(fileName);
    //1. 레퍼런스 똑같음
    //

    firebase_storage.UploadTask storageUploadTask;
    storageUploadTask =
        storageReference.putFile(io.File(pickFile.path), metadata);
    //storageReference.putFile(io.File(pickFile.path));
    print("5이미지 경로 ${pickFile.path}");
    firebase_storage.TaskSnapshot storageTaskSnapshot = await storageUploadTask;

    //.onComplete;
    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child("chat Images").child(fileName);
    // StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    // StorageTaskSnapshot storageTaskSnapshot =
    //     await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      print("6이미지 스토리지 URL : $downloadUrl");
//      imageUrl = downloadUrl;
      setState(() {
        // isLoading = false;
        // onSendToProductMessage(imageUrl, 1);
      });
    }, onError: (error) {
      setState(() {
        // isLoading = false;
      });
      print('에러' + error);
      //Fluttertoast.showToast(msg: "Error: ", error);
    });
    return Future.value(storageUploadTask);
  }
}
