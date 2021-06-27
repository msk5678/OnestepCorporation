import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/categorySelectItem.dart';
import 'package:onestep_rezero/product/pages/product/productAddCategorySelect.dart';

class ProductAddOrEditCategoryTextField extends StatefulWidget {
  final TextEditingController categoryTextEditingController;
  final TextEditingController detailCategoryTextEditingController;

  ProductAddOrEditCategoryTextField(
      {Key key,
      this.categoryTextEditingController,
      this.detailCategoryTextEditingController})
      : super(key: key);

  @override
  _ProductAddOrEditCategoryTextFieldState createState() =>
      _ProductAddOrEditCategoryTextFieldState();
}

class _ProductAddOrEditCategoryTextFieldState
    extends State<ProductAddOrEditCategoryTextField> {
  TextEditingController _combineCategoryTextEditingController =
      TextEditingController();
  CategorySelectItem categorySelectItem;
  @override
  void initState() {
    if (widget.categoryTextEditingController.text != "") {
      _combineCategoryTextEditingController.text =
          widget.categoryTextEditingController.text;
      if (widget.detailCategoryTextEditingController.text != "") {
        _combineCategoryTextEditingController.text =
            _combineCategoryTextEditingController.text +
                " > " +
                widget.detailCategoryTextEditingController.text;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          controller: _combineCategoryTextEditingController,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductAddCategorySelect()),
            ).then((value) {
              if (value != null) {
                categorySelectItem = value;
                widget.categoryTextEditingController.text =
                    categorySelectItem.category;
                widget.detailCategoryTextEditingController.text =
                    categorySelectItem.detailCategory;

                if (categorySelectItem.detailCategory == null) {
                  _combineCategoryTextEditingController.text =
                      categorySelectItem.category;
                } else {
                  _combineCategoryTextEditingController.text =
                      categorySelectItem.category +
                          " > " +
                          categorySelectItem.detailCategory;
                }
              }
            });
          },
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(),
              hintText: '카테고리를 선택해주세요',
              suffixIcon: Icon(Icons.keyboard_arrow_right_rounded,
                  color: Colors.black)),
          readOnly: true,
        ),
      ),
    ]);
  }
}
