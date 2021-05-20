import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/myinfo/providers/providers.dart';

// ignore: must_be_immutable
class NickNameChangeBody extends ConsumerWidget {
  String _tempNickName;
  bool _firstEnter;

  NickNameChangeBody(this._tempNickName, this._firstEnter);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final TextEditingController _nicknameController =
        TextEditingController(text: _tempNickName);
    _nicknameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nicknameController.text.length));
    final _isNickNameCheck = watch(myinfoProvider.state);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.width / 20, 0, 0),
            child: Center(
              child: Container(
                child: Text(
                  "새로운 닉네임을 입력해주세요.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.width / 30, 0, 0),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextField(
                maxLength: 8,
                controller: _nicknameController,
                onChanged: (text) {
                  _tempNickName = text;
                },
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "닉네임",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              (_firstEnter == true || _isNickNameCheck == true)
                                  ? Colors.grey
                                  : Colors.red)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              (_firstEnter == true || _isNickNameCheck == true)
                                  ? Colors.grey
                                  : Colors.red)),
                  suffix: _isNickNameCheck
                      ? GestureDetector(
                          child: Text("확인완료"),
                          onTap: () {
                            context
                                .read(myinfoProvider)
                                .authEmailNickNameCheck(_tempNickName);
                            _firstEnter = false;
                          },
                        )
                      : GestureDetector(
                          child: Text("중복확인"),
                          onTap: () {
                            context
                                .read(myinfoProvider)
                                .authEmailNickNameCheck(_tempNickName);
                            _firstEnter = false;
                          },
                        ),
                ),
              ),
            ),
          ),
          Offstage(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  0,
                  (MediaQuery.of(context).size.height / 40),
                  (MediaQuery.of(context).size.width / 4),
                  0),
              child: Text(
                "닉네임이 중복이거나 잘못된 형식입니다.",
                style: TextStyle(color: Colors.red),
              ),
            ),
            offstage:
                _firstEnter == true || _isNickNameCheck == true ? true : false,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.width / 30, 0, 0),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                child: Text(
                  "변경하기",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: _isNickNameCheck == true
                    ? () {
                        // FirebaseFirestore.instance
                        //     .collection("users")
                        //     .doc(FirebaseApi.getId())
                        //     .update({"nickName": resultNickName});
                        _tempNickName = "";
                        _firstEnter = true;
                        Navigator.of(context).pop();
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
