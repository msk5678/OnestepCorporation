import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';

class MyinfoTransaction extends StatefulWidget {
  @override
  _MyinfoTransactionState createState() => _MyinfoTransactionState();
}

class _MyinfoTransactionState extends State<MyinfoTransaction> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '거래내역',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(child: Text("구매", style: TextStyle(color: Colors.black))),
                Tab(child: Text("판매", style: TextStyle(color: Colors.black))),
                Tab(child: Text("숨김", style: TextStyle(color: Colors.black))),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            purchaseTabView(),
            saleTabView(),
            hideTabView(),
          ]),
        ));
  }

  Widget purchaseTabView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("총 갯수"),
              ),
              GestureDetector(
                onTap: () {
                  print("필터 click");
                  showModalBottomSheet(
                      context: context,
                      builder: _filterBottomSheet,
                      isScrollControlled: false);
                },
                child: Row(
                  children: [
                    Icon(Icons.filter_alt_outlined),
                    Container(
                      child: Text("필터"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Text(""),
        ),
      ],
    );
  }

  Widget saleTabView() {
    return Center(
      child: Container(
        child: Text("판매"),
      ),
    );
  }

  Widget hideTabView() {
    return Center(
      child: Container(
        child: Text("숨김"),
      ),
    );
  }

  Widget _filterBottomSheet(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20))),
        height: MediaQuery.of(context).size.height / 2.3,
        child: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20, 0, 0, 0),
                    child: Text(
                      '기간',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRadioButton(
                    enableShape: true,
                    elevation: 0,
                    defaultSelected: "최신순",
                    enableButtonWrap: true,
                    width: MediaQuery.of(context).size.width / 3.3,
                    autoWidth: false,
                    unSelectedColor: Theme.of(context).canvasColor,
                    buttonLables: [
                      '최신순',
                      '최근 1년',
                      '6개월',
                      '3개월',
                      '1개월',
                      '1주일',
                    ],
                    buttonValues: [
                      '최신순',
                      '최근 1년',
                      '6개월',
                      '3개월',
                      '1개월',
                      '1주일',
                    ],
                    buttonTextStyle: ButtonTextStyle(
                        selectedColor: Colors.white,
                        unSelectedColor: Colors.black,
                        textStyle: TextStyle(fontSize: 16)),
                    radioButtonValue: (value) {
                      print(value);
                    },
                    selectedColor: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 20, 0, 0, 0),
                    child: Text(
                      '거래상태',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomRadioButton(
                    enableShape: true,
                    elevation: 0,
                    defaultSelected: "판매중",
                    enableButtonWrap: true,
                    width: MediaQuery.of(context).size.width / 3.3,
                    autoWidth: false,
                    unSelectedColor: Theme.of(context).canvasColor,
                    buttonLables: [
                      '판매중',
                      '판매완료',
                      '숨김',
                    ],
                    buttonValues: [
                      '판매중',
                      '판매완료',
                      '숨김',
                    ],
                    buttonTextStyle: ButtonTextStyle(
                        selectedColor: Colors.white,
                        unSelectedColor: Colors.black,
                        textStyle: TextStyle(fontSize: 16)),
                    radioButtonValue: (value) {
                      print(value);
                    },
                    selectedColor: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 15,
                    child: ElevatedButton(
                        onPressed: () {
                          print("조회하기 click");
                        },
                        child: Container(
                          child: Text("조회하기"),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
