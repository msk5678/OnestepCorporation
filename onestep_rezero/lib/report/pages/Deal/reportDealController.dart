import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'case/dealFirstCase.dart';

void reportDealController(
    BuildContext context, int caseValue, String postUid, String reportedUid) {
  switch (caseValue) {
    case 1:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DealFirstCase(postUid, reportedUid)));
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
