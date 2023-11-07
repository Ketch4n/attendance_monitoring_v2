import 'package:attendance_monitoring/pages/admin/dashboard/admin_classroom.dart';
import 'package:attendance_monitoring/pages/admin/dashboard/admin_dtr.dart';
import 'package:attendance_monitoring/pages/admin/dashboard/admin_section_tab.dart';
import 'package:attendance_monitoring/pages/section/class.dart';
import 'package:attendance_monitoring/pages/section/section.dart';
import 'package:flutter/material.dart';

class AdminSection extends StatefulWidget {
  const AdminSection(
      {super.key, required this.ids, required this.uid, required this.name});
  final String ids;
  final String uid;
  final String name;

  @override
  State<AdminSection> createState() => _AdminSectionState();
}

class _AdminSectionState extends State<AdminSection> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Section"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Section'),
          BottomNavigationBarItem(
              icon: Icon(Icons.class_), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
        ],
        currentIndex: current,
        onTap: (int index) {
          setState(() {
            current = index;
          });
        },
      ),
      body: IndexedStack(
        index: current,
        children: [
          Admindtr(name: widget.name),
          AdminSectionTab(
            name: widget.name,
          ),
          AdminClassroom(ids: widget.ids, uid: widget.uid, name: widget.name),
        ],
      ),
    );
  }
}
