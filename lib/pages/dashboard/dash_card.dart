import 'package:attendance_monitoring/api/leave.dart';
import 'package:attendance_monitoring/pages/establishment.dart';
import 'package:attendance_monitoring/pages/section.dart';
import 'package:attendance_monitoring/style/style.dart';
import 'package:flutter/material.dart';

class DashCard extends StatefulWidget {
  const DashCard({super.key,
  required this.id,
  required this.name,
  required this.path,
  required this.refreshCallback});
final String id;
final String name;
final String path;
 final VoidCallback refreshCallback;
  @override
  State<DashCard> createState() => _DashCardState();
}

class _DashCardState extends State<DashCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: Style.boxdecor
          .copyWith(borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          widget.path == "class" ? 
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Section(
              ids: widget.id,
              name: widget.name,
           
              
              ))) :
               Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Establishment(
              id: widget.id,
              name: widget.name,
           
              
              )));
        },
        child: Container(
          decoration: Style.boxdecor
          .copyWith(borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Stack(
            children: <Widget>[
               
              Image.asset('assets/images/blue.jpg',
            
                fit: BoxFit.cover,
                height: 120,
                width: double.maxFinite,
                
              ),
              Column(children: [
                ListTile(
                  titleTextStyle: Style.nexaBold.copyWith(fontSize: 20),
                  iconColor: Colors.white,
                  title: Text(
                   widget.name
                    
                  ),
                  subtitle: Text(widget.path == 'class' ? "Section" : "OJT Establishment",
                  style: const TextStyle(color: Colors.white),),
                  // subtitle: Text("Supervisor"),
                ),
               
              
              ]),
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Leave',
                        child: Text('Leave'),
                      ),
                    ];
                  },
                  onSelected: (String value) async {
                    if (value == 'Leave') {
                                  
                      await leaveClassRoom(context, widget.path);
                      widget.refreshCallback();
                      print('Refresh Callback Triggered');
                    }
                    // print('Selected: $path');
                
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}