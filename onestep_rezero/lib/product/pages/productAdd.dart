import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/pages/productAddCategorySelect.dart';
import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:random_string/random_string.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key key}) : super(key: key);

  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  List<Asset> _imageList = <Asset>[];
  final _titleTextEditingController = TextEditingController();
  final _priceTextEditingController = TextEditingController();
  final _explainTextEditingController = TextEditingController();
  final _categoryTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("@@@@@@@@ 11111");
    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      );
    }

    Future<Uint8List> convertAssetToByteData(Asset asset) async {
      ByteData byteData = await asset.getByteData(
        quality: 100,
      );
      return byteData.buffer.asUint8List();
    }

    void getImages() async {
      List<Asset> _resultList = <Asset>[];

      _resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: _imageList,
        cupertinoOptions: CupertinoOptions(),
        materialOptions: MaterialOptions(
          useDetailsView: true,
          startInAllView: true,
          actionBarColor: "#FFFFFF", // 앱바 백그라운드 색
          actionBarTitleColor: "#000000", // 제목 글자색
          selectCircleStrokeColor: "#FFFFFF",
          backButtonDrawable: "back",
          okButtonDrawable: "check",
          statusBarColor: "#BBBBBB", // 상단 상태바 색
        ),
      );

      if (_resultList.isEmpty) return;

      setState(() {
        print("@@@@@@@@ 22222");
        _imageList = _resultList;
      });
    }

    Widget images() {
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "물품 사진",
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  getImages();
                },
                child: Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  decoration:
                      myBoxDecoration(), //       <--- BoxDecoration here
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        color: Colors.grey,
                        size: 30,
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Text(
                          "${_imageList.length}/5",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 7),
                        child: FutureBuilder(
                          future: convertAssetToByteData(_imageList[index]),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(),
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                );

                              default:
                                return ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: [
                                      Image(
                                        image: MemoryImage(
                                          snapshot.data,
                                        ),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 3,
                                        right: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              print("@@@@@@@@ 33333");
                                              _imageList.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(2.0),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    Widget title() {
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "물품명",
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: TextField(
              controller: _titleTextEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                counterText: "",
                hintText: "최대 20자까지 입력 가능",
              ),
              maxLength: 20,
            ),
          ),
        ],
      );
    }

    Widget price() {
      return Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "가격",
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 20),
          child: TextField(
            controller: _priceTextEditingController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              ThousandsFormatter(),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
              ),
              counterText: "",
              hintText: "가격을 입력해주세요",
            ),
            maxLength: 11,
          ),
        ),
      ]);
    }

    Widget category() {
      return Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "카테고리",
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 20),
          child: TextField(
            controller: _categoryTextEditingController,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductAddCategorySelect()),
              ).then((value) {
                if (value != null) {
                  _categoryTextEditingController.text = value;
                }
              });
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
              hintText: '카테고리를 선택해주세요',
              // isDense: true,
              suffixIcon: Icon(Icons.keyboard_arrow_right_rounded),
            ),
            readOnly: true,
          ),
        ),
      ]);
    }

    Widget explain() {
      return Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "설명",
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 20),
          child: TextField(
            keyboardType: TextInputType.multiline,
            minLines: 11,
            maxLines: null,
            controller: _explainTextEditingController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
              counterText: "",
              hintMaxLines: 2,
              hintText: "상세한 상품정보(사이즈, 색상, 사용기간 등)를 입력하면 더욱 수월하게 거래할 수 있습니다",
            ),
          ),
        ),
      ]);
    }

    Future<void> uploadProduct() async {
      if (_titleTextEditingController.text.trim() == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("물품명을 입력해주세요."),
        ));
      } else if (_priceTextEditingController.text.trim() == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("가격을 입력해주세요."),
        ));
      } else if (_categoryTextEditingController.text.trim() == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("카테고리를 선택해주세요."),
        ));
      } else if (_explainTextEditingController.text.trim() == "") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("설명을 입력해주세요."),
        ));
      } else if (_imageList.length < 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("물품을 등록하려면 한장 이상의 사진이 필요합니다."),
        ));
      } else {
        List _imgUriarr = [];

        for (var imaged in _imageList) {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child("productimage/${randomAlphaNumeric(15)}");
          UploadTask storageUploadTask = storageReference
              .putData((await imaged.getByteData()).buffer.asUint8List());
          await storageUploadTask.whenComplete(() async {
            String downloadURL = await storageReference.getDownloadURL();
            _imgUriarr.add(downloadURL);
          });
        }

        int time = DateTime.now().microsecondsSinceEpoch;
        FirebaseFirestore.instance
            .collection("products")
            .doc(time.toString())
            .set({
          'uid': googleSignIn.currentUser.id,
          'price': _priceTextEditingController.text,
          'title': _titleTextEditingController.text,
          'category': _categoryTextEditingController.text,
          'explain': _explainTextEditingController.text,
          'images': _imgUriarr,
          'favorites': 0,
          'hide': false,
          'deleted': false,
          'views': {},
          'uploadtime': time,
          'updatetime': time,
          'bumptime': time,
        }).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            content: Text("물품 등록이 완료되었습니다."),
          ));
          context.read(productMainService).fetchProducts();
          Navigator.pop(context);
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("물품 등록", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.check),
            onPressed: () => {
              uploadProduct(),
              // uploadProductDialog(),
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                images(),
                title(),
                price(),
                category(),
                explain(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
