import 'package:flutter/material.dart';
import '../features/navigation/main_navigation.dart';
import 'routes.dart';
// import 'theme.dart';

class YTAnalyzerApp extends StatelessWidget {
  const YTAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Noto-font',
      ),
      routes: Routes.map,
      home: const MainNavigation(),
    );
  }
}