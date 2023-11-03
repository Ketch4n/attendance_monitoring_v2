import 'dart:async';
import 'dart:convert';
import 'package:attendance_monitoring/api/server.dart';
import 'package:http/http.dart' as http;
import 'package:attendance_monitoring/model/today_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EstabDTR extends StatefulWidget {
  const EstabDTR({super.key});

  @override
  State<EstabDTR> createState() => _EstabDTRState();
}

class _EstabDTRState extends State<EstabDTR> {
  final StreamController<List<TodayModel>> _todayStreamController =
      StreamController<List<TodayModel>>();

  double screenHeight = 0;
  double screenWidth = 0;
  String _month = DateFormat('MMMM').format(DateTime.now());
  Future<void> today(_todayStreamController) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final response = await http.post(
        Uri.parse('${Server.host}pages/student/student_dtr.php'),
        body: {
          'id': userId!,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<TodayModel> today = data
            .map((classmateData) => TodayModel.fromJson(classmateData))
            .toList();
        _todayStreamController.add(today);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    today(_todayStreamController);
  }

  @override
  void dispose() {
    super.dispose();
    _todayStreamController.close();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32, bottom: 20, left: 15),
                child: Text(
                  _month,
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 25, right: 15),
                child: GestureDetector(
                  onTap: () async {
                    final month = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2099),
                    );

                    if (month != null) {
                      setState(() {
                        _month = DateFormat('MMMM').format(month);
                      });
                    }
                  },
                  child: const Icon(
                    Icons.calendar_today_rounded,
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<List<TodayModel>>(
              stream: _todayStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<dynamic> snap = snapshot.data!;
                  return ListView.builder(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return DateFormat('MMMM')
                                  .format(snap[index]['date'].toDate()) ==
                              _month
                          ? Container(
                              margin: EdgeInsets.only(
                                  top: index > 0 ? 12 : 0,
                                  bottom: 6,
                                  left: 6,
                                  right: 6),
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(40),
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      DateFormat('EE\ndd')
                                          .format(snap[index]['date'].toDate()),
                                      style: const TextStyle(
                                          fontFamily: "NexaBold",
                                          fontSize: 20,
                                          color: Colors.white),
                                    )),
                                  )),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Time-In",
                                          style: TextStyle(
                                            fontFamily: "NexaRegular",
                                            fontSize: screenWidth / 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          snap[index]['checkIn'],
                                          style: TextStyle(
                                            fontFamily: "NexaBold",
                                            fontSize: screenWidth / 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Time-Out",
                                          style: TextStyle(
                                            fontFamily: "NexaRegular",
                                            fontSize: screenWidth / 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          snap[index]['checkOut'],
                                          style: TextStyle(
                                            fontFamily: "NexaBold",
                                            fontSize: screenWidth / 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox();
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}
