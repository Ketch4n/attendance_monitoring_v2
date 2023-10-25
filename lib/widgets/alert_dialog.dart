import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../style/style.dart';
import 'warning.dart';

class Alert_Dialog extends StatelessWidget {
  const Alert_Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Warning(),
          Text(
            "Username or Password",
            style: Style.nexaBold,
          ),
        ],
      ),
      content: Text(
        "Please Input Data",
        style: Style.nexaRegular,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('ok'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
