import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/presentation/a_u_m_icons_icons.dart';
import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/adopted_cats_page.dart';
import 'package:adopte_un_matou/src/pages/administration/adoption_management_page/adoption_management_page.dart';
import 'package:adopte_un_matou/src/pages/administration/applications_page/applications_page.dart';
import 'package:adopte_un_matou/src/pages/administration/documents_page/documents_page.dart';
import 'package:adopte_un_matou/src/pages/administration/users_page/users_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/dashboard_page.dart';
import 'package:adopte_un_matou/src/pages/main_page/main_page.dart';
import 'package:adopte_un_matou/src/pages/profile_page/profile_page.dart';
import 'package:adopte_un_matou/src/utils/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

enum AdminPages { dashboard, adoption, adoptedCat, applications, users, documents, profile }

class AdminMainPage extends StatelessWidget {
  final GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();

  @override
  Widget build(BuildContext context) {
    const Map<AdminPages, PageItem> pageItems = {
      AdminPages.dashboard: PageItem(
        index: 0,
        title: "Dashboard",
        icon: FeatherIcons.layers
      ),
      AdminPages.adoption: PageItem(
        index: 1,
        title: "Gérer les chats à l'adoption",
        icon: AUMIcons.cat
      ),
      AdminPages.adoptedCat: PageItem(
        index: 2,
        title: "Gérer les chats adoptés",
        icon: FeatherIcons.checkCircle
      ),
      AdminPages.applications: PageItem(
        index: 3,
        title: "Gérer les candidatures",
        icon: FeatherIcons.inbox
      ),
      AdminPages.users: PageItem(
        index: 4,
        title: "Gérer les utilisateurs",
        icon: FeatherIcons.users
      ),
      AdminPages.documents: PageItem(
        index: 5,
        title: "Gérer les documents",
        icon: FeatherIcons.file
      ),
      AdminPages.profile: PageItem(
        index: 6,
        title: "Gérer le profil",
        icon: FeatherIcons.settings
      ),
    };

    final List<Widget> pages = [
      ClipRect(
        child: Navigator(
          key: AppManager.instance.dashboardKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => DashboardPage(
              pageItems: pageItems,
              onPageChanged: (pageItem) {
                mainPageKey.currentState!.selectPage(pageItem);
              },
            )
          ),
        ),
      ),
      ClipRect(
        child: Navigator(
          key: AppManager.instance.adoptionManagementKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => const AdoptionManagementPage()
          ),
        ),
      ),
      ClipRect(
        child: Navigator(
          key: AppManager.instance.adoptedKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => const AdoptedCatsPage()
          ),
        ),
      ),
      ClipRect(
        child: Navigator(
          key: AppManager.instance.applicationsKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => const ApplicationsPage()
          ),
        ),
      ),
      ClipRect(
        child: Navigator(
          key: AppManager.instance.usersKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => const UsersPage()
          ),
        ),
      ),
      ClipRect(
        child: Navigator(
          key: AppManager.instance.documentsKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => const DocumentsPage()
          ),
        ),
      ),
      ClipRect(
        child: Navigator(
          key: AppManager.instance.profileKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => const ProfilePage()
          ),
        ),
      ),
    ];

    return MainPage(
      key: mainPageKey,
      pageItems: pageItems.values.toList(), 
      pages: pages
    );
  }
}