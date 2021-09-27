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
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                    onSelectedPage: _selectedPage,
                    shouldPop: false,
                    isMinimified: _isMenuBarMinimified,
                  ),
                ),

              Expanded(
                child: Scaffold(
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
                    onSelectedPage: _selectedPage,
                    shouldPop: true,
                  )
                  : null,
                  body: widget.pages[_currentIndex],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future _selectedPage(PageItem pageItem) async {
    setState(() {
      _currentIndex = pageItem.index;
    });
  }
}