import 'package:flutter/material.dart';
import 'package:tube_lens/features/analysis/models/channel_model.dart';

class UploadTimeHeatMap extends StatefulWidget {
  final ChannelModel? channel;

  const UploadTimeHeatMap({super.key, required this.channel});

  static const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  static const slots = ["12AM", "6AM", "12PM", "6PM", "9PM"];

  @override
  State<UploadTimeHeatMap> createState() => _UploadTimeHeatMapState();
}

class _UploadTimeHeatMapState extends State<UploadTimeHeatMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Color getColor(int score) {
    if (score == 0) return const Color(0xff2c315a);
    if (score < 40) return const Color(0xff3f4fa0);
    if (score < 70) return const Color(0xff5c6cff);
    if (score < 90) return const Color(0xff7c8cff);
    return const Color(0xffa5b4ff);
  }

  bool isBestSlot(String day, String slot) {
    if (widget.channel!.bestUploadTime == null) return false;

    return widget.channel!.bestUploadTime!.day.startsWith(day) &&
        widget.channel!.bestUploadTime!.time == slot;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    print('AnimationController duration: ${_animationController.duration}');
  }

  @override
  Widget build(BuildContext context) {
    final heatmap = widget.channel!.getHeatmapGrid();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xff1e2240), Color(0xff2b2f55)],
            ),
            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.4)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.access_time,
                            color: Colors.blueAccent,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Best Upload Time",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 2),

                              Text(
                                "Optimal posting schedule based on engagement",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// PEAK INSIGHT BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          "Peak Insight",
                          style: TextStyle(color: Colors.orange, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// TIME LABELS
              Row(
                children: [
                  const SizedBox(width: 42),

                  ...UploadTimeHeatMap.slots.map(
                        (slot) => Expanded(
                      child: Text(
                        slot,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// HEATMAP GRID
              Column(
                children: List.generate(UploadTimeHeatMap.days.length, (
                    dayIndex,
                    ) {
                  return Row(
                    children: [
                      /// DAY LABEL
                      SizedBox(
                        width: 42,
                        child: Text(
                          UploadTimeHeatMap.days[dayIndex],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      ...List.generate(UploadTimeHeatMap.slots.length, (
                          slotIndex,
                          ) {
                        int score = heatmap[dayIndex][slotIndex];
                        bool best = isBestSlot(
                          UploadTimeHeatMap.days[dayIndex],
                          UploadTimeHeatMap.slots[slotIndex],
                        );

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: AspectRatio(
                              aspectRatio: 1, // keeps cells square
                              child: Container(
                                decoration: BoxDecoration(
                                  color: best
                                      ? const Color(0xffa05a2c)
                                      : getColor(score),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: best
                                    ? RotationTransition(
                                  turns: Tween(begin: 1.0, end: 0.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                )
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 16),

              const Divider(color: Colors.white24),

              const SizedBox(height: 12),

              /// ENGAGEMENT LEGEND
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Low Engagement",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),

                  Row(
                    children: List.generate(
                      5,
                          (index) => Container(
                        width: 18,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color.lerp(
                            const Color(0xff2f355c),
                            const Color(0xff7b61ff),
                            index / 4,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Text(
                    "High Engagement",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// INSIGHT BOX
              if (widget.channel!.bestUploadTime != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xff3c3f85), Color(0xff2d2f6e)],
                      ),
                      border: Border.all(
                        color: Colors.blueAccent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      "${widget.channel!.bestUploadTime!.day} "
                          "${widget.channel!.bestUploadTime!.time} "
                          "shows the highest engagement at "
                          "${widget.channel!.bestUploadTime!.engagement}%",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
