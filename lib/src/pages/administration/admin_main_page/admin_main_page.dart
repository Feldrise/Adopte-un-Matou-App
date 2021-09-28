import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/presentation/a_u_m_icons_icons.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/widgets/admin_bottom_bar.dart';
import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/adopted_cats_page.dart';
import 'package:adopte_un_matou/src/pages/administration/adoption_management_page/adoption_management_page.dart';
import 'package:adopte_un_matou/src/pages/administration/applications_page/applications_page.dart';
import 'package:adopte_un_matou/src/pages/administration/documents_page/documents_page.dart';
import 'package:adopte_un_matou/src/pages/administration/users_page/users_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/dashboard_page.dart';
import 'package:adopte_un_matou/src/pages/main_page/main_page.dart';
import 'package:adopte_un_matou/src/pages/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

enum AdminPages { dashboard, adoption, adoptedCat, applications, users, documents, profile }

class AdminMainPage extends StatelessWidget {
  AdminMainPage({Key? key}) : super(key: key);

  final GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

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
      DashboardPage(
        pageItems: pageItems,
        onPageChanged: (pageItem) {
          mainPageKey.currentState!.selectPage(pageItem);
        },
      ),
      const AdoptionManagementPage(),
      const AdoptedCatsPage(),
      const ApplicationsPage(),
      const UsersPage(),
      const DocumentsPage(),
      const ProfilePage(),
    ];

    return MainPage(
      key: mainPageKey,
      pageItems: pageItems.values.toList(), 
      pages: pages,
      drawerKey: drawerKey,
      bottomBar: AdminBottomBar(
        pageItems: pageItems,
        drawerKey: drawerKey,
        onPageChanged: (pageItem) {
          mainPageKey.currentState!.selectPage(pageItem);
        },
      ),
    );
  }
}