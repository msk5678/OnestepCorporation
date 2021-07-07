import 'package:flutter/material.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/search/pages/searchContent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchMain extends StatefulWidget {
  final int searchKey;
  final String searchText;
  SearchMain({Key key, @required this.searchKey, this.searchText})
      : super(key: key);

  @override
  _SearchMainState createState() => _SearchMainState();
}

class _SearchMainState extends State<SearchMain> {
  TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(
        text: widget.searchText == null ? "" : widget.searchText);
    super.initState();
  }

  Widget aaBody() {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> search =
                (snapshot.data.getStringList('latestSearch') ?? []);
            return ListView.builder(
              itemCount: search.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchContent(
                            searchKey: widget.searchKey,
                            searchText: search[index]),
                      ),
                    );
                  },
                  title: Text(search[index]),
                  trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _removeLatestSearch(search[index]);
                        });
                      }),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }

  Widget aa() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("최근 검색어"),
              ),
              GestureDetector(
                onTap: () {
                  // Provider.of<AppDatabase>(context, listen: false)
                  //     .searchsDao
                  //     .deleteAllSearch();
                  // setState(() {
                  //   _textController.clear();
                  // });
                },
                child: Container(
                  child: Text("모두 삭제"),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: aaBody()),
      ],
    );
  }

  _removeLatestSearch(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> search = (prefs.getStringList('latestSearch') ?? []);

    search.removeWhere((element) => element == text);

    await prefs.setStringList('latestSearch', search);
  }

  Widget appBar() {
    return AppBar(
      elevation: 0.5,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Container(
                height: 40.h,
                child: TextField(
                  onTap: () {},
                  cursorColor: OnestepColors().mainColor,
                  autofocus: true,
                  controller: _textController,
                  onSubmitted: (text) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchContent(
                            searchKey: widget.searchKey, searchText: text),
                      ),
                    );
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: OnestepColors().mainColor, width: 2.0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: OnestepColors().mainColor, width: 2.0.w)),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Icon(
                        Icons.search,
                        color: OnestepColors().mainColor,
                      ),
                    ),
                    suffixIcon: _textController.text != ""
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                color: OnestepColors().mainColor),
                            onPressed: () {
                              _textController.clear();
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "검색어를 입력해주세요.",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottom: appBarBottom(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: aa(),
    );
  }
}
