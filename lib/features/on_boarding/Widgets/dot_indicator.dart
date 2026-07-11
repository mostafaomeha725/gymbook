import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 11.0,
        height: 11.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Make the container circular
          color: color ?? const Color(0xff1b5e37), // Color of the dot
        ),
      ),
    );
  }
}
