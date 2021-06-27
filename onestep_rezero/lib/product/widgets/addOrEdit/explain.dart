import 'package:flutter/material.dart';

class ProductAddOrEditExplainTextField extends StatefulWidget {
  final TextEditingController explainTextEditingController;
  ProductAddOrEditExplainTextField({Key key, this.explainTextEditingController})
      : super(key: key);

  @override
  _ProductAddOrEditExplainTextFieldState createState() =>
      _ProductAddOrEditExplainTextFieldState();
}

class _ProductAddOrEditExplainTextFieldState
    extends State<ProductAddOrEditExplainTextField> {
  @override
  Widget build(BuildContext context) {
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
          controller: widget.explainTextEditingController,
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
}
