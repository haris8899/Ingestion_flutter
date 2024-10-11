import 'package:flutter/material.dart';
//import 'package:mona_app/utils/colors.dart';
import 'package:ingestion_app/utils/dimensions.dart';

class DecoratedTextField extends StatefulWidget {
  final String HintText;
  final controller;
  //final String
  const DecoratedTextField({super.key, required this.HintText, required this.controller});

  @override
  State<DecoratedTextField> createState() => _DecoratedTextFieldState();
}

class _DecoratedTextFieldState extends State<DecoratedTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Dimensions.height10 / 4,
        bottom: Dimensions.height10,
        left: Dimensions.height10,
        right: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.BorderRadius30),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: widget.HintText),
      ),
    );
  }
}
