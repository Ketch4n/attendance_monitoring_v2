import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'auth/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: "attendance-monitoring",
      options: const FirebaseOptions(
    apiKey: "AIzaSyCatnsTU-2hveFqSVuU-wu04xya0r_PwAE",
    authDomain: "attendance-monitoring-c33b5.firebaseapp.com",
    projectId: "attendance-monitoring-c33b5",
    storageBucket: "attendance-monitoring-c33b5.appspot.com",
    messagingSenderId: "923340212066",
    appId: "1:923340212066:web:cfa048f322dbd305098e3b",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Monitoring',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,

        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        // useMaterial3: true,
      ),
      home: const Auth(),
       localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}
