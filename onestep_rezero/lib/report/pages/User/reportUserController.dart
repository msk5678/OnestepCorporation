import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'case/userFirstCase.dart';

void reportUserController(BuildContext context, int caseValue) {
  switch (caseValue) {
    case 1:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UserFirstCase()));
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
