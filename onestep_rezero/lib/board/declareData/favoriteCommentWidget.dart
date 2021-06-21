import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/board/StateManage/Provider/favoriteProvider.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/chat/widget/appColor.dart';
import 'package:onestep_rezero/main.dart';

final favoriteProvider =
    ChangeNotifierProvider<FavoriteProvider>((ref) => FavoriteProvider());

class FavoriteButton extends ConsumerWidget {
  final PostData postData;

  FavoriteButton({this.postData});

  @override
  Widget build(BuildContext context, watch) {
    final provider = watch(favoriteProvider);
    final uid = currentUserModel.uid;
    provider.setPostData(postData);
    PostData currentPost = provider.latestPostData;
    Map<String, dynamic> favoriteMap = currentPost.favoriteUserList;
    bool isClicked = favoriteMap.containsKey(uid);
    bool fetching = provider.isFetching;
    return GestureDetector(
        onTap: () {
          if (!fetching) provider.updateFavorite(currentPost, uid, isClicked);
        },
        child: Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            child: Icon(
              isClicked ? Icons.favorite : Icons.favorite_border,
              color: !fetching ? OnestepColors().mainColor : Colors.grey,
            )));
  }
}

class FavoriteCountWidget extends ConsumerWidget {
  final PostData postData;
  FavoriteCountWidget({this.postData});

  @override
  Widget build(BuildContext context, watch) {
    final provider = watch(favoriteProvider);
    final uid = currentUserModel.uid;
    provider.setPostData(postData);
    PostData currentPost = provider.latestPostData;
    Map<String, dynamic> favoriteMap = currentPost.favoriteUserList;
    bool userLiked = favoriteMap.containsKey(uid);

    bool fetching = provider.isFetching;
    bool userWrittenComment = currentPost.commentUserList.containsKey(uid);
    return Row(
      children: [
        Icon(
          //foot icon
          userWrittenComment ? Icons.comment : Icons.comment_outlined,
          size: 20,
          color: OnestepColors().mainColor,
        ),
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(!fetching ? "${currentPost.commentCount}" : 0,
              style: TextStyle(color: Colors.grey, fontSize: 10)),
        ),
        Icon(
          //foot icon
          userLiked ? Icons.favorite : Icons.favorite_border,
          size: 20,
          color: OnestepColors().mainColor,
        ),
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(!fetching ? "${favoriteMap.keys.length}" : 0,
              style: TextStyle(color: Colors.grey, fontSize: 10)),
        ),
        Icon(
          //foot icon
          Icons.remove_red_eye,
          size: 20,
          color: OnestepColors().mainColor,
        ),
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(!fetching ? "${currentPost.views.keys.length}" : 0,
              style: TextStyle(color: Colors.grey, fontSize: 10)),
        ),
      ],
    );
  }
}
