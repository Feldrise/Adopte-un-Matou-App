import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable 
class ImageState {
  const ImageState({
    required this.imageUrl,
    this.image
  });

  final String imageUrl;
  final AsyncValue<ImageProvider>? image;

  ImageState copyWith({
    String? imageUrl,
    AsyncValue<ImageProvider>? image,
  }) {
    return ImageState(
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image
    );
  }
}