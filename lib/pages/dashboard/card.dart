// ignore_for_file: unrelated_type_equality_checks


import 'package:attendance_monitoring/api/leave.dart';

import 'package:attendance_monitoring/pages/establishment.dart';
import 'package:flutter/material.dart';

import '../../style/style.dart';
import '../section.dart';

class ContainerCard extends StatefulWidget {
  const ContainerCard({
    super.key,
    required this.index,
    required this.sectID,
    required this.section,
    required this.estabID,
    required this.establishment,
    required this.refreshCallback,
  });
  final int index;
  final String sectID;
  final String section;
  final String estabID;
  final String establishment;
  final VoidCallback refreshCallback;
  @override
  State<ContainerCard> createState() => _ContainerCardState();
}

class _ContainerCardState extends State<ContainerCard> {
  final String sectionIMG = 'assets/images/blue.jpg';
  final String estabIMG = 'assets/images/green2.png';
  final String sectionNAME = 'Section';
  final String estabNAME = 'OJT Establishment';

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = [
      sectionIMG,
      estabIMG,
    ];
    List<String> namePaths = [
      sectionNAME,
      estabNAME,
    ];
    List<String> subnamePaths = [
      widget.section,
      widget.establishment,
    ];
    List<String> IDS = [
      widget.sectID,
      widget.estabID,
    ];
    List<String> link = ['class', 'room'];
  
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: Style.boxdecor
          .copyWith(borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
         
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => Section( 
          //      ids  : widget.sectID == "null"
          //               ? widget.estabID
          //               : widget.estabID == "null"
          //                   ? widget.sectID
          //                   : IDS[widget.index % IDS.length],
          //           name : widget.section == "null"
          //               ? widget.establishment
          //               : widget.establishment == "null"
          //                   ? widget.section
          //                   : subnamePaths[widget.index % subnamePaths.length],
          //         image : widget.section == "null"
          //               ? estabIMG
          //               : widget.establishment == "null"
          //                   ? sectionIMG
          //                   : imagePaths[widget.index % imagePaths.length],
          //         )));
                  
        },
        child: Stack(
          children: <Widget>[
            Image.asset(
              widget.section == "null"
                  ? estabIMG
                  : widget.establishment == "null"
                      ? sectionIMG
                      : imagePaths[widget.index % imagePaths.length],
              fit: BoxFit.cover,
              height: 120,
              width: double.maxFinite,
            ),
            Column(children: [
              ListTile(
                titleTextStyle: Style.nexaBold.copyWith(fontSize: 20),
                iconColor: Colors.white,
                title: Text(widget.section == "null"
                    ? widget.establishment
                    : widget.establishment == "null"
                        ? widget.section
                        : subnamePaths[widget.index % subnamePaths.length]),
                subtitle: Text(widget.section == "null"
                    ? estabNAME
                    : widget.establishment == "null"
                        ? sectionNAME
                        : namePaths[widget.index % namePaths.length],style: TextStyle(color: Colors.white),),
                // subtitle: Text("Supervisor"),
              )
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
                   String path = widget.section == "null"
                          ? "room"
                          : widget.establishment == "null"
                              ? "class"
                              : link[widget.index % link.length];
                    print(path);
                    await leaveClassRoom(context, path);
                   
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
    );
  }
}
