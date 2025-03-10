// import 'package:flutter/cupertino.dart';
// import 'package:pull_down_button/pull_down_button.dart';
//
// import '../../../Constant/app_color.dart';
//
// class TagDialog extends StatelessWidget {
//   TagDialog({super.key, required this.child, required this.onChanged});
//   final Widget child;
//   final Function(String) onChanged;
//
//   List<String> data = ["Cucina Italiana", "Asporto", "Specialità pesce", "Pizza al taglio", "Apertivo", "Personalizzato"];
//   @override
//   Widget build(BuildContext context) {
//     return PullDownButton(
//       position: PullDownMenuPosition.over,
//       itemBuilder: (context) => List.generate(
//         data.length,
//         (index) {
//           return PullDownMenuItem(
//             onTap: () {
//               onChanged.call(data[index]);
//             },
//             title: data[index],
//             itemTheme: const PullDownMenuItemTheme(
//                 textStyle: TextStyle(
//               color: AppColor.appBlackColor,
//               fontSize: 16,
//               fontFamily: 'SfProDisplay',
//             )),
//           );
//         },
//       ),
//       buttonBuilder: (context, showMenu) => CupertinoButton(onPressed: showMenu, padding: EdgeInsets.zero, child: child),
//     );
//   }
// }
