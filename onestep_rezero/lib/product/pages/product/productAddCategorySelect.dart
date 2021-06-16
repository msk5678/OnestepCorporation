import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/pages/product/productAddDetailCategorySelect.dart';

class ProductAddCategorySelect extends StatefulWidget {
  ProductAddCategorySelect({Key key}) : super(key: key);

  @override
  _ProductAddCategorySelectState createState() =>
      _ProductAddCategorySelectState();
}

Widget mainCategory() {
  return FutureBuilder(
    future: FirebaseFirestore.instance
        .collection("category")
        .orderBy("total", descending: true)
        .get(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Container();
        default:
          return ListView.builder(
            itemCount: snapshot.data.size,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  snapshot.data.docs[index].data()['detail'] == null
                      ? Navigator.of(context).pop(snapshot.data.docs[index].id)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductAddDetailCategorySelect(
                                    category: snapshot.data.docs[index]
                                        .data()['detail']),
                          ));
                },
                leading: Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Image.asset(
                        snapshot.data.docs[index].data()['image'],
                        width: 38,
                        height: 38)),
                title: Text(snapshot.data.docs[index].id),
                trailing: snapshot.data.docs[index].data()['detail'] == null
                    ? null
                    : Icon(Icons.arrow_forward_ios_rounded),
              );
            },
          );
      }
    },
  );
}

class _ProductAddCategorySelectState extends State<ProductAddCategorySelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "카테고리 선택",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: mainCategory(),
    );
  }
}
