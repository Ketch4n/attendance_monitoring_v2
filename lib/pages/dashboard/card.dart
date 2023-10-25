// ignore_for_file: unrelated_type_equality_checks


import 'package:attendance_monitoring/api/update_section.dart';
import 'package:attendance_monitoring/pages/establishment.dart';
import 'package:flutter/material.dart';

import '../../style/style.dart';
import '../section.dart';

class ContainerCard extends StatefulWidget {
  const ContainerCard({
    super.key,
    required this.index,
    required this.section,
    required this.establishment,
    required this.refreshCallback,
  });
  final int index;
  final String section;
  final String establishment;
  final VoidCallback refreshCallback;
  @override
  State<ContainerCard> createState() => _ContainerCardState();
}

class _ContainerCardState extends State<ContainerCard> {
  static String path = "";
  final String leave = "0";
  final String sectionIMG = 'assets/images/blue.jpg';
  final String estabIMG = 'assets/images/green2.png';
  final String sectionNAME = 'Your Section';
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
    List<String> link = ['section', 'establishment'];

    List<String> Navigate = ['Section','Establishment'];

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: Style.boxdecor
          .copyWith(borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
         
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Section(
                    name: widget.section == "0"
                        ? widget.establishment
                        : widget.establishment == "0"
                            ? widget.section
                            : subnamePaths[widget.index % subnamePaths.length],
                    image: widget.section == "0"
                        ? estabIMG
                        : widget.establishment == "0"
                            ? sectionIMG
                            : imagePaths[widget.index % imagePaths.length],
                  )))
                  ;
        },
        child: Stack(
          children: <Widget>[
            Image.asset(
              widget.section == "0"
                  ? estabIMG
                  : widget.establishment == "0"
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
                title: Text(widget.section == "0"
                    ? estabNAME
                    : widget.establishment == "0"
                        ? sectionNAME
                        : namePaths[widget.index % namePaths.length]),
                subtitle: Text(widget.section == "0"
                    ? widget.establishment
                    : widget.establishment == "0"
                        ? widget.section
                        : subnamePaths[widget.index % subnamePaths.length]),
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
                    setState(() {
                      path = widget.section == "0"
                          ? "establishment"
                          : widget.establishment == "0"
                              ? "section"
                              : link[widget.index % link.length];
                    });
                    String purpose = 'leave';
                    await updateSection(context, leave, path, purpose);
                    setState(() {});
                    widget.refreshCallback();
                    print('Refresh Callback Triggered');
                  }
                  print('Selected: $path');
                  print('Selected: $leave');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
