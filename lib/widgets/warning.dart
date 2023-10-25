import 'package:flutter/material.dart';
import '../style/style.dart';

class Warning extends StatelessWidget {
  const Warning({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.warning,
      color: Color(0xFFD3A201),
    );
  }
}

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.info,
      color: Style.themecolor,
    );
  }
}
