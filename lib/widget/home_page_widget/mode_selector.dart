import 'package:flutter/material.dart';

enum ChannelMode { personal , other }

class ModeSelector extends StatefulWidget {
  const ModeSelector({super.key});

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector> {

  ChannelMode selectedMode = ChannelMode.personal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return isMobile
            ? Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: _buildCard(ChannelMode.personal)
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _buildCard(ChannelMode.other)
                  )
          ],
          )
                  : Row(
                      children: [
                        Expanded(child: _buildCard(ChannelMode.personal)),
                        SizedBox(width: 16),
                        Expanded(child: _buildCard(ChannelMode.other))
                      ],
                  );
        },
    );
  }

  Widget _buildCard(ChannelMode mode){
    bool isSelected = selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
      },
      
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF111827),
          border: Border.all(
            color: isSelected
                ?(mode == ChannelMode.personal
                        ? Colors.redAccent
                        : Colors.deepOrange
                ): Colors.white.withValues(alpha: 0.08)
          ),
          boxShadow: isSelected
            ? [
              BoxShadow(
                color: (mode == ChannelMode.personal
                            ? Colors.redAccent
                            : Colors.deepOrange)
                    .withValues(alpha: 0.4),
                blurRadius: 20,
              )
          ] : []
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isSelected
                  ? (mode == ChannelMode.personal
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      :Colors.deepOrange.withValues(alpha: 0.15)
                  )
                  :Colors.white.withValues(alpha: 0.05)
              ),
              child: Icon(
              mode == ChannelMode.personal
                  ?Icons.person_outline
                  :Icons.bar_chart,
              color: isSelected
                  ? (
              mode == ChannelMode.personal
                  ?Colors.redAccent
                  :Colors.deepOrange)
                  :Colors.white54,
        )
              ),
            const SizedBox(height: 16),
            Text(
              mode == ChannelMode.personal
                  ? "Your Channel"
                  : "Other Channel",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mode == ChannelMode.personal
                  ?"Public statistics\nGrowth insights\nAI suggestions"
                  :"Channel comparison\nContent strategy\nTrend analysis",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white60
              ),
            )
          ],
        ),
      ),
    );
  }
}
