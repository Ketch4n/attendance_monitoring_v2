import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:attendance_monitoring/auth/server.dart';
import 'package:attendance_monitoring/widgets/show_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> removeClassRoom(
  context,
  String id,
  String path,
) async {
  final ref = path == 'room' ? 'establishment' : 'section';
  final stat = 'In-Active';
  print("ID : ${id}");
  String apiUrl = '${Server.host}auth/admin/remove.php';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  String jsonData = '{"id": "$id","ref":"$ref","status":"$stat"}';
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
