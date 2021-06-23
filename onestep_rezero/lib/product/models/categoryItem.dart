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
          "image": 'icons/category/dress.png',
          "detail": {
            "정장": 0,
            "원피스": 0,
            "자켓/코트": 0,
            "점퍼/패딩/야상": 0,
            "니트/스웨터/가디건": 0,
            "블라우스": 0,
            "셔츠/남방": 0,
            "조끼/베스트": 0,
            "티셔츠/캐쥬얼": 0,
            "맨투맨": 0,
            "레깅스": 0,
            "스커트/치마": 0,
            "바지/청바지/팬츠": 0,
            "트레이닝": 0,
            "빅사이즈": 0,
            "언더웨어/잠옷": 0,
            "이벤트/테마": 0
          },
          "total": 0,
        },
        "남성의류": {
          "image": 'icons/category/man.png',
          "detail": {
            "정장": 0,
            "자켓/코트": 0,
            "점퍼/패딩/야상": 0,
            "니트/스웨터/가디건": 0,
            "셔츠/남방": 0,
            "조끼/베스트": 0,
            "티셔츠/캐쥬얼": 0,
            "맨투맨": 0,
            "바지/청바지/팬츠": 0,
            "트레이닝": 0,
            "빅사이즈": 0,
            "언더웨어/잠옷": 0,
            "이벤트/테마": 0
          },
          "total": 0,
        },
        "뷰티/미용": {
          "image": 'icons/category/beauty.png',
          "detail": {
            "스킨케어": 0,
            "메이크업": 0,
            "향수": 0,
            "네일아트/케어": 0,
            "팩/필링/클렌징": 0,
            "헤어/바디": 0,
            "남성 화장품": 0,
            "가발": 0,
            "미용기기": 0,
            "기타 용품": 0,
          },
          "total": 0,
        },
        "패션잡화": {
          "image": 'icons/category/watch.png',
          "detail": {
            "여성가방": 0,
            "남성가방": 0,
            "스니커즈": 0,
            "악세서리/주얼리": 0,
            "안경/선글라스": 0,
            "시계": 0,
            "운동화": 0,
            "여성신발": 0,
            "남성신발": 0,
            "지갑/벨트": 0,
            "모자": 0,
            "기타": 0,
          },
          "total": 0,
        },
        "디지털기기": {
          "image": 'icons/category/monitor.png',
          "detail": {
            "카메라/캠코더": 0,
            "노트북": 0,
            "데스크탑/부품": 0,
            "키보드/마우스/스피커": 0,
            "모니터": 0,
            "복합기/프린터": 0,
            "허브/공유기": 0,
            "기타 디지털기기": 0,
          },
          "total": 0,
        },
        "가전": {
          "image": 'icons/category/monitor.png',
          "detail": {
            "TV": 0,
            "냉장고": 0,
            "세탁기/건조기": 0,
            "복사기/팩스": 0,
            "주방가전": 0,
            "영상/음향가전": 0,
            "공기청정기/가습기/제습기": 0,
            "에어컨/선풍기": 0,
            "히터/난방/온풍기": 0,
            "전기/온수매트": 0,
            "기타 가전제품": 0,
          },
          "total": 0,
        },
        "가구/인테리어": {
          "image": 'icons/category/interior.png',
          "detail": {
            "책상": 0,
            "의자": 0,
            "침대/매트리스": 0,
            "침구": 0,
            "수납/선반": 0,
            "조명/무드등": 0,
            "인테리어 소품": 0,
            "시계/액자": 0,
            "디퓨저/캔들": 0,
            "기타": 0,
          },
          "total": 0,
        },
        "스포츠": {
          "image": 'icons/category/sport.png',
          "detail": {
            "골프": 0,
            "자전거": 0,
            "전동/인라인/스케이트": 0,
            "축구": 0,
            "야구": 0,
            "농구": 0,
            "수상스포츠": 0,
            "헬스/요가/필라테스": 0,
            "검도/권투/격투": 0,
            "기타 스포츠": 0,
          },
          "total": 0,
        },
        "레저/캠핑/여행": {
          "image": 'icons/category/sport.png',
          "detail": {
            "텐트/침낭": 0,
            "취사용품": 0,
            "낚시용품": 0,
            "등산용품": 0,
            "기타용품": 0,
          },
          "total": 0,
        },
        "반려동물": {
          "image": 'icons/category/pet.png',
          "detail": {
            "강아지용품": 0,
            "고양이용품": 0,
            "관상어용품": 0,
            "기타 반려동물 용품": 0,
          },
          "total": 0,
        },
        "도서": {
          "image": 'icons/category/record.png',
          "detail": {
            "대학교재": 0,
            "학습/참고서": 0,
            "컴퓨터/인터넷": 0,
            "국어/외국어": 0,
            "수험서/자격증": 0,
            "소설": 0,
            "만화": 0,
            "여행/취미/레저": 0,
            "잡지": 0,
            "기타 도서": 0,
          },
          "total": 0,
        },
        "음반/굿즈": {
          "image": 'icons/category/record.png',
          "detail": {
            "CD": 0,
            "DVD": 0,
            "LP/기타음반": 0,
            "스타굿즈": 0,
            "기타": 0,
          },
          "total": 0,
        },
        "티켓/쿠폰": {
          "image": 'icons/category/ticket.png',
          "detail": {
            "기프티콘/쿠폰": 0,
            "상품권": 0,
            "티켓/항공권": 0,
          },
          "total": 0,
        },
        "게임": {
          "image": 'icons/category/game.png',
          "detail": {
            "PC게임": 0,
            "플레이스테이션": 0,
            "XBOX": 0,
            "PSP": 0,
            "닌텐도": 0,
            "Wii": 0,
            "기타 게임": 0,
          },
          "total": 0,
        },
        "취미": {
          "image": 'icons/category/game.png',
          "detail": {
            "예술/악기": 0,
            "수공예품": 0,
            "골동품/수집품": 0,
            "키덜트": 0,
            "기타 취미용품": 0,
          },
          "total": 0,
        },
        "원룸/숙소": {
          "image": 'icons/category/game.png',
          "detail": {},
          "total": 0,
        },
        "무료나눔": {
          "image": 'icons/category/gift.png',
          "detail": {},
          "total": 0,
        },
        "기타": {
          "image": 'icons/category/tag.png',
          "detail": {},
          "total": 0,
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
