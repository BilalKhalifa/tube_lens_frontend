import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tube_lens/shared/widgets/ai_insights_section.dart';
import 'package:tube_lens/shared/widgets/quick_analytics_section.dart';
import 'package:tube_lens/widget/home_page_widget/glass_search_card.dart';
import 'package:tube_lens/widget/home_page_widget/mode_selector.dart';

import '../analysis/models/channel_model.dart';
import '../analysis/services/analysis_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController urlController = TextEditingController();

  ChannelModel? channel;
  bool isLoading = false;
  String? errorMessage;

  Future<void> analyzeChannel() async {
    print("Pressed");
    print("Input: ${urlController.text}");

    final input = urlController.text.trim();
    if (input.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final formattedInput = input.startsWith("http")
          ? input
          : "https://youtube.com/$input";

      final result =
      await AnalysisService.analyzeChannel(formattedInput);

      setState(() {
        channel = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(color: const Color(0xFF0B0F1A)),
          Positioned(
            top: -135,
            left: -135,
            child: _glow(const Color(0xFFFF3B3B))
          ), //Red Glow
          Positioned(
            bottom: -150,
            right: -150,
            child: _glow(const Color(0xFF3B82F6))
            ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 420,
                pinned: false,
                floating: false,
                elevation: 0,
                backgroundColor: const Color(0xFF0B0F1A),

                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [

                          SizedBox(height: kToolbarHeight + 20),

                          Text(
                            "TUBE LENS",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Analyze YouTube channels using public data & AI",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),

                          SizedBox(height: 30),

                          GlassSearchCard(
                            controller: urlController,
                            onAnalyze: analyzeChannel,
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Enter Youtube channel or @Username",
                            buttonText: "Analyze",
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: ModeSelector(),
                ),
              ),//ModeSelector
              SliverToBoxAdapter(
                child: QuickAnalyticsSection(channel: channel),
              ),//Quick Analysis
              SliverToBoxAdapter(
                child: AiInsightsSection(),
              ),//Ai Insight
              SliverToBoxAdapter(
                child: SizedBox(height: 80), // space for floating nav
              ),
            ],
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
            colors: [color.withValues(alpha: 0.6), Colors.transparent],
          ),
        ),
      ),
    );
  }
}
