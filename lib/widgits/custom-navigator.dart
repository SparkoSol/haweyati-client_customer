
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigator {
  static navigateTo(context, widget) {
    return Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>widget)
//        MaterialPageRoute(builder: (context) => widget)
   );
  }
}