import 'package:flutter/material.dart';

@immutable
class Cat {
  final String? id;

  final String name;
  final String genre;
  final String age;

  final int price;

  final String location;

  final List<String> properties;
  final String description;

  const Cat(this.id, {
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
    name = map['name'] as String? ?? "Unkown name",
    genre = map['genre'] as String? ?? "Unkown genre",
    age = map['age'] as String? ?? "Unkown age",
    price = map['price'] as int? ?? -1,
    location = map['location'] as String? ?? "Unkown location",
    properties = (map['properties'] as List<dynamic>? ?? []).cast<String>(),
    description = map['description'] as String? ?? "Unknown description";

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
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
                      name.hashCode ^ 
                      genre.hashCode ^ 
                      age.hashCode ^ 
                      price.hashCode ^ 
                      location.hashCode ^
                      properties.hashCode ^
                      description.hashCode;
}