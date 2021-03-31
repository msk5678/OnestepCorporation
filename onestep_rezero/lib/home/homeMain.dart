import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  search() async {
    List<AlgoliaObjectSnapshot> _results = [];

    Algolia algolia = Algolia.init(
      applicationId: 'SM0LVJM1EL',
      apiKey: '67bfc3f1aa7f241789e0a88b2c90a3b9',
    );

    AlgoliaQuery query = algolia.instance.index('products');
    query = query.query("duck");

    _results = (await query.getObjects()).hits;

    print("@@@@@@@@@@@@ length : ${_results.length}");
    _results.forEach((e) => print("@@@@@@@@@ data : ${e.data}"));
  }

  Widget a() {
    search();
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SearchAllMain(searchKey: 0)),
              ),
            },
          ),
        ],
      ),
      body: a(),
    );
  }
}
