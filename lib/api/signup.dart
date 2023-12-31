// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:attendance_monitoring/auth/login.dart';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/server.dart';

Future signUp(BuildContext context, String email, String password, String id,
    String name, String roleController) async {
  String apiUrl = '${Server.host}auth/signup.php';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  String jsonData =
      '{"email": "$email", "password": "$password", "name": "$name", "user_id": "$id", "role":"$roleController"}';
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: jsonData);
  final jsonResponse = json.decode(response.body);
  final message = jsonResponse['message'];
  final status = jsonResponse['status'];

  if (response.statusCode == 200) {
    await showAlertDialog(context, status, message);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
    // Handle success message as needed
  } else if (response.statusCode == 400) {
    // Email already taken
    await showAlertDialog(context, status, message);
    // Handle email taken message as needed
  } else {
    // Handle other status codes (e.g., 500, 405) as needed
  }
}
