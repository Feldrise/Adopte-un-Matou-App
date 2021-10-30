import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:adopte_un_matou/src/provider/controller/applications_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/src/utils/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({
    Key? key, 
    required this.pageItems, 
    required this.pages,
    required this.bottomBar,
    required this.drawerKey,
  }) : assert(pageItems.length == pages.length, "You don't have the same pageItems number than the pages number"), super(key: key);

  final List<PageItem> pageItems;
  final List<Widget> pages;

  final Widget bottomBar;
  final GlobalKey<ScaffoldState> drawerKey;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  bool _isMenuBarMinimified = false;

  @override
  void initState() {
    super.initState();

    final String? authenticationHeaders = ref.read(appUserControllerProvider).user?.authenticationHeader;

    ref.read(catsControllerProvider.notifier).loadData(authenticationHeader: authenticationHeaders);
    ref.read(applicationsControllerProvider.notifier).loadData(authenticationHeader: authenticationHeaders);
  }

  @override
  Widget build(BuildContext context) {
  return WillPopScope(
      onWillPop: () async {
        // show confirmation
        return (await AppManager.instance.showCloseAppConfirmation(context)) ?? false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double withForShowedDrawer = 732;

          return Scaffold(
            key: widget.drawerKey,
            body: Row(
              children: [
                if (constraints.maxWidth > withForShowedDrawer) 
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isMenuBarMinimified ? 100 : 300,
                    child: MenuDrawer(
                      pageItems: widget.pageItems,
                      currentPageIndex: _currentIndex,
                      onSelectedPage: selectPage,
                      shouldPop: false,
                      isMinimified: _isMenuBarMinimified,
                    ),
                  ),
          
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ClipRect(
                          child: Navigator(
                            key: AppManager.instance.appNavigatorKey,
                            onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
                              settings: route,
                              builder: (context) => Scaffold(
                                body: Stack(
                                  children: [
                                    for (final pageItem in widget.pageItems) 
                                      _buildOffstageWidget(pageItem)
                                  ],
                                ),
                              )
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            drawer: (constraints.maxWidth <= withForShowedDrawer) 
            ? MenuDrawer(
              pageItems: widget.pageItems,
              currentPageIndex: _currentIndex,
              onSelectedPage: selectPage,
              shouldPop: true,
            )
            : null,
            bottomNavigationBar: (constraints.maxWidth <= withForShowedDrawer) ?
              widget.bottomBar : null
          );
        },
      ),
    );
  }

  Widget _buildOffstageWidget(PageItem pageItem) {
    return Offstage(
      offstage: pageItem.index != _currentIndex,
      child: widget.pages[pageItem.index],
    );
  }

  Future selectPage(PageItem pageItem) async {
    AppManager.instance.appNavigatorKey.currentState!.popUntil((route) => route.isFirst);
    // TODO: manage force of no pop
    // while (AppManager.instance.appNavigatorKey.currentState!.canPop()) {
    //   AppManager.instance.appNavigatorKey.currentState!.maybePop();
    // }
    setState(() {
      _currentIndex = pageItem.index;
    });
  }
}