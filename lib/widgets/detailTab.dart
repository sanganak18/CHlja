import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final String category;
  final String info;
  bool isObscure = true;

  Details(this.category, this.info, this.isObscure);

  @override
  Widget build(BuildContext context) {
    return Center(
      //color: Colors.greenAccent,
      child: Container(
        height: 65.0,
        width: 145.0,
        decoration: BoxDecoration(
          color: Color(0x104A6075),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: category,
                  style: TextStyle(
                    color: Color(0xFF4A6075),
                    fontSize: 15.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: isObscure == false
                      ? info
                      : '${info.replaceAll(RegExp(r"."), "*")}',
                  style: TextStyle(
                    height: 1.65,
                    color: Colors.grey[800],
                    fontSize: 12.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}