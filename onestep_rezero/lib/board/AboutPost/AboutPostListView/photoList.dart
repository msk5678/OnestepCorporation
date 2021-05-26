import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:transparent_image/transparent_image.dart';

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
            // 50,
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

  buildPhotoGridView(PostData postData) {
    String imageURL =
        postData.imageCommentMap.values.toList()[0].toString() ?? "";
    String parseURL = imageURL.substring(1, imageURL.length - 1);
    // return Image(
    //   image: new CachedNetworkImageProvider(parseURL,),
    // );
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: CachedNetworkImageProvider(
            parseURL,
            // placeholder: (context, url) => CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

  // return FutureBuilder<dynamic>(
  //     future: _findPath(parseURL),
  //     initialData: Center(
  //       child: Icon(Icons.cancel_outlined),
  //     ),
  //     builder: (context, snapshot) {
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //         case ConnectionState.none:
  //           return CupertinoActivityIndicator();
  //         default:
  //           if (snapshot.hasError) {
  //             return GestureDetector(
  //                 onTap: () {
  //                   setState(() {
  //                     _findPath(parseURL);
  //                   });
  //                 },
  //                 child: Center(child: Icon(Icons.cached)));
  //           } else {
  //             return snapshot.data;
  //           }
  //       }
  //     });

}

// final file = await DefaultCacheManager().getSingleFile(parseURL);

// print("DefaultCacheManager().getImageFile(imageURL, withProgress: true)" +
//     DefaultCacheManager()
//         .getImageFile(parseURL, withProgress: true)
//         .toString());
// String filePath  = _findPath(parseURL);

// return Container(
//   color: Colors.black,

// Future getImage(String url) async {
//   var file = DefaultCacheManager().getImageFile(url);
// }

// _findPath(String imageUrl) async {
//   final file = await DefaultCacheManager().getSingleFile(imageUrl);
//   // return file.path;
//   // return Future.error("Error");
//   // return Future.delayed(Duration(seconds: 3)).then((value) {
//   //   return Future.error("error");
//   // });
//   // print("file Path :" + file.path.toString());
//   // var image = decodeJpg(File(file.path).readAsBytesSync());
//   // Image image = decodeJpg(File(file.path), fileName));
//   // return file.path;

//   // return Container(
//   //   color: Colors.black,
//   // );
//   ByteData data = await PlatformAssetBundle().load(file.path);

//   return ConvertImages(
//     asset: data,
//     height: null,
//     width: null,
//   );
//   return Image.file(File(file.path));
//   // return SizedBox(
//   //   height: 50,
//   //   width: 50,
//   //   child: Image.asset(file.path),
//   // );

//   // CachedNetworkImage(
//   //   imageUrl: element.toString(),
//   //   placeholder: (context, url) => CupertinoActivityIndicator(),
//   //   errorWidget: (context, url, error) => Icon(Icons.error),
//   // ).fadeInDuration(Duration(seconds: 1));
// }
