import 'package:flutter/material.dart';
//
// SizedBox buildSizedBoxH(double height) {
//   return SizedBox(
//     height: height,
//   );
// }
//
// SizedBox buildSizedBoxW(double width) {
//   return SizedBox(
//     width: width,
//   );
// }

extension SizedBoxExtention on double {
  SizedBox addHSpace() {
    return SizedBox(
      height: this,
    );
  }

  SizedBox addWSpace() {
    return SizedBox(
      width: this,
    );
  }
}
