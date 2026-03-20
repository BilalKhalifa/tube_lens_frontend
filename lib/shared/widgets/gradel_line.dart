import 'package:flutter/material.dart';

class GradelLine extends StatelessWidget {
  const GradelLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
            colors: [
              Color(0xFF3B82F6),
              Color(0xFFA855F7)
            ])
      ),
    );
  }
}
