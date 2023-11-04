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
  final StreamController<List<TodayModel>> _monthStream =
      StreamController<List<TodayModel>>();
  String error = '';
  double screenHeight = 0;
  double screenWidth = 0;
  String _month = DateFormat('MMMM').format(DateTime.now());
  Future<void> monthly_dtr(monthStream) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final response = await http.post(
        Uri.parse('${Server.host}pages/student/student_dtr.php'),
        body: {'id': userId, 'month': _month},
      );

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
          Expanded(
            child: StreamBuilder<List<TodayModel>>(
                stream: _monthStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<dynamic> snap = snapshot.data!;
                    return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        final TodayModel dtr = snap[index];

                        return
                            // DateFormat('MMMM').format(
                            //             DateFormat('yyyy-mm-dd').parse(dtr.date)) ==
                            //         _month
                            //     ?
                            Container(
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
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      "Date",
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      "Date",
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
                            // : const SizedBox()
                            ;
                      },
                    );
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
    );
  }
}
