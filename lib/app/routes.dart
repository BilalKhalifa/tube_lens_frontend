import 'package:flutter/material.dart';

import 'package:tube_lens/features/analysis_page/analyze_page.dart';
import 'package:tube_lens/features/compare_page/compare_page.dart';
import '../features/home/home_page.dart';
import '../features/profile/profile_page.dart';

class Routes {
  static const home = '';
  static const personal = '/personal';
  static const profile = '/profile';
  static const compare = "/compare";

  static Map<String, WidgetBuilder> get map => {
    home: (_) => const HomePage(),
    personal: (_) => const AnalyzePage(),
    profile: (_) => const ProfilePage(),
    compare: (_) => ComparePage()
  };
}

