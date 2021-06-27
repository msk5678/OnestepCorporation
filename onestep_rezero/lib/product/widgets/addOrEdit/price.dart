import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/utils/numericTextFormatter.dart';

class ProductAddOrEditPriceTextField extends StatefulWidget {
  final TextEditingController priceTextEditingController;
  ProductAddOrEditPriceTextField({Key key, this.priceTextEditingController})
      : super(key: key);

  @override
  _ProductAddPriceTextState createState() => _ProductAddPriceTextState();
}

class _ProductAddPriceTextState extends State<ProductAddOrEditPriceTextField> {
  @override
  Widget build(BuildContext context) {
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
          controller: widget.priceTextEditingController,
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
}
