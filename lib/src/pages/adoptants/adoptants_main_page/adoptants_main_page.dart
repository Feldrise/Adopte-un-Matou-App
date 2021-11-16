import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/presentation/a_u_m_icons_icons.dart';
import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/adopted_cats_page.dart';
import 'package:adopte_un_matou/src/pages/adoptants/adoptants_main_page/widgets/adoptants_bottom_bar.dart';
import 'package:adopte_un_matou/src/pages/adoptions_page/adoptions_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/dashboard_page.dart';
import 'package:adopte_un_matou/src/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

enum AdoptantsPages { dashboard, adoption, adoptedCat, /* faq, infos, help, contact, profile */}

class AdoptantsMainPage extends StatelessWidget {
  AdoptantsMainPage({Key? key}) : super(key: key);

  final GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    const Map<AdoptantsPages, PageItem> pageItems = {
      AdoptantsPages.dashboard: PageItem(
        index: 0,
        title: "Dashboard",
        icon: FeatherIcons.layers
      ),
      AdoptantsPages.adoption: PageItem(
        index: 1,
        title: "Les chats à l'adoption",
        icon: AUMIcons.cat
      ),
      AdoptantsPages.adoptedCat: PageItem(
        index: 2,
        title: "Les chats adoptés",
        icon: FeatherIcons.checkCircle
      ),
    };

    final List<Widget> pages = [
      // DashboardPage(
      //   pageItems: pageItems,
      //   onPageChanged: (pageItem) {
      //     mainPageKey.currentState!.selectPage(pageItem);
      //   },
      // ),
      DashboardPage(
        pageItems: pageItems,
        onPageChanged: (pageItem) {
          mainPageKey.currentState!.selectPage(pageItem);
        },
      ),
      const AdoptionsPage(),
      const AdoptedCatsPage(),
    ];

    return MainPage(
      key: mainPageKey,
      pageItems: pageItems.values.toList(), 
      pages: pages,
      drawerKey: drawerKey,
      bottomBar: AdoptantsBottomBar(
        pageItems: pageItems,
        drawerKey: drawerKey,
        onPageChanged: (pageItem) {
          mainPageKey.currentState!.selectPage(pageItem);
        },
      ),
    );
  }
}