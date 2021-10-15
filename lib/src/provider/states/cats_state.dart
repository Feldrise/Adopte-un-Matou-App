import 'package:adopte_un_matou/models/cat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AdoptionCatsState {
  final AsyncValue<List<Cat>> cats;

  AsyncValue<List<Cat>> get catsToAdopte {
    return cats.when(
      data: (data) {
        return AsyncValue.data([
          for (final cat in data)
            if (cat.adoptionStatus == CatAdoptionStatus.waiting) 
              cat 
        ]);
      },
      loading: (data) => const AsyncValue.loading(),
      error: (error, stackTrace, data) => AsyncValue.error(error, stackTrace: stackTrace)
    );
  }

  AsyncValue<List<Cat>> get adoptedCats {
    return cats.when(
      data: (data) {
        return AsyncValue.data([
          for (final cat in data)
            if (cat.adoptionStatus == CatAdoptionStatus.adopted)
              cat 
        ]);
      },
      loading: (data) => const AsyncValue.loading(),
      error: (error, stackTrace, data) => AsyncValue.error(error, stackTrace: stackTrace)
    );
  }

  const AdoptionCatsState({
    required this.cats,
  });

  AdoptionCatsState copyWidth({
    AsyncValue<List<Cat>>? cats
  }) {
    return AdoptionCatsState(cats: cats ?? this.cats);
  }
}