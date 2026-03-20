import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';
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
    ProfilePage()
  ];

  final List<Color> _activeColor = const [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.deepOrange,
    Colors.purpleAccent
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15)
                    )
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    currentIndex: _currentIndex,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: _activeColor[_currentIndex],
                    unselectedItemColor: Colors.white70,
                    onTap: (index) {
                      setState(() =>
                        _currentIndex = index
                      );
                    },
                    items: const[
                      BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
                      BottomNavigationBarItem(icon: Icon(Symbols.auto_awesome), label: "Analyze"),
                      BottomNavigationBarItem(icon: HugeIcon(icon: HugeIconsStrokeRounded.gitCompare), label: "Compare"),
                      BottomNavigationBarItem(icon: Icon(CupertinoIcons.profile_circled), label: "Profile")
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
