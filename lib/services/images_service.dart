
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ImagesService {
  ImagesService._privateConstructor();

  static final ImagesService instance = ImagesService._privateConstructor();

  Future<String?> getImage(String url, {String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as String?;
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
}