import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/services/cats_service.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/user_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToAdoptedCart extends ConsumerStatefulWidget {
  const AddToAdoptedCart({
    Key? key, 
    required this.cat
  }) : super(key: key); 

  final Cat cat;

  @override
  ConsumerState<AddToAdoptedCart> createState() => _AddToAdoptedCartState();
}

class _AddToAdoptedCartState extends ConsumerState<AddToAdoptedCart> {
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 250,
        color: Palette.colorGrey1,
        child: Row(
          children: [
            // The image
            if (ref.watch(widget.cat.image).image == null)
              Flexible(
                flex: 1,
                child: Image.asset("assets/icons/placeholderCatImage.png", fit: BoxFit.cover,),
              )
            else 
              Flexible(
                flex: 1,
                child: Container(
                  color: Palette.colorGrey2,
                  child: ref.watch(widget.cat.image).image!.when(
                    data: (data) => Image(image: data, fit: BoxFit.cover,),
                    loading: (previous) => Image.asset("assets/icons/kittyLoader2.gif", fit: BoxFit.cover,),
                    error: (error, stackTrace, previous) => const Center(child: Icon(FeatherIcons.alertCircle),),
                  )
                ),
              ),
            
            // The content
            if (_isLoading)
              const Flexible(
                flex: 1,
                child: Center(child: CircularProgressIndicator(),)
              )
            else if (_errorMessage.isNotEmpty)
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: AmStatusMessage(
                      title: "Erreur",
                      message: _errorMessage,
                    ),
                  ),
                ),
              )
            else
              Flexible(
                flex: 1,
                child: _buildMainColumn(),
              )   
          ],
        ),
      ),
    );
  }

  Widget _buildMainColumn() {
    return Padding(
      padding: EdgeInsets.all(ScreenUtils.instance.horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.cat.name),
          const SizedBox(height: 8.0,),
          Text(widget.cat.age),
          const SizedBox(height: 8.0,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(FeatherIcons.xCircle),
              SizedBox(width: 4.0,),
              Text("Pas encore adopté")
            ],
          ),
          const SizedBox(height: 8.0,),
          AmButton(
            text: "Déplacer dans adoptés",
            onPressed: _moveCatToAdopted,
          )
        ],
      ),
    );
  }

  Future _moveCatToAdopted() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    final Cat cat = widget.cat.copyWith(adoptionStatus: CatAdoptionStatus.adopted);

    try {
      final String? authorization = ref.read(userControllerProvider).user?.authenticationHeader;

      await CatsService.instance.updateCat(null, cat, authorization: authorization);

      ref.read(catsControllerProvider.notifier).updateCat(cat);

      setState(() {
        _isLoading = false;
        _errorMessage = "";
      });
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Impossible de déplacer le chat ; ${e.code} ; ${e.message}";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";   
      });
    }
  }
}