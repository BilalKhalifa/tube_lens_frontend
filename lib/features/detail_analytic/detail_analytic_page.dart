import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';
import 'package:tube_lens/features/detail_analytic/key_matrics.dart';
import 'package:tube_lens/features/detail_analytic/performance_intelligence.dart';
import 'package:tube_lens/features/detail_analytic/upload_time_heat_map.dart';
import 'package:tube_lens/utils/number_formatter.dart';

class DetailAnalyticPage extends StatelessWidget {
  final ChannelModel? channel;

  const DetailAnalyticPage({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🔥 SLIVER APP BAR
          SliverAppBar(
            expandedHeight: 250,
            pinned: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF004e8f),
                      Color(0xFF72c6ef),
                      Color(0xFF004e8f)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Back + Title
                    Row(
                      children: [

                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            child: const Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        const Expanded(
                          child: Hero(
                            tag: "detail_analytic_text",
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                "View Detail Analytics",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Channel Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                          NetworkImage(channel!.thumbnail),
                          backgroundColor: Colors.white12,
                        ),

                        const SizedBox(width: 20),

                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              channel!.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${NumberFormatter.format(channel!.subscribers)} Subscribers",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 👇 Your analytics content below
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Channel Performance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          //👇  Performance Intelligence
          SliverToBoxAdapter(
              child: PerformanceIntelligence(channel: channel)
          ),
          //Key Matrics
          SliverToBoxAdapter(
            child: KeyMatrics(channel: channel),
          ),
          
          //HeatMap
          SliverToBoxAdapter(
            child: UploadTimeHeatMap(channel: channel),
          )
        ],
      ),
    );
  }
}