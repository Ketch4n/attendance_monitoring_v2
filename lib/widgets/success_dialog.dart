// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/style.dart';

Future<void> successDialog(
    BuildContext context, String mess, String path) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  await Future.delayed(const Duration(seconds: 2));
  Navigator.of(context, rootNavigator: true).pop();

  // Show the success dialog
  await showDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          "SUCCESS !",
          style: Style.MontserratBold.copyWith(color: Colors.green),
        ),
        content: Text(
          mess + path,
          style: Style.MontserratRegular,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}
