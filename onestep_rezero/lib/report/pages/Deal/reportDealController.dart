import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'case/dealFirstCase.dart';
import 'case/dealFourCase.dart';
import 'case/dealSecondCase.dart';
import 'case/dealThirdCase.dart';

void reportDealController(BuildContext context, int caseValue, String postUid) {
  switch (caseValue) {
    case 1:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DealFirstCase(postUid)));
      break;
    case 2:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DealSecondCase(postUid)));
      break;
    case 3:
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DealThirdCase(postUid)));
      break;
    case 4:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DealFourCase(postUid)));
      break;
    default:
      break;
  }
}
