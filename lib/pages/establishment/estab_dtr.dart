import 'dart:async';
import 'dart:convert';

import 'package:attendance_monitoring/auth/server.dart';
import 'package:attendance_monitoring/widgets/dtr_details.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final StreamController<List<TodayModel>> _monthStream =
      StreamController<List<TodayModel>>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String defaultValue = '00:00:00';
  String defaultT = '--/--';
  String error = '';
  double screenHeight = 0;
  double screenWidth = 0;
  String _month = DateFormat('MMMM').format(DateTime.now());
  String _yearMonth = DateFormat('yyyy-MM').format(DateTime.now());

  Future<void> monthly_dtr(monthStream) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final response = await http.post(
        Uri.parse('${Server.host}pages/student/student_dtr.php'),
        body: {'id': userId, 'month': _yearMonth},
      );
      print("TEST : " + _yearMonth);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<TodayModel> dtr =
            data.map((dtrData) => TodayModel.fromJson(dtrData)).toList();
        // Add the list of classmates to the stream
        _monthStream.add(dtr);
      } else {
        setState(() {
          error = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        error = 'An error occurred: $e';
      });
    }
  }

  Future refreshData() async {
    monthly_dtr(_monthStream);
  }

  @override
  void initState() {
    super.initState();
    monthly_dtr(_monthStream);
  }

  @override
  void dispose() {
    super.dispose();
    _monthStream.close();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: refreshData,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 20, bottom: 5),
              child: ListTile(
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 15,
                ),
                title: Row(
                  children: [
                    Text(_month),
                    SizedBox(width: 10),

                    TextButton(
                      onPressed: () async {
                        final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2099),
                        );

                        if (month != null) {
                          setState(() {
                            _month = DateFormat('MMMM').format(month);
                            _yearMonth = DateFormat('yyyy-MM').format(month);
                          });
                          monthly_dtr(_monthStream);
                        }
                      },
                      child: FaIcon(
                        FontAwesomeIcons.refresh,
                        size: 18,
                        color: Colors.blue,
                      ),
                    ),
                    // FaIcon(
                    //   FontAwesomeIcons.refresh,
                    //   size: 18,
                    //   color: Colors.blue,
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<TodayModel>>(
                  stream: _monthStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List<dynamic> snap = snapshot.data!;
                      if (snap.isEmpty) {
                        return Center(child: Text("NO DATA THIS MONTH"));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView.builder(
                            itemCount: snap.length,
                            itemBuilder: (context, index) {
                              final TodayModel dtr = snap[index];

                              return
                                  // DateFormat('MMMM').format(
                                  //             DateFormat('yyyy-mm-dd').parse(dtr.date)) ==
                                  //         _month
                                  //     ?
                                  GestureDetector(
                                onTap: () {
                                  showModalSheet(context);
                                },
                                child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(80),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('EE').format(
                                                  DateFormat('yyyy-mm-dd')
                                                      .parse(dtr.date)),
                                              style: const TextStyle(
                                                  fontFamily: "NexaBold",
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              DateFormat('dd ').format(
                                                  DateFormat('yyyy-mm-dd')
                                                      .parse(dtr.date)),
                                              style: const TextStyle(
                                                  fontFamily: "NexaBold",
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
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
                                                fontSize: screenWidth / 25,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text(
                                              dtr.time_in_am == defaultValue
                                                  ? defaultT
                                                  : DateFormat('hh:mm ').format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(dtr
                                                                  .time_in_am)) +
                                                      dtr.in_am,
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 20,
                                              ),
                                            ),
                                            Text(
                                              "Time-In",
                                              style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 25,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text(
                                              dtr.time_in_pm == defaultValue
                                                  ? defaultT
                                                  : DateFormat('hh:mm ').format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(dtr
                                                                  .time_in_pm)) +
                                                      dtr.in_pm,
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 20,
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
                                                fontSize: screenWidth / 25,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            Text(
                                              dtr.time_out_am == defaultValue
                                                  ? defaultT
                                                  : DateFormat('hh:mm ').format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(dtr
                                                                  .time_out_am)) +
                                                      dtr.out_am,
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 20,
                                              ),
                                            ),
                                            Text(
                                              "Time-Out",
                                              style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 25,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            Text(
                                              dtr.time_out_pm == defaultValue
                                                  ? defaultT
                                                  : DateFormat('hh:mm ').format(
                                                          DateFormat('hh:mm:ss')
                                                              .parse(dtr
                                                                  .time_out_pm)) +
                                                      dtr.out_pm,
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  // : const SizedBox()
                                  ;
                            },
                          ),
                        );
                      }
                    } else if (snapshot.hasError || error.isNotEmpty) {
                      return Center(
                        child: Text(
                          error.isNotEmpty ? error : 'Failed to load data',
                          style: TextStyle(
                              color: Colors
                                  .red), // You can adjust the error message style
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
