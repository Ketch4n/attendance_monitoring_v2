import 'dart:async';
import 'dart:convert';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:attendance_monitoring/api/server.dart';
import 'package:attendance_monitoring/pages/dashboard/dash_card.dart';
import 'package:attendance_monitoring/pages/dashboard/join.dart';
import 'package:attendance_monitoring/pages/establishment.dart';
import 'package:flutter/material.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/user.dart';
import '../model/user_model.dart';
import '../style/style.dart';
import 'dashboard/card.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final StreamController<UserModel> _userStreamController =
      StreamController<UserModel>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<dynamic>? classData;
  List<dynamic>? roomData;

  Future<void> _refreshData() async {
    await fetchUser(_userStreamController);
  }
  
  @override
  void initState() {
    super.initState();
    fetchUser(_userStreamController);
    fetchData();
  }

Future<void> fetchData() async {
    final response = await http.get( Uri.parse('${Server.host}pages/student/class_room.php'));
  

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        classData = data['class_data'];
        roomData = data['room_data'];
      });
    } else {
      print('Failed to fetch data: ${response.reasonPhrase}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _userStreamController.close();
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
      onRefresh: _refreshData,
      child: StreamBuilder<UserModel>(
        stream: _userStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;

            if (user.section_id == "null" &&
                user.establishment_id == "null") {
              return Scaffold(
floatingActionButton: 
                  FloatingActionButton(
                    onPressed: () async {
                     
                        bottomsheet(user.role, user.section_name, user.establishment_name);
                      
                    },
                    child: const Icon(
                        Icons.add),
                  ),
                
            
               body: ListView(
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 60, bottom: 30),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                "assets/duck.gif",
                              ),
                            ),
                          ),
                          Text(
                              user.role == 'Student'
                                  ? "No Section or Establishment !"
                                  : user.role == 'Admin'
                                      ? 'No section found !'
                                      : 'No Establishment registered !',
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
              return Scaffold(
                floatingActionButton: 
                  FloatingActionButton(
                    onPressed: () async {
                     
                        bottomsheet(user.role, user.section_name, user.establishment_name);
                      
                    },
                    child: const Icon(
                        Icons.add),
                  ),
                body: 
               
      
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView(
                    children: [
                     
                      user.establishment_id != "null" ?
                      DashCard(id: user.establishment_id,
                      name: user.establishment_name,
                      path: "room",
                      refreshCallback:_refreshData): SizedBox(),
                       user.section_id != "null" ?
                      DashCard(id: user.section_id,
                      name: user.section_name,
                      path:"class",
                      refreshCallback: _refreshData) : SizedBox(),
                    ],
                  
                  ),
                ),
              );
            }
          } else {
            return CardSkeleton(isCircularImage: true,isBottomLinesActive:true );
          }
        },
      ),
    );
  }
    Future bottomsheet(String role, String section, String estab) async {
    showAdaptiveActionSheet(
        context: context,
        title: Text(role == 'Student' ? 'Join' : 'Create'),
        androidBorderRadius: 20,
        actions: role == 'Student'
            ? <BottomSheetAction>[
              section == 'null'?  BottomSheetAction(
                    title: const Text(
                      'Section',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "NexaBold"),
                    ),
                    onPressed: (context) {
                      String purpose = "Section";
                      Navigator.of(context).pop(false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Join(
                              role: role,
                              purpose: purpose,
                              refreshCallback: _refreshData)));
                    }): BottomSheetAction(
                    title: const Text(
                      "You're Already in a Section",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontFamily: "NexaBold"),
                    ),
                    onPressed: (context) {
                    
                      Navigator.of(context).pop(false);
                  
                    }),
               estab == 'null'? BottomSheetAction(
                    title: const Text(
                      'Establishment',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: "NexaBold"),
                    ),
                    onPressed: (context) {
                      String purpose = "Establishment";
                      Navigator.of(context).pop(false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Join(
                              role: role,
                              purpose: purpose,
                              refreshCallback: _refreshData)));
                    }):BottomSheetAction(
                    title: const Text(
                      "Establishment Active",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontFamily: "NexaBold"),
                    ),
                    onPressed: (context) {
                    
                      Navigator.of(context).pop(false);
                  
                    }),
              ]
            : role == 'Admin' || role == 'Establishment'
                ? <BottomSheetAction>[
                    BottomSheetAction(
                        title: Text(
                          role == 'Admin' ? 'Section' : 'Establishment',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: "NexaBold"),
                        ),
                        onPressed: (context) {
                          String purpose =
                              role == 'Admin' ? 'Section' : 'Establishment';
                          Navigator.of(context).pop(false);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Join(
                                  role: role,
                                  purpose: purpose,
                                  refreshCallback: _refreshData)));
                        }),
                  ]
                : List.empty());
  }
}
