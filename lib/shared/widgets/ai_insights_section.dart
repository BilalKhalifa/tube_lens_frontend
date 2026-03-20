import 'package:flutter/material.dart';

class AiInsightsSection extends StatelessWidget {
  const AiInsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: const [
              Text(
                "AI Insight",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              Icon(
                Icons.auto_awesome_outlined,
                color: Colors.redAccent,
                size: 20,
              )
            ],
          ),
          const SizedBox(height: 8),
          _insightCard(
              icon: Icons.schedule,
              color: Colors.redAccent,
              text: "Best performing videos are 8–12 minutes long"
          ),

          const SizedBox(height: 14),
          
          _insightCard(
              icon: Icons.flash_on,
              color: Colors.deepOrange,
              text: "Upload consistency increased in last 90 days"
          ),

          const SizedBox(height: 14),

          _insightCard(
              icon: Icons.track_changes,
              color: Colors.pinkAccent,
              text: "High contrast thumbnails perform better"
          ),

          const SizedBox(height: 20),

          Center(
            child: InkWell(
              onTap: () {
                print("View Full Analysis Clicked");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "View Full Analysis",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.trending_up,
                    color: Colors.redAccent,
                    size: 16,
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF111827),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08)
                )
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14)
                    ),
                    child: Icon(
                      Icons.privacy_tip,
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Privacy First",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                        const SizedBox(height: 2),

                        Text(
                          "We analyze only publicly available YouTube data. No private access.",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white60
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
          )
        ],
      ),

    );
  }
  static Widget _insightCard({
    required IconData icon,
    required Color color,
    required String text
  }){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Color(0xFF111827),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08)
        )
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14
              ),
            )
          )
        ],
      ),
    );
  }
}
