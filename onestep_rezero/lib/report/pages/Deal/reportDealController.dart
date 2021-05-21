import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'case/caseOneTest.dart';
import 'case/caseTwoTest.dart';

void reportDealController(BuildContext context, int caseValue) {
  switch (caseValue) {
    case 1:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CaseOneTest()));
      break;
    case 2:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CaseTwoTest()));
      break;
    default:
      break;
  }
}
