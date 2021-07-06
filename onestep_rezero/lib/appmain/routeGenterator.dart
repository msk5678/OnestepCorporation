import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/board/AboutPost/AboutDashBoard/myComment.dart';
import 'package:onestep_rezero/board/AboutPost/AboutDashBoard/myFavorite.dart';
import 'package:onestep_rezero/board/AboutPost/AboutDashBoard/myPost.dart';
import 'package:onestep_rezero/board/AboutPost/AboutDashBoard/topCommentList.dart';
import 'package:onestep_rezero/board/AboutPost/AboutDashBoard/topFavoriteList.dart';
import 'package:onestep_rezero/board/AboutPost/AboutPostContent/postContent.dart';
// import 'package:flutter/foundation.dart' as foundation;
import 'package:onestep_rezero/board/AboutPost/AboutPostListView/postListMain.dart';
import 'package:onestep_rezero/board/AboutPost/alterPost.dart';
import 'package:onestep_rezero/board/AboutPost/createPost.dart';
import 'package:onestep_rezero/board/AboutBoard/boardCreate.dart';
import 'package:onestep_rezero/product/widgets/detail/imagesFullViewer.dart';
import 'package:page_transition/page_transition.dart';

import 'package:path/path.dart' as p;

class RouteGenerator {
  // static bool _isIOS =
  //     foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  static Route<dynamic> generateRoute(RouteSettings settings) {
    assert(settings.name.indexOf("/") == 0,
        "[ROUTER] routing MUST Begin with '/'");

    var _reDefine = settings.name.replaceFirst("/", "");
    var _pathParams = p.split(
        _reDefine.split("?").length > 1 ? _reDefine.split("?")[0] : _reDefine);

    //QueryParameters example
    // print(Uri.base.toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
    // print(Uri.base.query);  // id=15&randomNumber=3.14
    // print(Uri.base.queryParameters['randomNumber']); // 3.14

    Map<String, dynamic> arguments = settings.arguments ??
        Uri.parse(settings.name.replaceFirst("/", "")).queryParameters ??
        {};
    var _pageName = _pathParams.isNotEmpty ? _pathParams.first : null;
    Widget _pageWidget;
    //example:
    //case에는 /를 제외하고 원하는 이름으로 설정, pushNamed할 때는 /를 포함하여 자신이 설정한 이름으로 불러옴.
    switch (_pageName) {
      case 'PostList':
        _pageWidget = PostListMain(
          currentBoardData: arguments["CURRENTBOARDDATA"],
          // boardCategory: arguments["BOARD_NAME"],
        );
        break;
      //DashBoard PageRoute
      case 'UserPostingList':
        _pageWidget = UserPostingList(
          dashBoardIconData: arguments["DASHBOARDDATA"],
        );
        break;
      case 'UserWrittenCommentList':
        _pageWidget = UserWrittenCommentList(
          dashBoardIconData: arguments["DASHBOARDDATA"],
        );
        break;

      case 'ImagesFullViewer':
        _pageWidget = ImagesFullViewer(
          imagesUrl: arguments["IMAGESURL"],
          index: arguments["INDEX"],
        );
        break;

      case 'UserFavoriteList':
        _pageWidget = UserFavoriteList(
          dashBoardIconData: arguments["DASHBOARDDATA"],
        );
        break;
      case 'TopFavoritePostList':
        _pageWidget = TopFavoritePostList(
          dashBoardIconData: arguments["DASHBOARDDATA"],
        );
        break;
      case 'TopCommentPostList':
        _pageWidget = TopCommentPostList(
          dashBoardIconData: arguments["DASHBOARDDATA"],
        );
        break;
      case 'PostContent':
        // Navigator.of(context).pushNamed('/BoardContent?INDEX=$index&BOARD_NAME="current"') -> arguments['INDEX'] = index, arguments['BOARD_NAME'] = "current"
        // _pageWidget = PostContentRiverPod(
        //   currentPostData: arguments["CURRENTBOARDDATA"],
        _pageWidget = PostContent(
          postData: arguments["CURRENTBOARDDATA"],
        );
        break;
      case 'CreatePost':
        return PageTransition(
            child: CreatePost(
              currentBoardData: arguments["CURRENTBOARDDATA"],
            ),
            type: PageTransitionType.fade,
            settings: RouteSettings(name: settings.name.toString()));
        break;
      case 'AlterPost':
        return PageTransition(
            child: AlterPost(
              postData: arguments["POSTDATA"],
            ),
            type: PageTransitionType.fade,
            settings: RouteSettings(name: settings.name.toString()));
        break;
      case 'BoardCreate':
        return PageTransition(
            child: BoardCreate(
              boardCategory:
                  arguments.isEmpty ? null : arguments["BOARDCATEGORY"],
            ),
            type: PageTransitionType.fade);
        break;
    }
    return PageTransition(
        child: _pageWidget,
        type: PageTransitionType.fade,
        settings: RouteSettings(name: settings.name.toString()));
    // return _isIOS
    //     ? CupertinoPageRoute(
    //         builder: (context) => _pageWidget,
    //         settings: RouteSettings(name: settings.name.toString()))
    //     : MaterialPageRoute(
    //         builder: (context) => _pageWidget,
    //         settings: RouteSettings(name: settings.name.toString()));
  }
}
