import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:tube_lens/features/analysis_page/analyze_page.dart';
import 'package:tube_lens/features/compare_page/compare_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import 'dart:ui';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    AnalyzePage(),
    ComparePage(),
    ProfilePage(),
  ];

  final List<Color> _activeColor = const [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.deepOrange,
    Colors.purpleAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _LiquidGlassNavBar(
              currentIndex: _currentIndex,
              activeColor: _activeColor[_currentIndex],
              onTap: (index) => setState(() => _currentIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidGlassNavBar extends StatefulWidget {
  final int currentIndex;
  final Color activeColor;
  final ValueChanged<int> onTap;

  const _LiquidGlassNavBar({
    required this.currentIndex,
    required this.activeColor,
    required this.onTap,
  });

  @override
  State<_LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<_LiquidGlassNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pillPosition;

  double _previousIndex = 0;
  double _targetIndex = 0;

  static const double navHeight = 64;
  static const double pillHeight = 50;
  static const double pillWidth = 68;
  static const int itemCount = 4;

  final List<String> _labels = const ['Home', 'Analyze', 'Compare', 'Profile'];

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex.toDouble();
    _targetIndex = widget.currentIndex.toDouble();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _pillPosition = Tween<double>(
      begin: _previousIndex,
      end: _targetIndex,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
  }

  @override
  void didUpdateWidget(_LiquidGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = _pillPosition.value;
      _targetIndex = widget.currentIndex.toDouble();

      _pillPosition = Tween<double>(
        begin: _previousIndex,
        end: _targetIndex,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: navHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / itemCount;

          return AnimatedBuilder(
            animation: _pillPosition,
            builder: (context, _) {
              final pillLeft =
                  _pillPosition.value * itemWidth + (itemWidth - pillWidth) / 2;

              return Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        height: navHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: pillLeft,
                    child: SizedBox(
                      width: pillWidth,
                      height: pillHeight,
                      child: LiquidGlass.withOwnLayer(
                        settings: LiquidGlassSettings(
                          thickness: 12,
                          blur: 6,
                          refractiveIndex: 1.4,
                          lightIntensity: 1.5,
                          saturation: 1.2,
                          glassColor: widget.activeColor.withValues(alpha: 0.18),
                        ),
                        shape: LiquidRoundedSuperellipse(
                          borderRadius: 28.0,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),

                  // ── Icons + labels row ───────────────────────────────
                  Row(
                    children: List.generate(itemCount, (i) {
                      final isActive = i == widget.currentIndex;
                      final color =
                      isActive ? widget.activeColor : Colors.white70;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => widget.onTap(i),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                scale: isActive ? 1.18 : 1.0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                                child: _buildIcon(i, color),
                              ),
                              const SizedBox(height: 3),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                child: Text(_labels[i]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildIcon(int index, Color color) {
    switch (index) {
      case 0:
        return Icon(Icons.home_rounded, color: color, size: 22);
      case 1:
        return Icon(Symbols.auto_awesome, color: color, size: 22);
      case 2:
        return HugeIcon(
          icon: HugeIconsStrokeRounded.gitCompare,
          color: color,
          size: 22,
        );
      case 3:
        return Icon(CupertinoIcons.profile_circled, color: color, size: 22);
      default:
        return const SizedBox.shrink();
    }
  }
}