import 'package:flutter/material.dart';

class ProductAddTitleTextField extends StatefulWidget {
  final TextEditingController titleTextEditingController;
  ProductAddTitleTextField({Key key, this.titleTextEditingController})
      : super(key: key);

  @override
  _ProductAddTitleTextFieldState createState() =>
      _ProductAddTitleTextFieldState();
}

class _ProductAddTitleTextFieldState extends State<ProductAddTitleTextField> {
  @override
  Widget build(BuildContext context) {
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
            controller: widget.titleTextEditingController,
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
}
