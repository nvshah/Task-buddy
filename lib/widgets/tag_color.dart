import 'package:flutter/material.dart';

class TagColor extends StatelessWidget {
  final Color color;

  TagColor({@required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
       width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
    );
  }
}