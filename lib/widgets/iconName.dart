import 'package:flutter/material.dart';



class IconName extends StatelessWidget {
  final String name;

  const IconName(this.name);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(
        name,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          color: Color(0xFF4A6075),
          fontSize: 13.0,
        ),
      ),
    );
  }
}
