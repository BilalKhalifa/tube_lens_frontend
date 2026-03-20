import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';
import 'package:tube_lens/utils/number_formatter.dart';

class QuickAnalyticsSection extends StatelessWidget {

  final ChannelModel? channel;

  const QuickAnalyticsSection({super.key, this.channel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          const Text(
            "Quick Analytics",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {


              return Wrap(
                spacing: 16,
                runSpacing: 16,

                children: [
                  _card(
                      width: _cardWidth(constraints),
                      title: "Subscribers",
                      value: channel!=null
                             ?NumberFormatter.format(channel!.subscribers)
                             :"- -",
                      icon: Icons.people_outline,
                      glow: Colors.redAccent
                  ),
                  _card(
                      width: _cardWidth(constraints),
                      title: "Total Views",
                      value: channel!=null
                          ?NumberFormatter.format(channel!.totalViews)
                          :"- -",
                      icon: Icons.remove_red_eye_outlined,
                      glow: Colors.deepOrange
                  ),
                  _card(
                      width: _cardWidth(constraints),
                      title: "Total videos",
                      value: channel!=null
                          ?channel!.totalVideos.toString()
                          :"- -",
                      icon: Icons.videocam_outlined,
                      glow: Colors.pinkAccent
                  ),
                  _card(
                      width: _cardWidth(constraints),
                      title: "Avg views/Video",
                      value: channel!=null
                          ?NumberFormatter.format(channel!.avgViews)
                          :"- -",
                      icon: Icons.trending_up,
                      glow: Colors.purpleAccent
                  )
                ],
              );
            },
          )
        ]
      ),
    );
  }

  double _cardWidth(BoxConstraints constraints) {
    double maxWidth = constraints.maxWidth;

    if (maxWidth < 600) {
      return (maxWidth - 16) / 2; // 2 per row
    } else if (maxWidth < 1100) {
      return (maxWidth - 32) / 3; // 3 per row
    } else {
      return (maxWidth - 48) / 4; // 4 per row
    }
  }

  Widget _card({
    required double width,
    required String title,
    required String value,
    required IconData icon,
    required Color glow
  }){
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFF111827),
        border: Border.all(
          color: glow.withValues(alpha: 0.35)
        ),
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: 0.25),
            blurRadius: 25,
            spreadRadius: 1
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: glow.withValues(alpha: 0.12),
            ),
            child: Icon(
              icon,
              color: glow,
              size: 22,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
