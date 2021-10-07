class Cat {
  String? id;

  String name;
  String genre;
  String age;

  int price;

  String location;

  List<String> properties;
  String description;

  Cat(this.id, {
    required this.name,
    required this.genre,
    required this.age,
    required this.price,
    required this.location,
    required this.properties,
    required this.description
  });

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
}