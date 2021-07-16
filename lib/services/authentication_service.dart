import 'dart:convert';
import 'dart:io';

import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/utils/constants.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class AuthenticationService {
  AuthenticationService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/authentication";

  static final AuthenticationService instance = AuthenticationService._privateConstructor();

  Future register(User userToRegister, String password) async {
    final userJson = userToRegister.toJson();

    // Since password is never stored, we need to add it
    // manually to the register request
    userJson.addAll(<String, dynamic>{
      "password": password
    });

    final http.Response response = await http.post(
      Uri.parse("$serviceBaseUrl/register"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(userJson)
    );

    if (response.statusCode != 200) {
      throw PlatformException(code: response.statusCode.toString(), message: response.body);
    }
  }
}