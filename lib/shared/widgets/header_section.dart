import 'package:flutter/material.dart';
import 'package:tube_lens/shared/widgets/gradel_line.dart';

class HeaderSection extends StatelessWidget {

  final String header;
  final String subHeader;

  const HeaderSection({
    super.key,
    required this.header,
    required this.subHeader
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        SizedBox(height: 8),
        Text(
          subHeader,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70
          ),
        ),
        SizedBox(height: 6),
        GradelLine()
      ],
    );
  }
}
