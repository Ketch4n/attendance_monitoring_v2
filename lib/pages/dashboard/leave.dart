// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/update_section.dart';
import '../../style/style.dart'; // Import SharedPreferences

Future<void> confirmLeave(
    BuildContext context, String leave, String path) async {
  await showDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          "Confirm Leave ?",
          style: Style.nexaBold,
        ),
        content: Text(
          'Press YES to continue',
          style: Style.nexaRegular,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              try {
                String purpose = 'leave';
                Navigator.of(context).pop();
                await updateSection(context, leave, path, purpose);
              } catch (e) {}
              // Remove the user ID from SharedPreferences
            },
          ),
        ],
      );
    },
  );
}
