import 'dart:async';
import 'dart:convert';

import 'package:attendance_monitoring/auth/server.dart';
import 'package:attendance_monitoring/model/roomate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/style.dart';
import 'package:http/http.dart' as http;

class EstabRoom extends StatefulWidget {
  const EstabRoom({super.key, required this.ids, required this.name});
  final String ids;
  final String name;
  @override
  State<EstabRoom> createState() => _EstabRoomState();
}

class _EstabRoomState extends State<EstabRoom> {
  final StreamController<List<RoomateModel>> _roomateStreamController =
      StreamController<List<RoomateModel>>();

  // Future<void> _refreshData() async {
  //   await fetchUser(_userStreamController);
  // }
  String yourID = "";
  String creator_ID = "";
  String creator_name = "";
  String creator_email = "";
  Future<void> fetchroomates(roomateStreamController) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    setState(() {
      yourID = userId!;
    });
    final response = await http.post(
      Uri.parse('${Server.host}pages/student/roomate.php'),
      body: {'establishment_id': widget.ids},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<RoomateModel> roomates = data
          .map((roomateData) => RoomateModel.fromJson(roomateData))
          .toList();
      setState(() {
        creator_ID = roomates[0].creator_id;
        creator_name = roomates[0].creator_name;
        creator_email = roomates[0].creator_email;
      });

      // Add the list of roomates to the stream
      roomateStreamController.add(roomates);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchroomates(_roomateStreamController);
  }

  @override
  void dispose() {
    super.dispose();
    _roomateStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "Administrator",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontFamily: "MontserratBold"),
            ),
            subtitle: Divider(
              color: Colors.blue,
              thickness: 2,
            ),
          ),
          ListTile(
            title: Row(
              children: [
                ClipRRect(
                    borderRadius: Style.borderRadius,
                    child: Image.asset(
                      "assets/images/estab.png",
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(creator_name, style: const TextStyle(fontSize: 18)),
                    Text(
                      creator_email,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
          const ListTile(
            title: Text(
              "Interns",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontFamily: "MontserratBold"),
            ),
            subtitle: Divider(
              color: Colors.blue,
              thickness: 2,
            ),
          ),
          StreamBuilder<List<RoomateModel>>(
              stream: _roomateStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<RoomateModel> roomates = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: roomates.length,
                        itemBuilder: (context, index) {
                          final RoomateModel roomate = roomates[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              title: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: Style.borderRadius,
                                      child: Image.asset(
                                        "assets/images/admin.png",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          roomate.student_id == yourID
                                              ? "${roomate.name} (You)"
                                              : roomate.name,
                                          style: const TextStyle(fontSize: 18)),
                                      Text(
                                        roomate.email,
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No roomates found"),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}
