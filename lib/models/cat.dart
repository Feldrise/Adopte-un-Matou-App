import 'package:adopte_un_matou/services/cats_service.dart';
import 'package:adopte_un_matou/src/provider/controller/image_controller.dart';
import 'package:adopte_un_matou/src/provider/states/image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin CatAdoptionStatus {
  static const String waiting = "Waiting";
  static const String reserved = "Reserved";
  static const String adopted = "Adopted";

  static const detailed = {
    waiting: "En attente",
    reserved: "Reservé",
    adopted: "Adopté"
  };
}

@immutable
class Cat {
  final String? id;

  final AutoDisposeStateNotifierProvider<ImageController, ImageState> image;

  final String adoptionStatus;

  final String name;
  final String genre;
  final String age;

  final int price;

  final String location;

  final List<String> properties;
  final String description;

  const Cat(this.id, {
    required this.image,
    required this.adoptionStatus,
    required this.name,
    required this.genre,
    required this.age,
    required this.price,
    required this.location,
    required this.properties,
    required this.description
  });

  Cat copyWith({
    String? id,
    AutoDisposeStateNotifierProvider<ImageController, ImageState>? image,
    String? adoptionStatus,
    String? name,
    String? genre,
    String? age,
    int? price,
    String? location,
    List<String>? properties,
    String? description,
  }) {
    return Cat(
      id ?? this.id, 
      adoptionStatus: adoptionStatus ?? this.adoptionStatus,
      image: image ?? this.image,
      name: name ?? this.name,
      genre: genre ?? this.genre,
      age: age ?? this.age,
      price: price ?? this.price,
      location: location ?? this.location,
      properties: properties ?? this.properties,
      description: description ?? this.description
    );
  }

  Cat.fromMap(Map<String, dynamic> map) :
    id = map['id'] as String,
    image = StateNotifierProvider.autoDispose<ImageController, ImageState>((ref) {
      return ImageController(
        ImageState(
          imageUrl: "${CatsService.instance.serviceBaseUrl}/${map['id'] as String}/image",
        )
      );
    }),
    adoptionStatus = map['adoptionStatus'] as String? ?? CatAdoptionStatus.waiting,
    name = map['name'] as String? ?? "Unkown name",
    genre = map['genre'] as String? ?? "Unkown genre",
    age = map['age'] as String? ?? "Unkown age",
    price = map['price'] as int? ?? -1,
    location = map['location'] as String? ?? "Unkown location",
    properties = (map['properties'] as List<dynamic>? ?? <dynamic>[]).cast<String>(),
    description = map['description'] as String? ?? "Unknown description";

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "adoptionStatus": adoptionStatus,
      "name": name,
      "genre": genre,
      "age": age,
      "price": price,
      "location": location,
      "properties": properties,
      "description": description
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cat &&
      other.id == id &&
      other.image == image &&
      other.name == name &&
      other.genre == genre &&
      other.age == age &&
      other.price == price &&
      other.location == location &&
      other.properties == properties &&
      other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ 
                      image.hashCode ^
                      name.hashCode ^ 
                      genre.hashCode ^ 
                      age.hashCode ^ 
                      price.hashCode ^ 
                      location.hashCode ^
                      properties.hashCode ^
                      description.hashCode;
}