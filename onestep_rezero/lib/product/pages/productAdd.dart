import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/pages/productAddCategorySelect.dart';
import 'package:onestep_rezero/product/utils/numericTextFormatter.dart';

import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:random_string/random_string.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({Key key}) : super(key: key);

  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  List<AssetEntity> entity = [];

  final _titleTextEditingController = TextEditingController();
  final _priceTextEditingController = TextEditingController();
  final _explainTextEditingController = TextEditingController();
  final _categoryTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickAssets() async {
    final List<AssetEntity> _entity = await AssetPicker.pickAssets(
      context,
      maxAssets: 5,
      pageSize: 330,
      pathThumbSize: 80,
      gridCount: 3,
      requestType: RequestType.image,
      selectedAssets: entity,
      specialPickerType: SpecialPickerType.wechatMoment,
      textDelegate: KoreaTextDelegate(),
    );

    if (_entity != null && entity.toString() != _entity.toString()) {
      entity = _entity;

      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget getImages() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        pickAssets();
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
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
                "${entity.length}/5",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageItem(int index, AssetEntity image) {
    return Padding(
      padding: EdgeInsets.only(left: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: [
            Image(
              width: 80,
              height: 80,
              image: AssetEntityImageProvider(image, isOriginal: false),
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 3,
              right: 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    entity.removeAt(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10, bottom: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              getImages(),
              ...entity
                  .asMap()
                  .map(
                    (i, element) => MapEntry(
                      i,
                      imageItem(i, element),
                    ),
                  )
                  .values
                  .toList(),
            ],
          ),
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
              hintText: "최대 50자까지 입력 가능",
            ),
            maxLength: 50,
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
          inputFormatters: [NumericTextFormatter()],
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
    } else if (entity.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("물품을 등록하려면 한장 이상의 사진이 필요합니다."),
      ));
    } else {
      List _imgUriarr = [];
      final Size size = MediaQuery.of(context).size;
      final double scale = MediaQuery.of(context).devicePixelRatio;

      for (var image in entity) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("productimage/${randomAlphaNumeric(15)}");

        Uint8List uint8list = await image.thumbDataWithSize(
          (size.width * scale).toInt(),
          (size.height * scale).toInt(),
        );

        UploadTask storageUploadTask = storageReference.putData(uint8list);
        await storageUploadTask.whenComplete(() async {
          String downloadURL = await storageReference.getDownloadURL();
          _imgUriarr.add(downloadURL);
        });
      }

      int time = DateTime.now().microsecondsSinceEpoch;
      FirebaseFirestore.instance
          .collection("university")
          .doc(currentUserModel.university)
          .collection("product")
          .doc(time.toString())
          .set({
        'uid': googleSignIn.currentUser.id,
        'imagesUrl': _imgUriarr,
        'title': _titleTextEditingController.text,
        'category': _categoryTextEditingController.text,
        'detailCategory': "",
        'price': _priceTextEditingController.text,
        'explain': _explainTextEditingController.text,
        'favoriteUserList': {},
        'chatUserList': [],
        'trading': false,
        'completed': false,
        'hide': false,
        'deleted': false,
        'reported': false,
        'views': {},
        'uploadTime': time,
        'updateTime': time,
        'bumpTime': time,
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

  @override
  Widget build(BuildContext context) {
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
