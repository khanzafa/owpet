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
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),),
      trailing: Checkbox(
        side: const BorderSide(
          width: 9,
          color: Color.fromRGBO(139, 128, 255, 1.0),
        ),
        fillColor: const MaterialStatePropertyAll(
          Color.fromRGBO(139, 128, 255, 1.0),
        ),
        checkColor: Colors.black,
        value: isChecked,
        onChanged:
            isChecked ? null : (bool? value) => onChanged(value ?? false),
      ),
    );
  }
}
