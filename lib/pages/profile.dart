import 'dart:async';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:attendance_monitoring/widgets/settings_dropdown.dart';
import 'package:flutter/material.dart';
import '../api/user.dart';
import '../model/user_model.dart';
import '../style/style.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final StreamController<UserModel> _userStreamController =
      StreamController<UserModel>();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: <Widget>[
            Image.asset("assets/images/laptop.jpg"),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                    child: ClipRRect(
                        borderRadius: Style.borderRadius,
                        child: InkWell(
                          onTap: () {
                            showProfileEdit(context);
                          },
                          child: Image.asset(
                            'assets/images/admin.png',
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        )),
                  ),
                  StreamBuilder<UserModel>(
                      stream: _userStreamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserModel user = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: Style.profileText.copyWith(fontSize: 18),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SettingsDropdown(),
        // Padding(
        //   padding: Style.padding,
        //   child: Container(
        //     height: 90,
        //     width: double.maxFinite,
        //     decoration:
        //         Style.boxdecor.copyWith(borderRadius: Style.defaultradius),
        //     child: Flex(direction: Axis.horizontal, children: [
        //       Expanded(
        //           child: Column(
        //         children: [Icon(Icons.class_), Text("1"), Text("Section")],
        //       )),
        //       Expanded(
        //           child: Column(
        //         children: [Icon(Icons.room), Text("1"), Text("Establishment")],
        //       )),
        //       // Expanded(
        //       //     child: Column(
        //       //   children: [Text("436 h"), Icon(Icons.lock_clock)],
        //       // ))
        //     ]),
        //   ),
        // ),
        // SizedBox(
        //   height: 10,
        // ),

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       "Introducing",
        //       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        //     ),
        //     Text(
        //       "Face Recognition Feature",
        //       style: TextStyle(fontSize: 14, color: Colors.grey[800]),
        //     ),
        //   ],
        // ),
        // TextButton(
        //   onPressed: () {
        //     // logout(context);
        //   },
        //   child: Text("Logout"),
        // )
      ],
    );
  }
}

Future showProfileEdit(BuildContext context) async {
  showAdaptiveActionSheet(
    context: context,
    title: const Text('Edit Profile Photo'),
    androidBorderRadius: 20,
    actions: <BottomSheetAction>[
      BottomSheetAction(
          title: const Text(
            'Edit Details',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: "MontserratBold"),
          ),
          onPressed: (context) {
            Navigator.of(context).pop(false);
          }),
      BottomSheetAction(
          title: const Text(
            'Change Profile',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: "MontserratBold"),
          ),
          onPressed: (context) {
            Navigator.of(context).pop(false);
          }),
    ],
    // cancelAction: CancelAction(
    //     title: const Text(
    //   'CANCEL',
    //   style: TextStyle(fontSize: 18, fontFamily: "MontserratBold"),
    // )), // onPressed parameter is optional by default will dismiss the ActionSheet
  );
}
