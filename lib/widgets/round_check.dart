import 'package:flutter/material.dart';

class RoundCheck extends StatelessWidget {
  const RoundCheck({super.key, required this.checked, required this.color});

  final bool checked;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        color: checked ? color.withOpacity(0.12) : Colors.transparent,
      ),
      child: checked
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
            )
          : null,
    );
  }
}
