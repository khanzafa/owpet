import 'package:flutter/material.dart';

class MonitoringItem extends StatelessWidget {
  final String title;
  final bool isChecked;
  final Function(bool) onChanged;

  MonitoringItem(
      {required this.title, required this.isChecked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        onChanged:
            isChecked ? null : (bool? value) => onChanged(value ?? false),
      ),
      title: Text(title),
    );
  }
}
