import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';
import 'package:tube_lens/utils/number_formatter.dart';

class KeyMatrics extends StatelessWidget {
  final ChannelModel? channel;
  const KeyMatrics({
    super.key,
    required this.channel
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildKeyMatricsCard(
                    width: _DetailCardWidth(constraints), 
                    icon: Icons.trending_up, 
                    color: Colors.blueAccent, 
                    value: "${channel!.engagementRate}%",
                    label: "Engagement Rate"),
                _buildKeyMatricsCard(
                    width: _DetailCardWidth(constraints),
                    icon: Icons.remove_red_eye_outlined,
                    color: Colors.purpleAccent,
                    value: NumberFormatter.format(channel!.avgViews),
                    label: "Avg Views/Video"),
                _buildKeyMatricsCard(
                    width: _DetailCardWidth(constraints),
                    icon: Icons.watch_later_outlined,
                    color: Colors.pinkAccent,
                    value: "${channel!.avgUploadGap} Days",
                    label: "Upload Frequency")
              ],
            );
          },
      ),
    );
  }
  double _DetailCardWidth(BoxConstraints constraints) {
    double maxWidth = constraints.maxWidth;

    if (maxWidth < 600) {
      return (maxWidth - 16) / 2; // 2 per row
    } else if (maxWidth < 1100) {
      return (maxWidth - 32) / 3; // 3 per row
    } else {
      return (maxWidth - 48) / 4; // 4 per row
    }
  }
  
  Widget _buildKeyMatricsCard({
    required double width,
    required IconData icon,
    required Color color,
    required String value,
    required String label,
} ){
    return Container(
      width: width,
      // margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Icon(icon, color: color, size: 25)),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
