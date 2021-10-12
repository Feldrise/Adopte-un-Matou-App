import 'package:adopte_un_matou/models/cat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AdoptionCatsState {
  final AsyncValue<List<Cat>> catsToAdopte;

  const AdoptionCatsState({
    required this.catsToAdopte,
  });

  AdoptionCatsState copyWidth({
    AsyncValue<List<Cat>>? catsToAdopte
  }) {
    return AdoptionCatsState(catsToAdopte: catsToAdopte ?? this.catsToAdopte);
  }
}