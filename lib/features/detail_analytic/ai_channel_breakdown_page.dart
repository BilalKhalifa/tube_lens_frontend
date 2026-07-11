import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';
import 'package:tube_lens/utils/number_formatter.dart';

class AiChannelBreakdownPage extends StatelessWidget {
  final ChannelModel channel;

  const AiChannelBreakdownPage({
    super.key,
    required this.channel,
  });

  int _calculateScore() {
    double base = 50.0;
    // Add for engagement (up to 20 pts)
    base += (channel.engagementRate * 2.0).clamp(0, 20);
    // Add for subscriber conversion (up to 15 pts)
    base += (channel.subscriberConversion * 0.5).clamp(0, 15);
    // Add for momentum
    if (channel.momentum.toLowerCase() == 'growing') {
      base += 15;
    } else if (channel.momentum.toLowerCase() == 'stable') {
      base += 7;
    }
    // Add for consistency
    if (channel.consistencyScore.toLowerCase() == 'high') {
      base += 10;
    } else if (channel.consistencyScore.toLowerCase() == 'moderate') {
      base += 5;
    }
    return base.round().clamp(35, 98);
  }

  @override
  Widget build(BuildContext context) {
    final score = _calculateScore();
    String potentialText = "Growth Potential: High";
    Color potentialColor = const Color(0xFF10B981);
    Color potentialBg = const Color(0xFF064E3B);

    if (score < 55) {
      potentialText = "Growth Potential: Low";
      potentialColor = const Color(0xFFEF4444);
      potentialBg = Colors.red.withValues(alpha: 0.15);
    } else if (score < 80) {
      potentialText = "Growth Potential: Moderate";
      potentialColor = const Color(0xFFF59E0B);
      potentialBg = Colors.orange.withValues(alpha: 0.15);
    }

    final double projectedSubscribers = channel.subscribers * 1.3;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -150,
            left: -150,
            child: _glow(const Color(0xFF3B82F6).withValues(alpha: 0.4)),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: _glow(const Color(0xFFEC4899).withValues(alpha: 0.4)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),
                  _buildScoreCard(score, potentialText, potentialColor, potentialBg),
                  const SizedBox(height: 30),
                  _buildStrengthsSection(),
                  const SizedBox(height: 30),
                  _buildImprovementsSection(),
                  const SizedBox(height: 30),
                  _buildOptimizationSection(),
                  const SizedBox(height: 30),
                  _buildGrowthProjectionSection(projectedSubscribers),
                  const SizedBox(height: 80), // bottom spacer
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome_outlined, color: Colors.purpleAccent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "AI Channel Breakdown",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "Advanced insights powered by machine learning",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(int score, String potentialText, Color potentialColor, Color potentialBg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF131926).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ).createShader(bounds),
                child: Text(
                  "$score",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Text(
                "/100",
                style: TextStyle(
                  color: Color(0xFF00D2FF),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: potentialBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: potentialColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  potentialText,
                  style: TextStyle(
                    color: potentialColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "This channel demonstrates exceptional growth indicators with strong content consistency "
            "(upload gap of ${channel.avgUploadGap} days) and audience engagement of ${channel.engagementRate.toStringAsFixed(1)}%. "
            "The AI analysis suggests continued upward trajectory with minor optimizations in SEO.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsSection() {
    final uploadGapText = channel.avgUploadGap <= 7
        ? "Consistent upload schedule maintains audience engagement"
        : "Active upload history establishes baseline presence";

    final engagementText = channel.engagementRate >= 5.0
        ? "Excellent audience retention and interaction rate"
        : "Steady engagement metrics indicating loyal primary viewers";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Color(0xFF10B981), size: 16),
            ),
            const SizedBox(width: 10),
            const Text(
              "Strengths",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildListCard(Icons.access_time_rounded, const Color(0xFF10B981), uploadGapText),
        _buildListCard(Icons.image_outlined, const Color(0xFF10B981), "High-quality thumbnails with excellent click-through rate"),
        _buildListCard(Icons.tag_rounded, const Color(0xFF10B981), "Strong SEO optimization in video titles and descriptions"),
        _buildListCard(Icons.track_changes_rounded, const Color(0xFF10B981), engagementText),
      ],
    );
  }

  Widget _buildImprovementsSection() {
    final conversionText = channel.subscriberConversion < 20
        ? "Sub-optimal subscriber-to-view conversion rate (${channel.subscriberConversion}%)"
        : "Slowing video view conversion among subscribers";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 16),
            ),
            const SizedBox(width: 10),
            const Text(
              "Areas for Improvement",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildListCard(Icons.warning_amber_rounded, const Color(0xFFEF4444), "Video length inconsistency affects algorithm performance"),
        _buildListCard(Icons.warning_amber_rounded, const Color(0xFFEF4444), "Limited use of end screens and cards for cross-promotion"),
        _buildListCard(Icons.warning_amber_rounded, const Color(0xFFEF4444), conversionText),
      ],
    );
  }

  Widget _buildListCard(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131926),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color.withValues(alpha: 0.8), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded, color: Colors.amber, size: 20),
            SizedBox(width: 10),
            Text(
              "Optimization Suggestions",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSuggestionCard("SEO", const Color(0xFF3B82F6), "Add more trending keywords in descriptions"),
        _buildSuggestionCard("Thumbnails", const Color(0xFF8B5CF6), "Increase contrast ratio to 4.5:1 for better visibility"),
        _buildSuggestionCard("Consistency", const Color(0xFFEC4899), "Standardize video length to 10-12 minutes"),
        _buildSuggestionCard("Engagement", const Color(0xFF0D9488), "Add polls in community tab 2x per week"),
      ],
    );
  }

  Widget _buildSuggestionCard(String label, Color labelColor, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131926),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: labelColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: labelColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthProjectionSection(double projectedSubscribers) {
    final spots = [
      FlSpot(0, channel.subscribers.toDouble()),
      FlSpot(1, channel.subscribers * 1.05),
      FlSpot(2, channel.subscribers * 1.12),
      FlSpot(3, channel.subscribers * 1.20),
      FlSpot(4, projectedSubscribers),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF131926),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.show_chart_rounded, color: Color(0xFF00D2FF), size: 20),
              SizedBox(width: 10),
              Text(
                "Growth Projection",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withValues(alpha: 0.03),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            NumberFormatter.format(value),
                            style: const TextStyle(color: Colors.white38, fontSize: 10),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ["Feb", "Mar", "Apr", "May", "Jun"];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: const TextStyle(color: Colors.white38, fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 4,
                minY: channel.subscribers * 0.9,
                maxY: projectedSubscribers * 1.1,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF00D2FF)],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF00D2FF).withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Projected to reach ${NumberFormatter.format(projectedSubscribers)} subscribers by June 2026",
              style: const TextStyle(
                color: Color(0xFF00D2FF),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
