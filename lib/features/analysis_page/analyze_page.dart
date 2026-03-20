import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';
import 'package:tube_lens/features/analysis/services/analysis_service.dart';
import 'package:tube_lens/features/analysis_page/detail_analysis_section.dart';
import 'package:tube_lens/features/analysis_page/recent_search_section.dart';
import 'package:tube_lens/shared/widgets/header_section.dart';
import 'package:tube_lens/widget/home_page_widget/glass_search_card.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {

  ChannelModel? channel;
  final TextEditingController controller = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  final List<String> recentSearch = [];

  Future<void> analyzeChannel() async {
    final input = controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      recentSearch.remove(input);
      recentSearch.insert(0, input);

      if (recentSearch.length > 10) {
        recentSearch.removeLast();
      }

      isLoading = true;
      channel = null;
      errorMessage = null;
    });

    try {
      final result = await AnalysisService.analyze(input);

      setState(() {
        channel = result;
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
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0F1A),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(
                    header: "Analyze Channel",
                    subHeader: "Discover insights instantly"
                ),
                SizedBox(height: 30),
                GlassSearchCard(
                    controller: controller,
                    onAnalyze: analyzeChannel,
                    prefixIcon: Icon(Icons.youtube_searched_for_sharp),
                    hintText: "Enter Channel Name or URL",
                    buttonText: "Search",
                    color: Colors.lightBlueAccent),
                SizedBox(height: 10),
                RecentSearchSection(
                    searches: recentSearch,
                    onTap: (value){
                      controller.text = value;
                      analyzeChannel();
                    }),
                SizedBox(height: 20),
                if(channel!= null) ...[
                  SizedBox(height: 20),
                  DetailAnalysisSection(channel: channel)
                ],
                SizedBox(height: 80)
              ],
            ),
          )),
    );
  }
}
