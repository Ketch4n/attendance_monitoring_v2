import 'dart:async';
import 'dart:convert';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:attendance_monitoring/api/server.dart';
import 'package:attendance_monitoring/pages/dashboard/join.dart';
import 'package:flutter/material.dart';
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
  Future<void> _refreshData() async {
    await fetchUser(_userStreamController);
  }
 fetchData() async {
   final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
   final response = await http.post(
    Uri.parse('${Server.host}pages/student/class_room.php'),
    body: {'studentID': userId},
  );
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final data = json.decode(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchUser(_userStreamController);
  }

  @override
  void dispose() {
    super.dispose();
    _userStreamController.close();
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show(); // Show the refresh indicator
  }

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
               
      
                ListView.builder(
                  
                  itemCount: user.section_id != "null" &&
                          user.establishment_id != "null"
                      ? 2
                      : 1,
                  itemBuilder: (context, index) {
                    final section = user.section_name;
                    final establishment = user.establishment_name;
                    return ContainerCard(
                      index: index,
                      section: section,
                      establishment: establishment,
                      refreshCallback: _refreshData,
                    ); // Use the custom item here
                  },
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
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
