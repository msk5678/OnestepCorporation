class CategoryException implements Exception {
  String cause;
  CategoryException(this.cause) {
    print(cause);
  }
}

enum ContentCategory { SMALLTALK, QUESTION }

extension ContentCategoryExtension on ContentCategory {
  String get category {
    switch (this) {
      case ContentCategory.QUESTION:
        return "질문";
      case ContentCategory.SMALLTALK:
        return "일상";
      default:
        return throw CategoryException(
            "Enum Category Error, Please Update Enum ContentCategory in parentState.dart");
    }
  }
}
