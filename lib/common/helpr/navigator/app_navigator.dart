import 'package:flutter/material.dart';

class AppNavigator {
  static void pushReplacment(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context)=> widget));
  }
  static void push(BuildContext context, Widget widget) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context)=> widget));
  }
   static void pushAndRemove(BuildContext context,Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false
    );
  }
}
