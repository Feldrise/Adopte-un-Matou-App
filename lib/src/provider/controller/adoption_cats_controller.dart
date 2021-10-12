import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/services/cats_service.dart';
import 'package:adopte_un_matou/src/provider/states/adoption_cats_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adoptionCatsControllerProvider = StateNotifierProvider.autoDispose<AdoptionCatsController, AdoptionCatsState>((ref) {
  // User? appUser = ref.watch(userControllerProvider).user;

  // List<Cat> adoptionCats = await CatsService.instance.getCats(authorization: appUser?.authenticationHeader);
  return AdoptionCatsController(
    const AdoptionCatsState(catsToAdopte: AsyncValue.loading())
  );
});

class AdoptionCatsController extends StateNotifier<AdoptionCatsState> {
  AdoptionCatsController(AdoptionCatsState state) : super(state);

  Future loadData({String? authenticationHeader}) async {
    state = state.copyWidth(catsToAdopte: const AsyncValue.loading());

    List<Cat> cats = await CatsService.instance.getCats(authorization: authenticationHeader);
    
    state = state.copyWidth(
      catsToAdopte: AsyncValue.data(cats)
    );
  }

  void addCat(Cat cat) {
    state = state.copyWidth(
      catsToAdopte: AsyncValue.data([
        ...state.catsToAdopte.asData!.value,
        cat
      ])
    );
  }

  void updateCat(Cat cat) {
    state = state.copyWidth(
      catsToAdopte: AsyncValue.data([
        for (final oldCat in state.catsToAdopte.asData!.value)
          if (oldCat.id == cat.id) cat else oldCat
      ])
    );
  }

  void removeCat(Cat cat) {
    state.catsToAdopte.asData!.value.remove(cat);
    state = state.copyWidth(
      catsToAdopte: state.catsToAdopte
    );
  }
}