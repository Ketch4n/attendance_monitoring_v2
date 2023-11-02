import 'package:attendance_monitoring/pages/section/section.dart';
import 'package:flutter/material.dart';

import 'section/class.dart';
import 'section/dtr.dart';

class Section extends StatefulWidget {
  const Section({super.key,required this.ids, required this.name});
  final String ids;
  final String name;


  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Section"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'DTR'),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Section'),
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
          dtr(name: widget.name),
          const SectionTab(),
          Classroom(ids:widget.ids, name: widget.name),
        ],
      ),
    );
  }
}
