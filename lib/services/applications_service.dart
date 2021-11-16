
import 'dart:convert';
import 'dart:io';

import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/src/utils/constants.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

class ApplicationsService {
  ApplicationsService._privateConstructor();

  final String serviceBaseUrl = "$kApiBaseUrl/applications";

  static final ApplicationsService instance = ApplicationsService._privateConstructor();

  Future<Application> getApplication(String id, {String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl/$id"),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      return Application.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
  
  Future<Application?> getUserApplication(String userId, {String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse("$serviceBaseUrl?userId=$userId"),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      final applications = jsonDecode(response.body) as List<dynamic>;

      if (applications.isNotEmpty) {
        return Application.fromMap(applications[0] as Map<String, dynamic>);
      }

      return null;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<Map<String, Application>> getApplications({String? authorization}) async {
    final http.Response response = await http.get(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        if (authorization != null)
          HttpHeaders.authorizationHeader: authorization
      } 
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> applicationsMap = (jsonDecode(response.body) as List<dynamic>).cast<Map<String, dynamic>>();
      final Map<String, Application> applications = {};

      for (final map in applicationsMap) {
        applications[map['id'] as String] = Application.fromMap(map);
      }

      return applications;
    }

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

  Future<String> createApplication(Application application, {String? authorization}) async {
    final http.Response response = await http.post(
      Uri.parse(serviceBaseUrl),
      headers: <String, String>{
        if (authorization != null) 
          HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(application.toJson())
    );

    if (response.statusCode == 200) return response.body;

    throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }

   Future updateApplication(Application application, {String? authorization}) async {
    final http.Response response = await http.put(
      Uri.parse("$serviceBaseUrl/${application.id}"),
      headers: <String, String>{
        if (authorization != null) 
          HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(application.toJson())
    );

    if (response.statusCode != 200) throw PlatformException(code: response.statusCode.toString(), message: response.body);
  }
}