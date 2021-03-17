import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/timeUtil.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({Key key, @required this.product}) : super(key: key);

  Widget getImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: product.images[0],
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      errorWidget: (context, url, error) => Icon(Icons.error), // 로딩 오류 시 이미지
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _favoriteTextController =
        product.favoriteuserlist == null
            ? TextEditingController(text: "0")
            : TextEditingController(text: "${product.favoriteuserlist.length}");

    double coverSize = 110;

    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   '/DetailProduct',
        //   arguments: {"PRODUCTID": product.firestoreid},
        // ).then((value) {
        //   print("clothitem");
        // });
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                    getImage(context),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: coverSize / 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(100, 0, 0, 0)
                            ],
                          ),
                        ),
                      ),
                    ),
                    // setFavorite(),
                  ].where((item) => item != null).toList(),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            SizedBox(
              height: 15,
              child: Align(
                child: Row(
                  children: <Widget>[
                    Text(
                      "${product.price}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      "원",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(
              height: 14,
              child: Align(
                child: Text(
                  "${product.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF333333),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: <Widget>[
                _favoriteTextController.text == "0"
                    ? Container()
                    : Flexible(
                        child: SizedBox(
                          height: 14,
                          child: TextField(
                            controller: _favoriteTextController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.favorite_border_rounded,
                                  size: 12, color: Colors.grey),
                              prefixIconConstraints:
                                  BoxConstraints(minWidth: 12, minHeight: 12),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.bottom,
                            enableInteractiveSelection: false,
                            readOnly: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                Spacer(),
                Text(
                  TimeUtil.timeAgo(date: product.bumptime),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CachedNetworkImageProvider {}
