import 'package:flutter/material.dart';

class CategoryItem {
  AssetImage image;
  String name;
  Map<String, dynamic> aa;

  CategoryItem({
    this.image,
    this.name,
    this.aa,
  });

  static Map<String, dynamic> get test => {
        "여성의류": {
          "image": AssetImage('icons/category/dress.png'),
          "list": ["원피스", "스커트/치마", "자켓", "니트/스웨터", "블라우스", "야상/점퍼/패딩"]
        },
        "남성의류": {
          "image": AssetImage('icons/category/man.png'),
          "list": ["트레이닝", "자켓", "니트/스웨터", "야상/점퍼/패딩", "셔츠/남방", "빅사이즈"]
        },
      };

  static List<CategoryItem> get headeritems => [
        CategoryItem(
            image: AssetImage('icons/category/dress.png'), name: "여성의류"),
        CategoryItem(
            image: AssetImage('icons/category/watch.png'), name: "패션잡화"),
        CategoryItem(image: AssetImage('icons/category/man.png'), name: "남성의류"),
        CategoryItem(
            image: AssetImage('icons/category/monitor.png'), name: "디지털/가전"),
        CategoryItem(
            image: AssetImage('icons/category/beauty.png'), name: "뷰티/미용"),
        CategoryItem(
            image: AssetImage('icons/category/interior.png'), name: "가구/인테리어"),
        CategoryItem(
            image: AssetImage('icons/category/sport.png'), name: "스포츠/레저"),
        CategoryItem(image: AssetImage('icons/category/pet.png'), name: "반려동물"),
        CategoryItem(
            image: AssetImage('icons/category/record.png'), name: "도서/음반"),
      ];

  static List<CategoryItem> get items => [
        CategoryItem(
            image: AssetImage('icons/category/dress.png'), name: "여성의류"),
        CategoryItem(
            image: AssetImage('icons/category/watch.png'), name: "패션잡화"),
        CategoryItem(image: AssetImage('icons/category/man.png'), name: "남성의류"),
        CategoryItem(
            image: AssetImage('icons/category/monitor.png'), name: "디지털/가전"),
        CategoryItem(
            image: AssetImage('icons/category/beauty.png'), name: "뷰티/미용"),
        CategoryItem(
            image: AssetImage('icons/category/interior.png'), name: "가구/인테리어"),
        CategoryItem(
            image: AssetImage('icons/category/sport.png'), name: "스포츠/레저"),
        CategoryItem(image: AssetImage('icons/category/pet.png'), name: "반려동물"),
        CategoryItem(
            image: AssetImage('icons/category/record.png'), name: "도서/음반"),
        CategoryItem(
            image: AssetImage('icons/category/ticket.png'), name: "티켓/쿠폰"),
        CategoryItem(
            image: AssetImage('icons/category/game.png'), name: "게임/취미"),
        CategoryItem(
            image: AssetImage('icons/category/gift.png'), name: "무료나눔"),
        CategoryItem(image: AssetImage('icons/category/tag.png'), name: "삽니다"),
      ];
}
