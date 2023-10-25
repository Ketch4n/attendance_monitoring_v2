import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../api/server.dart';
import '../../model/user_model.dart';
import '../../style/style.dart';
import 'package:http/http.dart' as http;

class Classroom extends StatefulWidget {
  const Classroom({super.key, required this.name});
  final String name;
  @override
  State<Classroom> createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom> {
  final StreamController<List<UserModel>> _classmateStreamController =
      StreamController<List<UserModel>>();

  // Future<void> _refreshData() async {
  //   await fetchUser(_userStreamController);
  // }

  Future<void> fetchClassmates(classmateStreamController) async {
    final response = await http.post(
      Uri.parse('${Server.host}pages/student/classmate.php'),
      body: {'name': widget.name},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<UserModel> classmates = data
          .map((classmateData) => UserModel.fromJson(classmateData))
          .toList();

      // Add the list of classmates to the stream
      classmateStreamController.add(classmates);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchClassmates(_classmateStreamController);
  }

  @override
  void dispose() {
    super.dispose();
    _classmateStreamController.close();
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
                  color: Colors.blue, fontSize: 20, fontFamily: "NexaBold"),
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("admin", style: TextStyle(fontSize: 18)),
                    Text(
                      "admin@gmail.com",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
          const ListTile(
            title: Text(
              "Classmates",
              style: TextStyle(
                  color: Colors.blue, fontSize: 20, fontFamily: "NexaBold"),
            ),
            subtitle: Divider(
              color: Colors.blue,
              thickness: 2,
            ),
          ),
          StreamBuilder<List<UserModel>>(
              stream: _classmateStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<UserModel> classmates = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: classmates.length,
                        itemBuilder: (context, index) {
                          final UserModel classmate = classmates[index];
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
                                      Text(classmate.name,
                                          style: const TextStyle(fontSize: 18)),
                                      Text(
                                        classmate.email,
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
                    child: Text("No classmates found"),
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
