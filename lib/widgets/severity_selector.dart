import 'package:flutter/material.dart';

class SeveritySelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const SeveritySelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final n = i + 1;
        final filled = n <= value;
        return GestureDetector(
          onTap: () => onChanged(n),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white38),
              color: filled ? Colors.white : Colors.transparent,
            ),
            child: Text(
              '$n',
              style: TextStyle(color: filled ? Colors.black : Colors.white70),
            ),
          ),
        );
      }),
    );
  }
}
