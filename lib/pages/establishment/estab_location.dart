import 'package:attendance_monitoring/api/server.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:http/http.dart' as http;
import '../../style/style.dart';
import '../../widgets/camera.dart';


class EstabLocation extends StatefulWidget {
  const EstabLocation({super.key,
  required this.name,});
  final String name;
  @override
  State<EstabLocation> createState() => _EstabLocationState();
}

class _EstabLocationState extends State<EstabLocation> {

  bool isLoading = true; // Track if data is loading
  int userId = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  final _idController = TextEditingController();

  String checkInAM = "--/--";
  String checkOutAM = "--/--";
  String checkInPM = "--/--";
  String checkOutPM = "--/--";

  Future showModalSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30))),
      barrierColor: Colors.black87.withOpacity(0.5),
      isScrollControlled: true,

      builder: (context)=>
          DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            maxChildSize:0.7,
            minChildSize: 0.32,
            builder:(context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Container(
                height: 200,
                child: Center(
                  child: Column( 
                  children: [
                   
                  
                    SizedBox(
                     width:50,
                      child: Divider(color: Colors.black26,
                      thickness: 4,
                                   
                      ),
                    ),
                     
                  ],),
                ),
              ),
            ),
          )
    );
  }
  Future sharedPref() async {
     final prefs = await SharedPreferences.getInstance();
     final timeINAM = prefs.getString('timeINAM');
     final timeOUTAM = prefs.getString('timeOUTAM');
     final timeINPM = prefs.getString('timeINPM');
     final timeOUTPM = prefs.getString('timeOUTPM');
     
     setState(() {
        checkInAM = timeINAM!;
        checkOutAM = timeOUTAM!;
        checkInPM = timeINPM!;
        checkOutPM = timeOUTPM!;
     });

  }
   @override
  void initState() {
    super.initState();
    sharedPref();
  }
  @override
  Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        Stack(
          children: <Widget>[
            SizedBox(
              height: 80,
              width: double.maxFinite,
              child: Image.asset(
               "assets/images/green2.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
             
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Row(
                    children: [
                       SizedBox(width: 20,),
                      ClipRRect(
                                    borderRadius: Style.borderRadius,
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          'assets/images/estab.png',
                                          height: 80,
                                          width: 80,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:15.0),
                                    child: Text(widget.name,style: TextStyle(
                                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
                                    ),),
                                  )
                    ],
                  ),
                
                ],
              ),
            )
          ],
        ),
        
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:20),
          child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 10),
                height: 150,
                // decoration: const BoxDecoration(
                //   color: Colors.white,
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black26,
                //       blurRadius: 10,
                //       offset: Offset(2, 2),
                //     ),
                //   ],
                //   borderRadius: BorderRadius.all(Radius.circular(20)),
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            checkInAM ,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                          SizedBox(height:40),
                          Text(
                            "Time-In",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            checkInPM,
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
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            checkOutAM,
                            
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                           SizedBox(height:40),
                          Text(
                            "Time-Out",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            
                            checkOutPM,
                            
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
              ),
        ),
SizedBox(height:20,),
                      checkInAM == "--/--" || checkOutAM == "--/--" ||
                      checkInPM == "--/--" || checkOutPM == "--/--"
                  ?
                         Padding(
                            padding: const EdgeInsets.symmetric(horizontal:20),
                            child: Container(
                            // margin: const EdgeInsets.only(
                            //   top: 20,
                            //   bottom: 12,
                            // ),
                            child: Builder(
                              builder: (context) {
                                final GlobalKey<SlideActionState> key = GlobalKey();
                                return SlideAction(
                                    text: checkInAM == "--/--" 
                                        ? "Slide to Time In"
                                        : checkOutAM == "--/--" ?
                                        "Slide to Check Out" :
                                        checkInPM == "--/--" 
                                        ? "Slide to Time In"
                                        : "Slide to Check Out",
                                    textStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: screenWidth / 20,
                                      fontFamily: "NexaRegular",
                                    ),
                                    outerColor: Colors.white,
                                    innerColor: Colors.blue,
                                    key: key,
                                    onSubmit: () async {
        final prefs = await SharedPreferences.getInstance();
        
                                     
                                        checkInAM == "--/--" ?
                                       setState(() {
                                    checkInAM = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                          prefs.setString('timeINAM', checkInAM);
                                  }): checkOutAM == "--/--" ?
                                   setState(() {
                                    checkOutAM = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                         prefs.setString('timeOUTAM', checkOutAM);
                                  }) : checkInPM == "--/--" ?
                                  setState(() {
                                    checkInPM = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                         prefs.setString('timeINPM', checkInPM);
                                  }) :
                                   setState(() {
                                    checkOutPM = DateFormat('hh:mm a')
                                        .format(DateTime.now());
                                         prefs.setString('timeOUTPM', checkOutPM);
                                  })
                                  ;
         
    final userId = prefs.getString('userId');
     String apiUrl = '${Server.host}pages/student/establishment.php';
  Map<String, String> headers = {'Content-Type': 'application/json'};
  String jsonData = '{"student_id": "$userId", "estab_id": "2","time_in_am":"$checkInAM", "time_out_am":"$checkOutAM","time_in_pm":"$checkInPM","time_out_pm":"$checkOutPM"}';
  final response =
      await http.post(Uri.parse(apiUrl), headers: headers, body: jsonData);
                                      Future.delayed(Duration(milliseconds: 500), () {
                                        key.currentState!.reset();
                                      });
                                    });
                              },
                            ),
                                              ),
                          ):
                          Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 32),
                      child: Text(
                      
                        "You have completed this day!",
                        style: TextStyle(
                          fontFamily: "NexaRegular",
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text("Details"),
                      onPressed: () => showModalSheet(context),)
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: ListTile(
                    //     title: Text(checkInAM),
                    //     trailing: Text(checkOutAM),
                    //   ),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: ListTile(
                    //     title: Text(checkInPM),
                    //     trailing: Text(checkOutPM),
                    //   ),
                    // )
                       
      ],
    );
  }
  
}
