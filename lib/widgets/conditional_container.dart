import 'package:flutter/material.dart';

class ConditionalContainer extends StatelessWidget {
  const ConditionalContainer({required this.childWidget, super.key});

  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 80, child: childWidget);
  }
}
