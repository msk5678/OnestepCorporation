import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/floatingSnackBar.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

import 'package:onestep_rezero/onestepCustomDialog.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/product/productAddCategorySelect.dart';
import 'package:onestep_rezero/product/widgets/addOrEdit/category.dart';
import 'package:onestep_rezero/product/widgets/addOrEdit/explain.dart';
import 'package:onestep_rezero/product/widgets/addOrEdit/price.dart';
import 'package:onestep_rezero/product/widgets/addOrEdit/title.dart';
import 'package:onestep_rezero/product/widgets/main/productMainBody.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductEdit extends StatefulWidget {
  final Product product;
  ProductEdit({Key key, this.product}) : super(key: key);

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  List<AssetEntity> entity = [];
  List<dynamic> _initImagesUrl;

  TextEditingController _titleTextEditingController;
  TextEditingController _priceTextEditingController;
  TextEditingController _explainTextEditingController;
  TextEditingController _categoryTextEditingController;
  TextEditingController _detailCategoryTextEditingController;

  @override
  void initState() {
    _initImagesUrl = widget.product.imagesUrl;

    _titleTextEditingController =
        TextEditingController(text: widget.product.title);
    _priceTextEditingController =
        TextEditingController(text: widget.product.price);
    _explainTextEditingController =
        TextEditingController(text: widget.product.explain);
    _categoryTextEditingController =
        TextEditingController(text: widget.product.category);
    _detailCategoryTextEditingController =
        TextEditingController(text: widget.product.detailCategory);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Uint8List> assetCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 30,
    );

    return result;
  }

  Future<void> pickAssets() async {
    final List<AssetEntity> _entity = await AssetPicker.pickAssets(
      context,
      maxAssets: 5 - _initImagesUrl.length,
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
                "${entity.length + _initImagesUrl.length}/5",
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
              ..._initImagesUrl.map(
                (image) => Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: image,
                          width: 80,
                          height: 80,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error), // 로딩 오류 시 이미지

                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 3,
                          right: 3,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _initImagesUrl.remove(image);
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
                ),
              ),
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

  Future<void> updateProduct() async {
    if (entity.length + _initImagesUrl.length < 1) {
      FloatingSnackBar.show(context, "물품을 등록하려면 한장 이상의 사진이 필요합니다.");
    } else if (_titleTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "물품명을 입력해주세요.");
    } else if (_priceTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "가격을 입력해주세요.");
    } else if (_categoryTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "카테고리를 선택해주세요.");
    } else if (_explainTextEditingController.text.trim() == "") {
      FloatingSnackBar.show(context, "설명을 입력해주세요.");
    } else {
      List _imgUriarr = [];

      _imgUriarr.addAll(_initImagesUrl);

      for (var image in entity) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("productimage/${DateTime.now().microsecondsSinceEpoch}");

        Uint8List uint8list = await assetCompressFile(await image.originFile);

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
          .doc(widget.product.firestoreid)
          .update({
        'imagesUrl': _imgUriarr,
        'title': _titleTextEditingController.text,
        'category': _categoryTextEditingController.text,
        'detailcategory': "",
        'price': _priceTextEditingController.text,
        'explain': _explainTextEditingController.text,
        'updateTime': time,
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("물품 수정이 완료되었습니다."),
        ));
        context.read(productMainService).fetchProducts();
        Navigator.pop(context, "OK");
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
        title: Text("물품 수정", style: TextStyle(color: Colors.black)),
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
        onTap: () {
          OnestepCustomDialog.show(
            context,
            title: '상품을 수정하시겠습니까?',
            cancleButtonText: '취소',
            confirmButtonText: '확인',
            confirmButtonOnPress: () {
              updateProduct();
              Navigator.pop(context);
            },
          );
        },
        child: Container(
          height: 60,
          color: OnestepColors().mainColor,
          child: Center(
            child: Text(
              "수정완료",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
