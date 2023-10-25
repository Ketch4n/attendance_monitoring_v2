
import 'package:attendance_monitoring/pages/Establishment/dtr.dart';
import 'package:attendance_monitoring/pages/establishment/estab_room.dart';
import 'package:attendance_monitoring/pages/establishment/establishment_tab.dart';
import 'package:flutter/material.dart';


class Establishment extends StatefulWidget {
  const Establishment({super.key, required this.name, required this.image});
  final String name;
  final String image;

  @override
  State<Establishment> createState() => _EstablishmentState();
}

class _EstablishmentState extends State<Establishment> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[200],
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'DTR'),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Establishment'),
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
          dtr_estab(image: widget.image, name: widget.name),
          const EstablishmentTab(),
          EstabRoom(name: widget.name),
        ],
      ),
    );
  }
}
