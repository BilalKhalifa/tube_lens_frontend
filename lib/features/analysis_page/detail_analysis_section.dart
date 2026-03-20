import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';
import 'package:tube_lens/features/detail_analytic/detail_analytic_page.dart';
import 'package:tube_lens/utils/number_formatter.dart';

import 'engagement_score_bar.dart';

class DetailAnalysisSection extends StatelessWidget {
  final ChannelModel? channel;
  const DetailAnalysisSection({super.key, required this.channel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(top: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            blurRadius: 35,
            spreadRadius: 5,
            color: Colors.lightBlue.shade900.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  channel!.thumbnail,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        channel!.title[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 15),
              Text(
                channel!.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _analysisDetailCard(
                    width: _DetailCardWidth(constraints),
                    icon: Icons.people_alt_outlined,
                    color: Colors.blueAccent,
                    value: NumberFormatter.format(channel!.subscribers),
                    label: "Subscribers",
                  ),
                  _analysisDetailCard(
                    width: _DetailCardWidth(constraints),
                    icon: Icons.videocam,
                    color: Colors.purple,
                    value: channel!.totalVideos.toString(),
                    label: "Total Videos",
                  ),
                  _analysisDetailCard(
                    width: _DetailCardWidth(constraints),
                    icon: Icons.remove_red_eye_outlined,
                    color: Colors.lightBlueAccent,
                    value: NumberFormatter.format(channel!.avgViews),
                    label: "Avg Views",
                  ),
                  _analysisDetailCard(
                    width: _DetailCardWidth(constraints),
                    icon: Icons.trending_up,
                    color: Colors.pinkAccent,
                    value: channel!.engagementRate.toString(),
                    label: "Engagement",
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 20),
          EngagementScoreBar(channel: channel),
          SizedBox(height: 20),
          _detailAnalysisButton(context, channel!),
        ],
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

  Widget _analysisDetailCard({
    required double width,
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
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
          Icon(icon, color: color, size: 25),
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

  Widget _detailAnalysisButton(BuildContext context, ChannelModel channel) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              pageBuilder: (_, _, _) => DetailAnalyticPage(channel: channel)),
        );
      },
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFFA855F7)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "detail_analytic_text",
              child: Material(
                color: Colors.transparent,
                child: Text(
                  "View Detail Analytics",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.trending_up, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
