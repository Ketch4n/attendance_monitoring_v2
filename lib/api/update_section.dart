import 'dart:convert';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'server.dart';

Future<void> updateSection(
    context, String leave, String path, String purpose) async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('userId');

  String apiUrl = purpose == 'leave'
      ? '${Server.host}pages/student/leave.php'
      : "${Server.host}pages/student/join.php";
  Map<String, String> headers = {'Content-Type': 'application/json'};
  String jsonData = '{"id": "$id", "leave": "$leave", "path": "$path"}';
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: jsonData);
  final jsonResponse = json.decode(response.body);
  final status = jsonResponse['status'];
  final message = jsonResponse['message'];

  if (response.statusCode == 200) {
    await showAlertDialog(context, status, message);
  } else {
    print('Failed to update database. Error: ${response.statusCode}');
  }
}
