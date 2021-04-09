import 'package:flutter/material.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

class ProductAdd extends StatelessWidget {
  const ProductAdd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleTextEditingController = TextEditingController();
    final _priceTextEditingController = TextEditingController();
    final _explainTextEditingController = TextEditingController();
    final _categoryTextEditingController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("물품 등록", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "물풀명",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    controller: _titleTextEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: '제목',
                      counterText: "",
                      hintText: "최대 20자까지 입력 가능",
                    ),
                    maxLength: 20,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "가격",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    controller: _priceTextEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      ThousandsFormatter(),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: "",
                      hintText: "가격을 입력해주세요",
                    ),
                    maxLength: 20,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "카테고리",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    controller: _categoryTextEditingController,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => CategoryWidget()),
                      // );
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '카테고리를 선택해주세요',
                      // isDense: true,
                      suffixIcon: Icon(Icons.keyboard_arrow_right_rounded),
                    ),
                    readOnly: true,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "설명",
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 8,
                    maxLines: null,
                    controller: _explainTextEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: "",
                      hintText:
                          "상세한 상품정보(사이즈, 색상, 사용기간 등)를 입력하면 더욱 수월하게 거래할 수 있습니다",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
