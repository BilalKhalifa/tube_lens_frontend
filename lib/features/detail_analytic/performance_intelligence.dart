import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';
import 'package:tube_lens/features/detail_analytic/performance_chart.dart';

class PerformanceIntelligence extends StatelessWidget {
  final ChannelModel? channel;

  const PerformanceIntelligence({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    // Dynamic logic for the overall trend text and color
    final bool isPositive = channel!.momentumIncreasePercent >= 0;
    final Color trendColor = isPositive ? const Color(0xFF4F8AFF) : Colors.redAccent;
    final String sign = isPositive ? "+" : "";
    final bool isMobile = MediaQuery.of(context).size.width<700;

    return  Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF000080).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Color(0xFF000080)
        )
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(isMobile),
            const SizedBox(height: 32),

            isMobile?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Trend Chart Card
                _buildTrendChartCard(trendColor, sign, isPositive, isMobile),
                const SizedBox(height: 24),
                // Right: Intelligence Metrics
                _buildMetricsColumn(),
              ],
            )
            :Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Trend Chart Card
                Expanded(child: _buildTrendChartCard(trendColor, sign, isPositive, isMobile)),
                const SizedBox(width: 24),
                // Right: Intelligence Metrics
                Expanded(child: _buildMetricsColumn()),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF057dcd).withValues(alpha: 0.25)
          ),
          child: const Icon(Icons.psychology, color: Color(0xFF4F8AFF), size: 32)),
        const SizedBox(width: 12),
        Expanded(
        child:isMobile
        ?Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Performance Intelligence",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text("AI-powered insights from recent video performance",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
          ],
        )
        :Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Performance Intelligence",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text("AI-powered insights from recent video performance",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
          ],
        )),
      ],
    );
  }

  Widget _buildTrendChartCard(Color trendColor, String sign, bool isPositive, isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111729),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Performance Trend (Last 15 Videos)",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              _buildMomentumBadge(),
            ],
          )
          :Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: const Text("Performance Trend (Last 15 Videos)",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildMomentumBadge(),
            ],
          ),
          const SizedBox(height: 8),
          // DYNAMIC TEXT: Prefix (+/-), color, and text (increase/decrease) change based on value
          Text("$sign${channel!.momentumIncreasePercent}% ${isPositive ? 'increase' : 'decrease'} in recent performance",
              style: TextStyle(color: trendColor, fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 40),
          // Your existing Chart Widget
          SizedBox(height: 300, child: PerformanceChart(trends: channel!.trends)),
        ],
      ),
    );
  }

  Widget _buildMomentumBadge() {
    Color bgColor;
    Color textColor;
    IconData statusIcon;
    Color iconColor;

    // Logic to switch theme based on the momentum string
    switch (channel!.momentum.toLowerCase()) {
      case 'growing':
        bgColor = const Color(0xFF064E3B);
        textColor = const Color(0xFF10B981);
        statusIcon = Icons.whatshot;
        iconColor = Colors.orangeAccent;
        break;
      case 'declining':
      case 'slowing':
        bgColor = Colors.red.withValues(alpha: 0.15);
        textColor = Colors.redAccent;
        statusIcon = Icons.trending_down;
        iconColor = Colors.redAccent;
        break;
      default: // Stable or Unknown
        bgColor = Colors.orange.withValues(alpha: 0.15);
        textColor = Colors.orangeAccent;
        statusIcon = Icons.remove_circle_outline;
        iconColor = Colors.orangeAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text("Momentum: ${channel!.momentum}",
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsColumn() {
    return Column(
      children: [
        _buildIntelligenceCard(
          title: "Engagement Quality",
          value: channel!.engagementScore.toString(),
          label: "/ 10",
          description: "Strong comment activity suggests loyal audience interaction.",
          icon: Icons.bolt,
          accentColor: Colors.blueAccent,
          progress: channel!.engagementScore / 10,
        ),
        _buildIntelligenceCard(
          title: "Consistency Score",
          value: channel!.consistencyScore,
          label: "",
          badgeText: channel!.consistencyScore,
          description: "Average upload gap: ${channel!.avgUploadGap} days\nIrregular posting may slow algorithm momentum.",
          icon: Icons.access_time,
          accentColor: Colors.orange,
        ),
        _buildIntelligenceCard(
          title: "Subscriber Conversion",
          value: "${channel!.subscriberConversion}%",
          label: "",
          description: "of subscribers watch new uploads. Improve call-to-action prompts.",
          icon: Icons.track_changes,
          accentColor: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildIntelligenceCard({
    required String title,
    required String value,
    required String label,
    required String description,
    required IconData icon,
    required Color accentColor,
    double? progress,
    String? badgeText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111729),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: accentColor.withValues(alpha: 0.25)
                  ),
                  child: Icon(icon, color: accentColor, size: 20)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(color: Color(0xFF7BA8FF), fontSize: 28, fontWeight: FontWeight.bold)),
              if (label.isNotEmpty) Text(" $label", style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16)),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              color: const Color(0xFF22C55E),
              minHeight: 6,
            ),
          ],
          if (badgeText != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(badgeText, style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
          const SizedBox(height: 12),
          Text(description, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
        ],
      ),
    );
  }
}
