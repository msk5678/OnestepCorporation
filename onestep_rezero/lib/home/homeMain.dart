import 'package:flutter/material.dart';
import 'package:onestep_rezero/search/pages/searchAllMain.dart';

class HomeMain extends StatefulWidget {
  HomeMain({Key key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
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
      body: Container(),
    );
  }
}
