import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/report/pages/Deal/productReport/case/productFirstCase.dart';

import 'boardReport/case/boardFirstCase.dart';
import 'cocommentReport/case/cocommentFirstCase.dart';
import 'commentReport/case/commentFirstCase.dart';

void reportDealController(BuildContext context, int reportCaseFlag,
    int caseValue, String postUid, String reportedUid,
    {String boardUid = '0'}) {
  // 장터 -> 글 신고
  if (reportCaseFlag == 1) {
    switch (caseValue) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductFirstCase(postUid, reportedUid)));
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      default:
        break;
    }
  }
  // 게시판 -> 글 신고
  else if (reportCaseFlag == 2) {
    switch (caseValue) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                BoardFirstCase(boardUid, postUid, reportedUid)));
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      default:
        break;
    }
  }
  // 댓글 신고
  else if (reportCaseFlag == 3) {
    switch (caseValue) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CommentFirstCase(boardUid, postUid, reportedUid)));
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      default:
        break;
    }
  }
  // 대댓글 신고
  else {
    switch (caseValue) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CoCommentFirstCase(boardUid, postUid, reportedUid)));
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      default:
        break;
    }
  }
}
