import 'package:flutter/cupertino.dart';

mixin UserRoles {
  static const String admin = "Admin";
  static const String adoptant = "Adoptant";

  static const Map<String, String> detailled = {
    admin: "Administrateur",
    adoptant: "Adoptant"
  };
}

@immutable
class User {
  final String? id;

  final String firstName;
  final String lastName;

  final String email;

  final String role;
  final String? token;

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role
  }) {
    return User(
      id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role
    );
  }


  // Utilities
  String get fullName => "$firstName $lastName";
  String get authenticationHeader => "Bearer $token";

  const User(this.id, {
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.token
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && 
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.email == email &&
      other.role == role;
  }

  @override 
  int get hashCode {
    return id.hashCode ^ firstName.hashCode ^ lastName.hashCode ^ email.hashCode ^ role.hashCode;
  }

  User.fromMap(Map<String, dynamic> map) : 
  id = map['id'] as String,
  firstName = map['firstName'] as String? ?? "Unknown",
  lastName = map['lastName'] as String? ?? "Unknown",
  email = map['email'] as String? ?? "Unknown",
  role = map['role'] as String? ?? "Unknown",
  token = map['token'] as String? ?? "Unknown";

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "role": role
    };
  }
}