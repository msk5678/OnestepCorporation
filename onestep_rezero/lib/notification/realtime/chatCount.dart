import 'package:flutter/material.dart';

//계산을 위한 챗 카운트 , 파이어베이스 저장 -> 연산 후에 저장

//#1. count provider 메인에 선언
//#2. 챗 메인 - 챗페이지 빌드 전에 count init
//3. 빌더 돌 때마다 += 연산해서 최종 값 출력

//대안 : 채팅방 개수 카운트 프로바이더로 넘겨줘서 카운트 끝나면 Firebase DB에 저장
//혹은 DB 값 있을 경우 초기 세팅을 디비 값 읽어온걸로 세팅

class ChatCount with ChangeNotifier {
  int productChatCount = 0; //장터 챗 카운트
  int boardChatCount = 0; //일반 게시판 챗 카운트

  ChatCount({this.productChatCount, this.boardChatCount});

  //빌드 전에 각 카운트 초기화;
  void initChatCount() {
    productChatCount = 0;
    boardChatCount = 0;
    notifyListeners();
    print("ChatCount Init : pro : $productChatCount / boa : $boardChatCount");
  }

  void prints() {
    print("ChatCount print");
  }

  //장터
  void setProductChatCount(int count) {
    productChatCount += count;
    print("ChatCount get P : pro : $productChatCount / boa : $boardChatCount");
    notifyListeners();
  }

  int getProductChatCount() {
    print("ChatCount get P : pro : $productChatCount / boa : $boardChatCount");
    notifyListeners();
    return productChatCount;
  }

  //일반게시판
  void setBoardChatCount(int count) {
    productChatCount += count;
    print("ChatCount set B: pro : $productChatCount / boa : $boardChatCount");
    notifyListeners();
  }

  int getBoardChatCount() {
    print("ChatCount get B : pro : $productChatCount / boa : $boardChatCount");
    notifyListeners();
    return boardChatCount;
  }
}
