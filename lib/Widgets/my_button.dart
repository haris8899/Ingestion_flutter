import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final Color? color;
  final Color? Textcolor;
  const MyButton({
    super.key,
    required this.text,
    this.onTap,
    this.color = Colors.blue, 
    this.Textcolor= Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: Dimensions.height45,
        padding: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.BorderRadius30),
            color: color),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Textcolor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
