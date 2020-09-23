import 'package:flutter/material.dart';


class Category extends StatelessWidget {
  final String location;
  Category(this.location);
  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 66,
      width: 66,
      decoration: const ShapeDecoration(
        shape: CircleBorder(),
        color: Color(0x124A6075),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Image.asset(
          location,
          color: Color(0xFF4A6075),
          height: 25,
          width: 28,
        ),
      ),
    );
  }
}