import 'package:flutter/material.dart';
import 'package:todos_app_full/helpers/helper_function.dart';

FunctionHelpers helpers = FunctionHelpers();

class DayChip extends StatefulWidget {
  const DayChip({
    required this.onChooseDate,
    required this.listOfDays,
    required this.label,

    super.key,
  });
  final String label;

  final List<bool> listOfDays;
  final Function(String label) onChooseDate;

  @override
  State<DayChip> createState() => _DayChipState();
}

class _DayChipState extends State<DayChip> {
  bool isSelected = false;
  //bool get isActive => widget.listOfDays[helpers.checkIndexByLabel(widget.label)]; no longer needed, state is now handled internally by the chip. This saves the use of a GestureDetector having a Chip as a child.

  @override
  Widget build(BuildContext context) {
    var appTheme = Theme.of(context);
    final chipLabelStyle = appTheme.textTheme.bodySmall!.copyWith(
      color: appTheme.colorScheme.onSurface,
    );
    return FilterChip(
      showCheckmark: false,
      label: Text(widget.label),
      labelStyle: chipLabelStyle,

      selected: isSelected,

      onSelected: (value) {
        setState(() {
          isSelected = value;
          widget.onChooseDate(widget.label);
        });
      },
    );
  }
}
