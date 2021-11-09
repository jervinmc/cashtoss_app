

import 'package:flutter/material.dart';
class textSize extends StatelessWidget {
  final String text;
  final double size;
  const textSize(this.text,this.size);

  @override
  Widget build(BuildContext context) {
    return new Text(text, style: TextStyle(fontSize: size),);
  }
}