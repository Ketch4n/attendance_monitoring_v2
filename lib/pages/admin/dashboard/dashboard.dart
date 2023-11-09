import 'dart:async';
import 'dart:convert';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:attendance_monitoring/auth/server.dart';

import 'package:attendance_monitoring/model/section_model.dart';
import 'package:attendance_monitoring/model/user_model.dart';
import 'package:attendance_monitoring/pages/admin/dashboard/admin_dash_card.dart';
import 'package:attendance_monitoring/pages/admin/dashboard/create.dart';
import 'package:attendance_monitoring/pages/dashboard/dash_card.dart';
import 'package:attendance_monitoring/pages/dashboard/join.dart';
import 'package:attendance_monitoring/style/style.dart';

import 'package:attendance_monitoring/widgets/duck.dart';
import 'package:flutter/material.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({
    super.key,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final StreamController<List<SectionModel>> _sectionStreamController =
      StreamController<List<SectionModel>>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<dynamic>? classData;
  List<dynamic>? roomData;
  String uId = "";
  String uRole = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _refreshData() async {
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userRole = prefs.getString('userRole');
    setState(() {
      uId = userId!;
      uRole = userRole!;
    });
    final response = await http.post(
      Uri.parse('${Server.host}auth/admin/section.php'),
      body: {
        'id': userId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<SectionModel> sections = data
          .map((sectionData) => SectionModel.fromJson(sectionData))
          .toList();
      _sectionStreamController.add(sections);
    } else {
      print('Failed to fetch data: ${response.reasonPhrase}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _sectionStreamController.close();
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
  }
  //  Future<void> fetchData() async {
  //   // Replace with the URL of your PHP script
  //   final response = await http.get( Uri.parse('${Server.host}pages/student/class_room.php'));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);

  //     setState(() {
  //       classData = data['class_data'];
  //       roomData = data['room_data'];
  //     });

  //     // Get the total number of arrays
  //     int totalClassData = classData.length;
  //     int totalRoomData = roomData.length;

  //     int totalArrays = totalClassData + totalRoomData;

  //     print('Total class data arrays: $totalClassData');
  //     print('Total room data arrays: $totalRoomData');
  //   } else {
  //     print('Failed to fetch data');
  //   }
  // }
  // List classData = [];
  // List roomData = [];
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: fetchData,
      child: StreamBuilder<List<SectionModel>>(
        stream: _sectionStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final sect2 = snapshot.data!;
            // final List<SectionModel> sect = snapshot.data!;
            // final SectionModel sec2 = sect2[0];
            // final user = snapshot.data!;
            if (sect2 == 'null' || sect2.isEmpty) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    bottomsheet(uRole, uId);
                  },
                  child: const Icon(Icons.add),
                ),
                body: ListView(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Duck(),
                          Text(
                              uRole == 'Admin'
                                  ? "No Section Found !"
                                  : "No registered Establishment !",
                              style: Style.duck),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Switch Account"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final SectionModel sec2 = sect2[0];

              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    bottomsheet(uRole, uId);
                  },
                  child: const Icon(Icons.add),
                ),
                body: ListView.builder(
                    itemCount: sect2.length,
                    itemBuilder: (context, index) {
                      final SectionModel sec = sect2[index];
                      return AdminDashCard(
                          id: sec.id,
                          uid: sec.admin_id,
                          name: sec.section_name,
                          code: sec.code,
                          path: uRole == 'Admin' ? "class" : "room",
                          refreshCallback: _refreshData);
                    }),
              );
            }
          } else {
            return CardSkeleton(
                isCircularImage: true, isBottomLinesActive: true);
          }
        },
      ),
    );
  }

  Future bottomsheet(String role, String admin_id) async {
    showAdaptiveActionSheet(
        context: context,
        title: Text('Create'),
        androidBorderRadius: 20,
        actions: <BottomSheetAction>[
          BottomSheetAction(
              title: Text(
                uRole == "Admin" ? 'Section' : 'Establishment',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: "MontserratBold"),
              ),
              onPressed: (context) {
                String purpose = uRole == "Admin" ? 'Section' : 'Establishment';
                Navigator.of(context).pop(false);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateSection(
                        role: role,
                        admin_id: admin_id,
                        purpose: purpose,
                        refreshCallback: _refreshData)));
              }),
        ]);
  }
}
