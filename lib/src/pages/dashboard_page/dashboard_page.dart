import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:adopte_un_matou/src/pages/application_follow_up/application_follow_up.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/manage_adoptions_page/manage_adoptions_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/widgets/dashboard_card.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/applications_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({
    Key? key,
    required this.onPageChanged,
    required this.pageItems,
  }) : super(key: key);

  final Function(PageItem) onPageChanged;
  final Map<dynamic, PageItem> pageItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double horizontalPadding = ScreenUtils.instance.horizontalPadding;
    return Scaffold(
      appBar: const AmAppBar(title: Text("Dashboard"),),
      body: Padding(
        padding: EdgeInsets.only(top: 32, left: horizontalPadding, right: horizontalPadding),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            crossAxisSpacing: 16,
            mainAxisExtent: 200,
            mainAxisSpacing: 16
          ),
          shrinkWrap: true,
          children: _dashboardCards(context, ref),
        ),
      ),
    );
  }

  List<Widget> _dashboardCards(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(appUserControllerProvider).user?.role ?? 'Guest';

    if (userRole == UserRoles.admin) {
      return _adminDashboardCards(context, ref);
    }
    if (userRole == UserRoles.adoptant) {
      return _adoptantDashboardCards(context, ref);
    }

    return const [
      Text("Hey gest Dashboard")
    ];
  }

  List<Widget> _adoptantDashboardCards(BuildContext context, WidgetRef ref) {
    return [
      ref.watch(applicationsControllerProvider).userApplication.when(
        data: (application) =>
          application != null ?
            DashboardCard(
              text: "Suivre ma candidature d'adoption",
              catImage: "cat7", 
              onTap: () async {
                await Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>( 
                    builder: (context) => ApplicationFollowUp(
                      applicationStep: application.step,
                    )
                  )
                );
              },
            ) : Container(),
        loading: (previous) => const LinearProgressIndicator(), 
        error: (error, stackTrace, previous) => Container(),
      ),

      DashboardCard(
        text: "Se déconnecter",
        catImage: "cat11", 
        onTap: () {
          ref.read(appUserControllerProvider.notifier).logout();
        },
      ),
    ];
  }

  List<Widget> _adminDashboardCards(BuildContext context, WidgetRef ref) {
    return [
      DashboardCard(
        text: "Gérer les adoptions",
        catImage: "cat7", 
        onTap: () async {
          await Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>( 
              builder: (context) => ManageAdoptionsPage(pageItems: pageItems as Map<AdminPages, PageItem>, onPageChanged: onPageChanged)
            )
          );
        },
      ),
      DashboardCard(
        text: "Gérer les utilisateurs",
        catImage: "cat9", 
        onTap: () {},
      ),
      DashboardCard(
        text: "Gérer les documents",
        catImage: "cat10", 
        onTap: () {},
      ),
      DashboardCard(
        text: "Gérer mon profil",
        catImage: "cat1", 
        onTap: () {},
      ),
      DashboardCard(
        text: "Supprimer mon compte",
        catImage: "cat2", 
        onTap: () {},
      ),
      DashboardCard(
        text: "Se déconnecter",
        catImage: "cat11", 
        onTap: () {
          ref.read(appUserControllerProvider.notifier).logout();
        },
      ),
    ];
  }
}