import 'dart:convert';

import 'package:adopte_un_matou/services/images_service.dart';
import 'package:adopte_un_matou/src/provider/states/image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageController extends StateNotifier<ImageState> {
  ImageController(ImageState state) : super(state);

  Future loadOnline({String? authenticationHeader}) async {
    if (state.imageUrl.isEmpty || state.image != null) return;

    state = state.copyWith(image: const AsyncValue.loading()); 

    try {
      final String? image = await ImagesService.instance.getImage(state.imageUrl);

      if (image == null) {
        state = state.copyWith(image: const AsyncValue.data(AssetImage("assets/icons/placeholderCatImage.png")));
      }
      else {
        state = state.copyWith(image: AsyncValue.data(MemoryImage(base64Decode(image))));
      }
    }
    on Exception catch(e) {
      state = state.copyWith(image: AsyncValue.error(e));
    }
  }
}