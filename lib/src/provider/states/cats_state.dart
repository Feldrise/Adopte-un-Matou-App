import 'package:adopte_un_matou/models/cat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AdoptionCatsState {
  final AsyncValue<Map<String, Cat>> cats;

  AsyncValue<List<Cat>> get catsToAdopte {
    return cats.when(
      data: (data) {
        return AsyncValue.data([
          for (final cat in data.values)
            if (cat.adoptionStatus == CatAdoptionStatus.waiting) 
              cat 
        ]);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace: stackTrace)
    );
  }

  AsyncValue<List<Cat>> get adoptedCats {
    return cats.when(
      data: (data) {
        return AsyncValue.data([
          for (final cat in data.values)
            if (cat.adoptionStatus == CatAdoptionStatus.adopted)
              cat 
        ]);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace: stackTrace)
    );
  }

  const AdoptionCatsState({
    required this.cats,
  });

  AdoptionCatsState copyWidth({
    AsyncValue<Map<String, Cat>>? cats
  }) {
    return AdoptionCatsState(cats: cats ?? this.cats);
  }
}