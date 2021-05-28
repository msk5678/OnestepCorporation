import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/main.dart';
import 'package:onestep_rezero/product/models/categoryItem.dart';
import 'package:onestep_rezero/product/pages/categoryDetail.dart';

final categoryStateProvider = StateProvider<bool>((ref) {
  return false;
});

class ProductMainHeader extends ConsumerWidget {
  const ProductMainHeader({Key key}) : super(key: key);

  Widget allCategory(BuildContext context) {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: (MediaQuery.of(context).size.width * 0.0025),
        crossAxisSpacing: 1.0,
      ),
      shrinkWrap: true,
      children: [
        ...CategoryItem.items
            .map(
              (item) => InkWell(
                splashColor: Colors.red,
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => Consumer<CategoryProuductProvider>(
                  //       builder: (context, prouductProvider, _) =>
                  //           ClothCategoryWidget(
                  //         productProvider: prouductProvider,
                  //         category: item.name,
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Image(image: item.image, width: 45, height: 45)),
                    Text(item.name, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            )
            .toList(),
        GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Icon(Icons.arrow_drop_up, size: 45)),
              Text("접기", style: TextStyle(fontSize: 12)),
            ],
          ),
          onTap: () {
            context.read(categoryStateProvider).state =
                !context.read(categoryStateProvider).state;
          },
        ),
      ],
    );
  }

  Widget categoryItem(QueryDocumentSnapshot data) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Image.asset(data['image'], width: 45, height: 45)),
        Text(data.id, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget header(BuildContext context) {
    return FutureBuilder(
        future: categoryList,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio:
                        (MediaQuery.of(context).size.width * 0.0025),
                    crossAxisSpacing: 1.0,
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: Colors.red,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CategoryDetail(
                              category: snapshot.data.docs[index].id,
                            ),
                          ),
                        );
                      },
                      child: categoryItem(snapshot.data.docs[index]),
                    );
                  });
          }
        });

    return GridView(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: (MediaQuery.of(context).size.width * 0.0025),
        crossAxisSpacing: 1.0,
      ),
      shrinkWrap: true,
      children: [
        ...CategoryItem.headeritems
            .map(
              (item) => InkWell(
                splashColor: Colors.red,
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => Consumer<CategoryProuductProvider>(
                  //       builder: (context, prouductProvider, _) =>
                  //           ClothCategoryWidget(
                  //         productProvider: prouductProvider,
                  //         category: item.name,
                  //       ),
                  //     ),
                  //   ),
                  // );
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Image(image: item.image, width: 45, height: 45)),
                    Text(item.name, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            )
            .toList(),
        GestureDetector(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Icon(Icons.add, size: 45)),
              Text("더보기", style: TextStyle(fontSize: 12)),
            ],
          ),
          onTap: () {
            context.read(categoryStateProvider).state =
                !context.read(categoryStateProvider).state;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final categoryboll = watch(categoryStateProvider);

    return Column(
      children: <Widget>[
        categoryboll.state ? allCategory(context) : header(context),
      ],
    );
  }
}
