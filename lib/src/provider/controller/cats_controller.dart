import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/services/cats_service.dart';
import 'package:adopte_un_matou/src/provider/states/cats_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final catsControllerProvider = StateNotifierProvider.autoDispose<CatsController, AdoptionCatsState>((ref) {
  // User? appUser = ref.watch(appUserControllerProvider).user;

  // List<Cat> adoptionCats = await CatsService.instance.getCats(authorization: appUser?.authenticationHeader);
  return CatsController(
    const AdoptionCatsState(cats: AsyncValue.loading())
  );
});

class CatsController extends StateNotifier<AdoptionCatsState> {
  CatsController(AdoptionCatsState state) : super(state);

  Future loadData({String? authenticationHeader, bool refresh = false}) async {
    if (state.cats.asData != null && !refresh) return;

    state = state.copyWidth(cats: const AsyncValue.loading());

    try {
      Map<String, Cat> cats = await CatsService.instance.getCats(authorization: authenticationHeader);
    
      state = state.copyWidth(
        cats: AsyncValue.data(cats)
      );
    }
    on Exception catch(e) {
      state = state.copyWidth(
        cats: AsyncValue.error(e)
      );
    }
  }

  void addCat(Cat cat) {
    if (cat.id == null)  return;

    state = state.copyWidth(
      cats: AsyncValue.data({
        ...state.cats.asData!.value,
        cat.id!: cat
      })
    );
  }

  void updateCat(Cat cat) {
    if (cat.id == null) return;

    state.cats.asData!.value[cat.id!] = cat;
    state = state.copyWidth(
      cats: state.cats
    );
  }

  void removeCat(Cat cat) {
    state.cats.asData!.value.remove(cat);
    state = state.copyWidth(
      cats: state.cats
    );
  }
}