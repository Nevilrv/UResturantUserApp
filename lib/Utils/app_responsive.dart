import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) => MediaQuery.of(context).size.width;

  static bool isMobile(BuildContext context) => width(context) < 650;

  static bool isTablet(BuildContext context) => width(context) < 1100 && width(context) >= 650;

  static bool isDesktop(BuildContext context) => width(context) < 1800 && width(context) >= 1100;

  static bool is4k(BuildContext context) => width(context) >= 1800;
}
