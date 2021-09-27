
// import 'package:adopte_un_matou/src/utils/colors.dart';
// import 'package:flutter/material.dart';

// class AmBottomBar extends StatelessWidget {
//   const AmBottomBar({
//     Key? key, 
//     required this.tabItems,
//     required this.currentTab,
//     required this.onSelectedTab
//   }) : super(key: key);

//   final List<TabItem> tabItems;

//   final TabItem currentTab;
//   final ValueChanged<TabItem> onSelectedTab;

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: tabItems.indexOf(currentTab),
//       items: [
//         for (final tabItem in tabItems)
//           _buildItem(context, tabItem: tabItem)
//       ],
//       onTap: (index) => onSelectedTab(tabItems[index]),
//       backgroundColor: colorScaffold,
//     );
//   }

//   BottomNavigationBarItem _buildItem(BuildContext context, {required TabItem tabItem}) {
//     final String text = tabName[tabItem] ?? "Inconnu";
//     final IconData icon = tabIcon[tabItem] ?? Icons.broken_image;

//     return BottomNavigationBarItem(
//       icon: Icon(icon),
//       label: text
//     );
//   }
// }