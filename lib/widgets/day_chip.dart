import 'package:flutter/material.dart';

class DayChip extends StatelessWidget {
  const DayChip({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
