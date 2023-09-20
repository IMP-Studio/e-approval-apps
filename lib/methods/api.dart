import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class API {
  postRequest({
    required String route,
    required Map<String, String> data,
  }) async {
    String apiUrl = 'https://testing.impstudio.id/approvall/api';
    String url = apiUrl + route;

    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _header(),
    );
  }

  _header() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}
