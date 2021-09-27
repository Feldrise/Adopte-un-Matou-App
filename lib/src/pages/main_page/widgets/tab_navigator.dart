
// import 'package:adopte_un_matou/models/page_item.dart';
// import 'package:adopte_un_matou/models/user.dart';
// import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/adopted_cats_page.dart';
// import 'package:adopte_un_matou/src/pages/administration/adoption_management_page/adoption_management_page.dart';
// import 'package:adopte_un_matou/src/pages/administration/notifications_page/notifications_page.dart';
// import 'package:adopte_un_matou/src/pages/adoptants/adoption_page/adoption_page.dart';
// import 'package:adopte_un_matou/src/pages/dashboard_page/dashboard_page.dart';
// import 'package:adopte_un_matou/src/providers/user_store.dart';
// import 'package:adopte_un_matou/src/shared/widgets/general/am_bottom_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class TabNavigatorRoutes {
//   static const String root = '/';
// }

// class TabNavigator extends StatelessWidget {
//   const TabNavigator({
//     Key? key, 
//     required this.navigatorKey, 
//     required this.tabItem
//   }) : super(key: key);

//   final GlobalKey<NavigatorState> navigatorKey;
//   final PageItem pageItem;

//   void _push(BuildContext context, {required String destinationPage}) {
//     final routeBuilders = _routeBuilders(context);

//     Navigator.push<void>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => routeBuilders['/$destinationPage']!(context),
//       ),
//     );
//   }

//   Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
//     final UserStore userStore = Provider.of<UserStore>(context);

//     if (tabItem == TabItem.adoptionManagement) {
//       return {
//         TabNavigatorRoutes.root: (context) => AdoptionManagementPage(
//           onPush: (destinationPage) => _push(context, destinationPage: destinationPage),
//         )
//       };
//     }

//     if (tabItem == TabItem.adoptedCats) {
//       return {
//         TabNavigatorRoutes.root: (context) => AdoptedCatsPage() 
//       };
//     }

//     if (tabItem == TabItem.notifications) {
//       return {
//         TabNavigatorRoutes.root: (context) => NotificationsPage()
//       };
//     }

//     if (userStore.user!.role != UserRoles.adoptant || 
//         tabItem == TabItem.dashboard) {
//           return {
//             TabNavigatorRoutes.root: (context) => DashboardPage()
//           };
//         }

//     return {
//       TabNavigatorRoutes.root: (context) => AdoptionPage()
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     final routeBuilders = _routeBuilders(context);
//     return Navigator(
//       key: navigatorKey,
//       initialRoute: TabNavigatorRoutes.root,
//       onGenerateRoute: (routeSettings) {
//         return MaterialPageRoute<Map<String, Widget Function(BuildContext)>>(
//           builder: (context) => routeBuilders[routeSettings.name]!(context),
//         );
//       },
//     );
//   }
// }
