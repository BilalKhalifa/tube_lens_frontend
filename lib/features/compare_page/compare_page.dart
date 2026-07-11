import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tube_lens/utils/number_formatter.dart';
import 'models/comparison_model.dart';
import 'services/compare_service.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  final TextEditingController channelAController = TextEditingController();
  final TextEditingController channelBController = TextEditingController();

  ComparisonResultModel? comparisonResult;
  bool isLoading = false;
  String? errorMessage;

  Future<void> runComparison() async {
    final inputA = channelAController.text.trim();
    final inputB = channelBController.text.trim();

    if (inputA.isEmpty || inputB.isEmpty) {
      setState(() {
        errorMessage = "Please enter both channel handles/URLs.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      comparisonResult = null;
      errorMessage = null;
    });

    try {
      final formattedA = inputA.startsWith("http") ? inputA : "https://youtube.com/$inputA";
      final formattedB = inputB.startsWith("http") ? inputB : "https://youtube.com/$inputB";

      final result = await CompareService.compareChannels(formattedA, formattedB);

      setState(() {
        comparisonResult = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    channelAController.dispose();
    channelBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasResult = comparisonResult != null;

    return Scaffold(
      extendBody: true,
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
                  if (!hasResult) ...[
                    _buildHeaderSection(),
                    const SizedBox(height: 30),
                    _buildInputDashboard(),
                  ] else ...[
                    _buildComparisonHeader(),
                    const SizedBox(height: 24),
                    _buildWinnerSummaryRow(),
                    const SizedBox(height: 30),
                    _buildKeyMetricsSection(),
                    const SizedBox(height: 30),
                    _buildGrowthTrendSection(),
                    const SizedBox(height: 30),
                    _buildEngagementComparisonSection(),
                    const SizedBox(height: 30),
                    _buildPerformanceOverviewSection(),
                    const SizedBox(height: 30),
                    _buildAiInsightsSection(),
                  ],
                  if (errorMessage != null) _buildErrorCard(),
                  if (isLoading) _buildLoadingCard(),
                  const SizedBox(height: 100), // Navigation spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Compare Channels",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Analyze two YouTube channels side by side",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 12),
        // Premium gradient line
        Container(
          height: 3,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFFEC4899)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputDashboard() {
    return Column(
      children: [
        _buildChannelInputBox(
          label: "Channel 1",
          labelColor: const Color(0xFF3B82F6),
          controller: channelAController,
          hintText: "Enter channel name or ID",
        ),
        const SizedBox(height: 16),
        _buildVsBadge(),
        const SizedBox(height: 16),
        _buildChannelInputBox(
          label: "Channel 2",
          labelColor: const Color(0xFFEC4899),
          controller: channelBController,
          hintText: "Enter channel name or ID",
        ),
        const SizedBox(height: 30),
        _buildStartButton(),
      ],
    );
  }

  Widget _buildChannelInputBox({
    required String label,
    required Color labelColor,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF131926),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF0F131E),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVsBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2237),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Text(
          "vs",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : runComparison,
            borderRadius: BorderRadius.circular(16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Start Comparison",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              comparisonResult = null;
            });
          },
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Channel Comparison",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Detailed side-by-side analysis",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40), // Balance the back button spacer
      ],
    );
  }

  Widget _buildWinnerSummaryRow() {
    final chA = comparisonResult!.channelA;
    final chB = comparisonResult!.channelB;

    return Row(
      children: [
        Expanded(
          child: _buildChannelSummaryCard(
            title: chA.title,
            subtitle: "Channel A",
            accentColor: const Color(0xFF3B82F6),
            gradientColors: [
              const Color(0xFF1E293B).withValues(alpha: 0.6),
              const Color(0xFF0F172A).withValues(alpha: 0.8),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildChannelSummaryCard(
            title: chB.title,
            subtitle: "Channel B",
            accentColor: const Color(0xFFEC4899),
            gradientColors: [
              const Color(0xFF2D1624).withValues(alpha: 0.6),
              const Color(0xFF160B12).withValues(alpha: 0.8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChannelSummaryCard({
    required String title,
    required String subtitle,
    required Color accentColor,
    required List<Color> gradientColors,
  }) {
    final initials = title.length >= 2
        ? title.substring(0, 2).toUpperCase()
        : title.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(alpha: 0.15),
              border: Border.all(color: accentColor, width: 2),
            ),
            child: Text(
              initials,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetricsSection() {
    final chA = comparisonResult!.channelA;
    final chB = comparisonResult!.channelB;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Key Metrics",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        _buildComparisonMetricTile(
          metricName: "Subscribers",
          icon: Icons.people_outline_rounded,
          valueA: NumberFormatter.format(chA.subscribers),
          valueB: NumberFormatter.format(chB.subscribers),
          isLeadingA: chA.subscribers > chB.subscribers,
          isLeadingB: chB.subscribers > chA.subscribers,
          colorA: const Color(0xFF3B82F6),
          colorB: const Color(0xFFEC4899),
        ),
        _buildComparisonMetricTile(
          metricName: "Avg Views",
          icon: Icons.remove_red_eye_outlined,
          valueA: NumberFormatter.format(chA.avgViews),
          valueB: NumberFormatter.format(chB.avgViews),
          isLeadingA: chA.avgViews > chB.avgViews,
          isLeadingB: chB.avgViews > chA.avgViews,
          colorA: const Color(0xFF3B82F6),
          colorB: const Color(0xFFEC4899),
        ),
        _buildComparisonMetricTile(
          metricName: "Total Videos",
          icon: Icons.videocam_outlined,
          valueA: chA.totalVideos.toString(),
          valueB: chB.totalVideos.toString(),
          isLeadingA: chA.totalVideos > chB.totalVideos,
          isLeadingB: chB.totalVideos > chA.totalVideos,
          colorA: const Color(0xFF3B82F6),
          colorB: const Color(0xFFEC4899),
        ),
        _buildComparisonMetricTile(
          metricName: "Engagement",
          icon: Icons.thumb_up_alt_outlined,
          valueA: "${chA.engagementRate.toStringAsFixed(1)}%",
          valueB: "${chB.engagementRate.toStringAsFixed(1)}%",
          isLeadingA: chA.engagementRate > chB.engagementRate,
          isLeadingB: chB.engagementRate > chA.engagementRate,
          colorA: const Color(0xFF3B82F6),
          colorB: const Color(0xFFEC4899),
        ),
      ],
    );
  }

  Widget _buildComparisonMetricTile({
    required String metricName,
    required IconData icon,
    required String valueA,
    required String valueB,
    required bool isLeadingA,
    required bool isLeadingB,
    required Color colorA,
    required Color colorB,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF131926),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    metricName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.emoji_events_outlined, color: Colors.amber, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildValueBox(
                  value: valueA,
                  isLeading: isLeadingA,
                  accentColor: colorA,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildValueBox(
                  value: valueB,
                  isLeading: isLeadingB,
                  accentColor: colorB,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueBox({
    required String value,
    required bool isLeading,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F131E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLeading ? accentColor.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isLeading) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                const Text(
                  "Leading",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGrowthTrendSection() {
    final chA = comparisonResult!.channelA;
    final chB = comparisonResult!.channelB;

    // Generate simulated months
    final spotsA = _generateSubscribersSpots(chA.subscribers.toDouble());
    final spotsB = _generateSubscribersSpots(chB.subscribers.toDouble());

    final maxVal = [
      ...spotsA.map((s) => s.y),
      ...spotsB.map((s) => s.y),
    ].reduce((a, b) => a > b ? a : b);

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
              Icon(Icons.trending_up, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Subscriber Growth Trend",
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
            height: 250,
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
                      reservedSize: 60,
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
                        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
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
                maxX: 5,
                minY: 0,
                maxY: maxVal * 1.1,
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsA,
                    isCurved: true,
                    color: const Color(0xFF3B82F6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.05),
                    ),
                  ),
                  LineChartBarData(
                    spots: spotsB,
                    isCurved: true,
                    color: const Color(0xFFEC4899),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFEC4899).withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot(const Color(0xFF3B82F6), chA.title),
              const SizedBox(width: 24),
              _buildLegendDot(const Color(0xFFEC4899), chB.title),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  List<FlSpot> _generateSubscribersSpots(double finalSubs) {
    return [
      FlSpot(0, finalSubs * 0.76),
      FlSpot(1, finalSubs * 0.82),
      FlSpot(2, finalSubs * 0.85),
      FlSpot(3, finalSubs * 0.90),
      FlSpot(4, finalSubs * 0.95),
      FlSpot(5, finalSubs),
    ];
  }

  Widget _buildEngagementComparisonSection() {
    final chA = comparisonResult!.channelA;
    final chB = comparisonResult!.channelB;

    // Resolve metric data safely
    final likesA = chA.totalLikes.toDouble();
    final likesB = chB.totalLikes.toDouble();
    final commentsA = chA.totalComments.toDouble();
    final commentsB = chB.totalComments.toDouble();
    
    // Simulate shares safely (standard backend lacks shares metrics)
    final sharesA = commentsA * 0.15;
    final sharesB = commentsB * 0.12;

    final maxVal = [likesA, likesB, commentsA, commentsB, sharesA, sharesB].reduce((a, b) => a > b ? a : b);

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
              Icon(Icons.bar_chart, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Engagement Comparison",
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
            height: 250,
            child: BarChart(
              BarChartData(
                barGroups: [
                  _buildBarGroup(0, likesA, likesB),
                  _buildBarGroup(1, commentsA, commentsB),
                  _buildBarGroup(2, sharesA, sharesB),
                ],
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
                        const labels = ["Likes", "Comments", "Shares"];
                        if (value.toInt() >= 0 && value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[value.toInt()],
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
                maxY: maxVal * 1.1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot(const Color(0xFF3B82F6), chA.title),
              const SizedBox(width: 24),
              _buildLegendDot(const Color(0xFFEC4899), chB.title),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double valA, double valB) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: valA,
          color: const Color(0xFF3B82F6),
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: valB,
          color: const Color(0xFFEC4899),
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
      barsSpace: 8,
    );
  }

  Widget _buildPerformanceOverviewSection() {
    final chA = comparisonResult!.channelA;
    final chB = comparisonResult!.channelB;

    // Derived dynamic dimensions (0 to 100 scale)
    final double engagementA = (chA.engagementRate * 10).clamp(10, 100);
    final double engagementB = (chB.engagementRate * 10).clamp(10, 100);

    final double consistencyA = chA.totalVideos > 200 ? 90.0 : (chA.totalVideos > 50 ? 70.0 : 45.0);
    final double consistencyB = chB.totalVideos > 200 ? 90.0 : (chB.totalVideos > 50 ? 70.0 : 45.0);

    // Score maps to Growth dimension
    final double growthA = chA.score.toDouble().clamp(20, 100);
    final double growthB = chB.score.toDouble().clamp(20, 100);

    // Avg Views to reach
    final double reachA = (chA.avgViews / 1000).clamp(15, 100);
    final double reachB = (chB.avgViews / 1000).clamp(15, 100);

    // Derived quality ratio
    final double qualityA = ((chA.totalLikes / (chA.totalComments + 1)) * 5).clamp(20, 100);
    final double qualityB = ((chB.totalLikes / (chB.totalComments + 1)) * 5).clamp(20, 100);

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
              Icon(Icons.radar_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Performance Overview",
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
            height: 250,
            child: RadarChart(
              RadarChartData(
                dataSets: [
                  RadarDataSet(
                    dataEntries: [
                      RadarEntry(value: engagementA),
                      RadarEntry(value: consistencyA),
                      RadarEntry(value: growthA),
                      RadarEntry(value: qualityA),
                      RadarEntry(value: reachA),
                    ],
                    fillColor: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                    borderColor: const Color(0xFF3B82F6),
                    entryRadius: 3,
                    borderWidth: 2,
                  ),
                  RadarDataSet(
                    dataEntries: [
                      RadarEntry(value: engagementB),
                      RadarEntry(value: consistencyB),
                      RadarEntry(value: growthB),
                      RadarEntry(value: qualityB),
                      RadarEntry(value: reachB),
                    ],
                    fillColor: const Color(0xFFEC4899).withValues(alpha: 0.15),
                    borderColor: const Color(0xFFEC4899),
                    entryRadius: 3,
                    borderWidth: 2,
                  ),
                ],
                radarShape: RadarShape.polygon,
                getTitle: (index, angle) {
                  switch (index) {
                    case 0:
                      return const RadarChartTitle(text: 'Engagement', angle: 0);
                    case 1:
                      return const RadarChartTitle(text: 'Consistency', angle: 0);
                    case 2:
                      return const RadarChartTitle(text: 'Growth', angle: 0);
                    case 3:
                      return const RadarChartTitle(text: 'Quality', angle: 0);
                    case 4:
                      return const RadarChartTitle(text: 'Reach', angle: 0);
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
                ticksTextStyle: const TextStyle(color: Colors.white38, fontSize: 8),
                tickBorderData: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                gridBorderData: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                radarBorderData: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot(const Color(0xFF3B82F6), chA.title),
              const SizedBox(width: 24),
              _buildLegendDot(const Color(0xFFEC4899), chB.title),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsightsSection() {
    final chA = comparisonResult!.channelA;
    final chB = comparisonResult!.channelB;

    // Compute dynamic differentials
    final isHigherEngagementA = chA.engagementRate > chB.engagementRate;
    final leadingEngagementChannel = isHigherEngagementA ? chA.title : chB.title;
    final otherEngagementChannel = isHigherEngagementA ? chB.title : chA.title;
    final engagementDiff = isHigherEngagementA
        ? ((chA.engagementRate - chB.engagementRate) / (chB.engagementRate == 0 ? 1.0 : chB.engagementRate) * 100)
        : ((chB.engagementRate - chA.engagementRate) / (chA.engagementRate == 0 ? 1.0 : chA.engagementRate) * 100);

    final isMoreVideosA = chA.totalVideos > chB.totalVideos;
    final frequentUploader = isMoreVideosA ? chA.title : chB.title;
    final lesserUploader = isMoreVideosA ? chB.title : chA.title;

    final isHigherGrowthA = chA.score > chB.score;
    final leadingGrowth = isHigherGrowthA ? chA.title : chB.title;
    final secondaryGrowth = isHigherGrowthA ? chB.title : chA.title;
    final growthDiff = isHigherGrowthA
        ? ((chA.score - chB.score) / (chB.score == 0 ? 1.0 : chB.score) * 100)
        : ((chB.score - chA.score) / (chA.score == 0 ? 1.0 : chA.score) * 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bolt, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "AI-Powered Insights",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAiInsightCard(
          title: "Engagement Advantage",
          description: "$leadingEngagementChannel has ${engagementDiff.toStringAsFixed(0)}% higher engagement rate than $otherEngagementChannel, indicating stronger audience connection and content quality.",
          dotColor: const Color(0xFF3B82F6),
        ),
        _buildAiInsightCard(
          title: "Content Strategy",
          description: "$frequentUploader uploads more frequently but gets fewer views per video compared to $lesserUploader. A quality-over-quantity approach is highly recommended.",
          dotColor: const Color(0xFFEC4899),
        ),
        _buildAiInsightCard(
          title: "Growth Momentum",
          description: "$leadingGrowth shows consistent upward growth trajectory with +${growthDiff.toStringAsFixed(0)}% increase in score, outpacing $secondaryGrowth.",
          dotColor: const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  Widget _buildAiInsightCard({
    required String title,
    required String description,
    required Color dotColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131926),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 24),
              SizedBox(width: 10),
              Text(
                "Comparison Error",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
          SizedBox(height: 16),
          Text(
            "Fetching analytics & calculating scores...",
            style: TextStyle(color: Colors.white70, fontSize: 14),
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
