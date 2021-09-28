import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/src/pages/main_page/widgets/menu_drawer.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/utils/app_manager.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key, 
    required this.pageItems, 
    required this.pages
  }) : assert(pageItems.length == pages.length, "You don't have the same pageItems number than the pages number"), super(key: key);

  final List<PageItem> pageItems;
  final List<Widget> pages;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  bool _isMenuBarMinimified = false;

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

          return Row(
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
                child: ClipRect(
                  child: Navigator(
                    key: AppManager.instance.appNavigatorKey,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => Scaffold(
                        appBar: AmAppBar(
                          title: Text(widget.pageItems[_currentIndex].title),
                          showMinimifier: constraints.maxWidth > withForShowedDrawer,
                          onMinimified: () {
                            setState(() {
                              _isMenuBarMinimified = !_isMenuBarMinimified;
                            });
                          },
                        ),
                        drawer: (constraints.maxWidth <= withForShowedDrawer) 
                        ? MenuDrawer(
                          pageItems: widget.pageItems,
                          currentPageIndex: _currentIndex,
                          onSelectedPage: selectPage,
                          shouldPop: true,
                        )
                        : null,
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