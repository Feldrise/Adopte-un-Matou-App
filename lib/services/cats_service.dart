import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/src/utils/constants.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class CatsService {
  CatsService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/cats";

  static final CatsService instance = CatsService._privateConstructor();

  Future<Cat> getCat(String id, {String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/$id"),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      return Cat.fromMap(jsonDecode(response.body));
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<List<Cat>> getCats({String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> catsMaps = (jsonDecode(response.body) as List<dynamic>).cast<Map<String, dynamic>>();
      final List<Cat> cats = [];

      for (final map in catsMaps) {
        cats.add(Cat.fromMap(map));
      }

      return cats;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<String?> getCatImage(String id, {String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/$id/image"),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as String?;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<String> createCat(Uint8List? image, Cat cat, {String? authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        if (authorization != null) 
          HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        ...cat.toJson(),
        if (image != null)
          'image': base64Encode(image)
      })
    );

    if (response.statusCode == 200) return response.body;

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

   Future updateCat(Uint8List? image, Cat cat, {String? authorization}) async {
    final http.Response response = await http.put(
      Uri.parse("$serviceBaseUrl/${cat.id}"),
      headers: <String, String>{
        if (authorization != null) 
          HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        ...cat.toJson(),
        if (image != null)
          'image': base64Encode(image)
      })
    );

    if (response.statusCode != 200) throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
}