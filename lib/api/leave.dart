import 'dart:convert';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/server.dart';

Future<void> leaveClassRoom(
  context,
  String path,
) async {
  final prefs = await SharedPreferences.getInstance();
  final id = prefs.getString('userId');
// final ref = path == 'room' ? 'establishment_id' : 'section_id';
  String apiUrl = '${Server.host}pages/student/leave.php';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  String jsonData = '{"id": "$id", "path": "$path"}';
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
