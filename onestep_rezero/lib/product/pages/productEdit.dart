import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/pages/productAddCategorySelect.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

class ProductEdit extends StatefulWidget {
  final Product product;
  ProductEdit({Key key, this.product}) : super(key: key);

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  List<dynamic> _initImagesUrl;
  List<Asset> imagesUrl;
  int _imageCount;
  TextEditingController _titleTextEditingController;
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _explainTextEditingController = TextEditingController();
  TextEditingController _categoryTextEditingController =
      TextEditingController();

  @override
  void initState() {
    _initImagesUrl = widget.product.imagesUrl;
    _imageCount = _initImagesUrl.length;
    _titleTextEditingController =
        TextEditingController(text: widget.product.title);
    _priceTextEditingController =
        TextEditingController(text: widget.product.price);
    _explainTextEditingController =
        TextEditingController(text: widget.product.explain);
    _categoryTextEditingController =
        TextEditingController(text: widget.product.category);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getImages() async {
    List<Asset> _resultList = <Asset>[];

    _resultList = await MultiImagePicker.pickImages(
      maxImages: 5 - _imageCount,
      enableCamera: true,
      selectedAssets: imagesUrl,
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
      _imageCount = _initImagesUrl.length + _resultList.length;
      imagesUrl = _resultList;
    });
  }

  Widget imageMerge() {
    return Container();
    List<Widget> result1 = _initImagesUrl
        .map(
          (data) => Padding(
            padding: EdgeInsets.only(left: 7),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: data,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
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
                          _initImagesUrl.remove(data);
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
                            size: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    // List<Widget> result2 = imagesUrl
    //     .map(
    //       (data) => Padding(
    //         padding: EdgeInsets.only(left: 7),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //           child: Stack(
    //             children: [
    //               Image(
    //                 image: MemoryImage(
    //                   data,
    //                 ),
    //                 width: 80,
    //                 height: 80,
    //                 fit: BoxFit.cover,
    //               ),
    //               Positioned(
    //                 top: 3,
    //                 right: 3,
    //                 child: GestureDetector(
    //                   onTap: () {
    //                     setState(() {
    //                       _initImagesUrl.remove(data);
    //                     });
    //                   },
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(100),
    //                       color: Color.fromRGBO(0, 0, 0, 0.5),
    //                     ),
    //                     child: Padding(
    //                       padding: EdgeInsets.all(2.0),
    //                       child: Icon(
    //                         Icons.close,
    //                         color: Colors.white,
    //                         size: 13,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     )
    //     .toList();
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
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ), //       <--- BoxDecoration here
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
                        "$_imageCount/5",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: imageMerge(),
            )
          ],
        )
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
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.check),
            onPressed: () => {
              // uploadProduct(),
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
