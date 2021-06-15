import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';

class PhotoList extends ConsumerWidget {
  final List<PostData> photoList;
  PhotoList({this.photoList});
  @override
  Widget build(BuildContext context, ScopedReader scopedReader) {
    int columnCount = 3;

    return Container(
      child: AnimationLimiter(
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: columnCount,
          children: List.generate(
            photoList.length,
            (int index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: columnCount,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: buildPhotoGridView(photoList[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildPhotoGridView(PostData postData) {
    return Container();
    // String imageURL =
    //     postData.imageCommentMap.values.toList()[0].toString() ?? "";
    // return DefaultCacheManager().getImageFile(imageURL, withProgress: true);
  }

  // Future getImage(String url) async {
  //   var file = DefaultCacheManager().getImageFile(url);
  // }
}
