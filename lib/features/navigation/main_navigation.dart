import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
import 'package:liquid_glass_bottom_navbar_plus/liquid_glass_bottom_navbar_plus.dart';
import 'package:tube_lens/features/analysis_page/analyze_page.dart';
import 'package:tube_lens/features/compare_page/compare_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';

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
      extendBody: true, // Lets content scroll underneath the glass bar
      backgroundColor: const Color(0xFF0B0F1A),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: LiquidGlassBottomBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        settings: const LiquidGlassSettings(
          thickness: 8.0,          // Sleek glass thickness/bevel
          blur: 5.0,               // Ultra-clear glass (minimal frost)
          glassColor: Color(0x0AFFFFFF), // Low opacity white tint for transparent glass look
          outlineIntensity: 0.35,   // Subtle, thin specular highlight outline
          saturation: 1.6,         // Vibrant colors shining through the glass
        ),
        theme: LiquidGlassBarTheme(
          selectedIconColor: _activeColor[_currentIndex],
          pillColor: _activeColor[_currentIndex].withValues(alpha: 0.12),
          showLabels: true,
          selectedLabelStyle: TextStyle(
            color: _activeColor[_currentIndex],
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          labelStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
        items: [
          const LiquidGlassBarItem(
            icon: Icon(Icons.home_rounded),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
            tint: Colors.redAccent,
          ),
          const LiquidGlassBarItem(
            icon: Icon(Icons.auto_awesome_rounded),
            selectedIcon: Icon(Icons.auto_awesome_rounded),
            label: 'Analyze',
            tint: Colors.blueAccent,
          ),
          LiquidGlassBarItem(
            icon: HugeIcon(
              icon: HugeIconsStrokeRounded.gitCompare,
              color: _currentIndex == 2 ? Colors.deepOrange : Colors.white70,
              size: 22,
            ),
            selectedIcon: const HugeIcon(
              icon: HugeIconsStrokeRounded.gitCompare,
              color: Colors.deepOrange,
              size: 22,
            ),
            label: 'Compare',
            tint: Colors.deepOrange,
          ),
          const LiquidGlassBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            selectedIcon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
            tint: Colors.purpleAccent,
          ),
        ],
      ),
    );
  }
}