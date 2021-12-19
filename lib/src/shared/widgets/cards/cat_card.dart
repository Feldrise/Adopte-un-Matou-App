import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/view_cat_page/view_cat_page.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatCard extends ConsumerStatefulWidget {
  const CatCard({
    Key? key,
    required this.cat,
  }) : super(key: key);

  final Cat cat;

  @override
  ConsumerState<CatCard> createState() => _CatCardState();
}

class _CatCardState extends ConsumerState<CatCard> {

  @override
  void initState() {
    super.initState();

    ref.read(widget.cat.image.notifier).loadOnline();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final bool canEdit = ref.read(appUserControllerProvider).user?.role == UserRoles.admin;

        await Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(builder: (context) => ViewCatPage(cat: widget.cat, canEdit: canEdit,))
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          color: Palette.colorGrey3,
          child: Stack(
            children: [
              Positioned.fill(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.srcATop),
                  child: ref.watch(widget.cat.image).image != null ? 
                    ref.watch(widget.cat.image).image!.when(
                      data: (data) => Image(image: data, fit: BoxFit.cover,),
                      loading: () => Image.asset('assets/icons/kittyLoader2.gif'),
                      error: (error, stackTrace) => const Center(child: Icon(FeatherIcons.alertCircle),),
                    ) :
                    Container()
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(child: Text("${widget.cat.name} - ${widget.cat.age}", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.colorWhite, fontWeight: FontWeight.w600),)),
                      const SizedBox(height: 8.0,),
                      Flexible(
                        child: Row(
                          children: [
                            const Icon(FeatherIcons.mapPin, size: 24, color: Palette.colorWhite,),
                            const SizedBox(width: 8,),
                            Flexible(child: Text(widget.cat.location, style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.colorWhite, fontWeight: FontWeight.w600),)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0,),
                      TextButton(
                        onPressed: () {}, 
                        child: Text("Voir", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Palette.colorWhite),),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }


}