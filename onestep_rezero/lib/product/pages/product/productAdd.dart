import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

import 'package:onestep_rezero/product/widgets/addOrEdit/category.dart';
import 'package:onestep_rezero/product/widgets/addOrEdit/explain.dart';
import 'package:onestep_rezero/product/widgets/addOrEdit/price.dart';
import 'package:onestep_rezero/product/widgets/addOrEdit/title.dart';

import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:onestep_rezero/utils/floatingSnackBar.dart';

import 'package:onestep_rezero/utils/imageCompress.dart';
import 'package:onestep_rezero/utils/onestepCustom/dialog/onestepCustomDialog.dart';
import 'package:random_string/random_string.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final _detailCategoryTextEditingController = TextEditingController();

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
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0.w, color: Colors.grey),
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
              size: 30.sp,
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
              width: 80.w,
              height: 80.h,
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
                      size: 15.sp,
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
            "상품 사진",
          ),
        ),
        Container(
          height: 80.h,
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

  Future<void> uploadProduct() async {
    if (entity.length < 1) {
      FloatingSnackBar.show(context, "상품을 등록하려면 한장 이상의 사진이 필요합니다.");
    } else if (_titleTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "상품명을 입력해주세요.");
    } else if (_priceTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "가격을 입력해주세요.");
    } else if (_categoryTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "카테고리를 선택해주세요.");
    } else if (_explainTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "설명을 입력해주세요.");
    } else {
      OnestepCustomDialog.show(
        context,
        title: "상품 등록을 하시겠습니까?",
        confirmButtonText: "확인",
        cancleButtonText: "취소",
        confirmButtonOnPress: () async {
          List _imgUriarr = [];

          for (var image in entity) {
            Reference storageReference = FirebaseStorage.instance
                .ref()
                .child("productimage/${randomAlphaNumeric(15)}");

            Uint8List uint8list =
                await ImageCompress.assetCompressFile(await image.originFile);

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
            'uid': currentUserModel.uid,
            'imagesUrl': _imgUriarr,
            'title': _titleTextEditingController.text,
            'category': _categoryTextEditingController.text,
            'detailCategory': _detailCategoryTextEditingController.text,
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
            FloatingSnackBar.show(context, "상품 등록이 완료되었습니다.");
            context.read(productMainService).fetchProducts();
            Navigator.pop(context);
            Navigator.pop(context);
          });
        },
      );
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
        title: Text("상품 등록", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                images(),
                ProductAddTitleTextField(
                    titleTextEditingController: _titleTextEditingController),
                ProductAddOrEditPriceTextField(
                    priceTextEditingController: _priceTextEditingController),
                ProductAddOrEditCategoryTextField(
                    categoryTextEditingController:
                        _categoryTextEditingController,
                    detailCategoryTextEditingController:
                        _detailCategoryTextEditingController),
                ProductAddOrEditExplainTextField(
                    explainTextEditingController:
                        _explainTextEditingController),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () => uploadProduct(),
        child: Container(
          height: 60.h,
          color: OnestepColors().mainColor,
          child: Center(
            child: Text(
              "등록완료",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
