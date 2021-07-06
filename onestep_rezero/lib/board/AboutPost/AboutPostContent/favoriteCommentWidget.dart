import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/boardMain.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class FavoriteButton extends ConsumerWidget {
  final PostData currentPost;
  final clickCallback;

  FavoriteButton({this.currentPost, this.clickCallback});

  @override
  Widget build(BuildContext context, watch) {
    final provider = watch(userBoardDataProvider);
    final currentUid = currentUserModel.uid;
    bool fetching = provider.isFetching;
    bool isClicked =
        provider.userFavoritePostMap.containsKey(currentPost.documentId);
    return GestureDetector(
      onTap: () async {
        if (!fetching) {
          await provider.updateFavorite(currentPost, currentUid, isClicked);
          provider.getUserFavoriteList(currentUid);
          clickCallback(isClicked);
        }
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.centerLeft,
          child: Icon(
            isClicked ? Icons.favorite : Icons.favorite_border,
            // color: !fetching ? OnestepColors().mainColor : Colors.grey,
            color: OnestepColors().mainColor,
          )),
    );
  }
}

// class FavoriteCountWidget extends ConsumerWidget {
//   final PostData postData;
//   FavoriteCountWidget({this.postData});

//   @override
//   Widget build(BuildContext context, watch) {
//     final provider = watch(favoriteProvider);
//     final uid = currentUserModel.uid;
//     provider.setPostData(postData);
//     PostData currentPost = provider.latestPostData;
//     Map<String, dynamic> favoriteMap = currentPost.favoriteUserList;
//     bool userLiked = favoriteMap.containsKey(uid);

//     bool fetching = provider.isFetching;
//     bool userWrittenComment = currentPost.commentUserList.containsKey(uid);
//     return Row(
//       children: [
//         Icon(
//           //foot icon
//           userWrittenComment ? Icons.comment : Icons.comment_outlined,
//           size: 20,
//           color: OnestepColors().mainColor,
//         ),
//         Container(
//           margin: EdgeInsets.only(right: 5),
//           child: Text(!fetching ? "${currentPost.commentCount}" : 0,
//               style: TextStyle(color: Colors.grey, fontSize: 10)),
//         ),
//         Icon(
//           //foot icon
//           userLiked ? Icons.favorite : Icons.favorite_border,
//           size: 20,
//           color: OnestepColors().mainColor,
//         ),
//         Container(
//           margin: EdgeInsets.only(right: 5),
//           child: Text(!fetching ? "${favoriteMap.keys.length}" : 0,
//               style: TextStyle(color: Colors.grey, fontSize: 10)),
//         ),
//         Icon(
//           //foot icon
//           Icons.remove_red_eye,
//           size: 20,
//           color: OnestepColors().mainColor,
//         ),
//         Container(
//           margin: EdgeInsets.only(right: 5),
//           child: Text(!fetching ? "${currentPost.views.keys.length}" : 0,
//               style: TextStyle(color: Colors.grey, fontSize: 10)),
//         ),
//       ],
//     );
//   }
// }
