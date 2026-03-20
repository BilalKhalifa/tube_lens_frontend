import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';

class EngagementScoreBar extends StatelessWidget {

  final ChannelModel? channel;
  const EngagementScoreBar({
    super.key,
    required this.channel
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Engagement Score",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.7)
              ),
            ),
            Text(
              "${channel!.engagementRate}%",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.lightBlueAccent
              ),
            )
          ],
        ),
        SizedBox(height: 15),
        Container(
          height: 6,
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.circular(10),
            color: Colors.white.withValues(alpha: 0.15)
          ),
          child: FractionallySizedBox(
            // alignment: Alignment.centerLeft,
            widthFactor: channel!.engagementRate/10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFFA855F7),
                    ])
              ),
            ),
          ),
        )
      ],
    );
  }
}
