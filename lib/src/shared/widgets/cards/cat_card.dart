import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/src/provider/controller/adoption_cats_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatCard extends ConsumerWidget {
  const CatCard({
    Key? key,
    required this.cat,
  }) : super(key: key);

  final Cat cat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(adoptionCatsControllerProvider.notifier).updateCat(
          cat.copyWith(name: "Updated Jack")
        );
      },
      onLongPress: () {
        ref.read(adoptionCatsControllerProvider.notifier).removeCat(cat);
      },
      child: Text(
        cat.name
      ),
    );
  }
}