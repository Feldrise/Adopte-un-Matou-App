
import 'dart:convert';
import 'dart:io';

import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UsersService {
  UsersService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/users";

  static final UsersService instance = UsersService._privateConstructor();

  Future<User> getUser(String id, {String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/$id"),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<Map<String, User>> getUsers({bool shouldIncludeSensitiveInfo = false, String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/?shouldIncludeSensitiveInfo=$shouldIncludeSensitiveInfo"),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> usersMap = (jsonDecode(response.body) as List<dynamic>).cast<Map<String, dynamic>>();
      final Map<String, User> users = {};

      for (final map in usersMap) {
        users[map['id'] as String] = User.fromMap(map);
      }

      return users;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future updateUser(User user, {String? authorization}) async {
    final http.Response response = await http.put(
      Uri.parse("$serviceBaseUrl/${user.id}"),
      headers: <String, String>{
        if (authorization != null) 
          HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "user/json; charset=UTF-8",
      },
      body: jsonEncode(user.toJson())
    );

    if (response.statusCode != 200) throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
}