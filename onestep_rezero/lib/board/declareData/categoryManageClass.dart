import 'package:flutter/material.dart';

class CategoryException implements Exception {
  String cause;
  CategoryException(this.cause) {
    print(cause);
  }
}

//게시판 카테고리 관리
enum BoardCategory { POST, PICTURE, VOTE }

class BoardCategoryData {
  final icon;
  final String title;
  final String explain;
  BoardCategoryData({this.icon, this.title, this.explain});
}

extension BoardCategoryExtension on BoardCategory {
  BoardCategoryData get categoryData {
    switch (this) {
      case BoardCategory.POST:
        return BoardCategoryData(
            icon: Icons.post_add, title: "글", explain: "글 위주의 게시판");
      case BoardCategory.PICTURE:
        return BoardCategoryData(
            icon: Icons.photo_size_select_actual_outlined,
            title: "사진",
            explain: "사진 위주의 게시판");
      case BoardCategory.VOTE:
        return BoardCategoryData(
            icon: Icons.how_to_vote_outlined,
            title: "투표",
            explain: "투표 위주의 게시판");
      default:
        return throw CategoryException(
            "Enum Category Error, Please Update Enum ContentCategory categoryData in categoryManageClass.dart");
    }
  }

  String get boardCategoryName {
    switch (this) {
      case BoardCategory.PICTURE:
        return "PICTURE";
      case BoardCategory.POST:
        return "POST";
      case BoardCategory.VOTE:
        return "VOTE";
      default:
        return throw CategoryException(
            "Enum Category Error, Please Update Enum ContentCategory boardCategoryName in categoryManageClass.dart");
    }
  }
}

//포스트 카테고리 관리
enum ContentCategory { SMALLTALK, QUESTION }

class ContentCategoryData {
  final icon;
  final String title;
  ContentCategoryData({this.icon, this.title});
}

extension ContentCategoryExtension on ContentCategory {
  ContentCategoryData get categoryData {
    switch (this) {
      case ContentCategory.QUESTION:
        return ContentCategoryData(title: "질문", icon: Icons.help_outline);
      case ContentCategory.SMALLTALK:
        return ContentCategoryData(
            title: "일상", icon: Icons.emoji_emotions_outlined);
      default:
        return throw CategoryException(
            "Enum Category Error, Please Update Enum ContentCategory in parentState.dart");
    }
  }
}
