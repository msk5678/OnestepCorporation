import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoList extends ConsumerWidget {
  final List<PostData> photoList;
  PhotoList({this.photoList});
  @override
  Widget build(BuildContext context, ScopedReader scopedReader) {
    int columnCount = 4;

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: columnCount,
      itemCount: photoList.length,
      itemBuilder: (context, index) {
        return buildPhotoGridView(photoList[index]);
      },
      staggeredTileBuilder: _getStaggeredTile,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
    );
  }

  //   return Container(
  //     child: AnimationLimiter(
  //       child: GridView.count(
  //         shrinkWrap: true,
  //         physics: NeverScrollableScrollPhysics(),
  //         crossAxisCount: columnCount,
  //         children: List.generate(
  //           photoList.length,
  //           // 50,
  //           (int index) {
  //             return AnimationConfiguration.staggeredGrid(
  //               position: index,
  //               duration: const Duration(milliseconds: 375),
  //               columnCount: columnCount,
  //               child: ScaleAnimation(
  //                 child: FadeInAnimation(
  //                   child: buildPhotoGridView(photoList[index]),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
  StaggeredTile _getStaggeredTile(int i) {
    return i >= photoList.length ? null : StaggeredTile.count(2, 2);
  }

  buildPhotoGridView(PostData postData) {
    String imageURL =
        postData.imageCommentMap.values.toList()[0].toString() ?? "";
    String parseURL = imageURL.substring(1, imageURL.length - 1);

    return GestureDetector(
      onTap: () {},
      child: Center(
        child: FadeInImage(
          fit: BoxFit.fill,
          placeholder: MemoryImage(kTransparentImage),
          image: CachedNetworkImageProvider(
            parseURL,
            // placeholder: (context, url) => CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

  cacheManager() {
    // final file = await DefaultCacheManager().getSingleFile(parseURL);
    //  final file = await DefaultCacheManager().getSingleFile(imageUrl);
//   // return file.path;
//   // return Future.error("Error");
//   // return Future.delayed(Duration(seconds: 3)).then((value) {
//   //   return Future.error("error");
//   // });
//   // print("file Path :" + file.path.toString());
//   // var image = decodeJpg(File(file.path).readAsBytesSync());
//   // Image image = decodeJpg(File(file.path), fileName));
//   // return file.path;
  }
}
