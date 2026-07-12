import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Import Supabase
import '../features/auth/pages/login_page.dart'; // 2. Import your Login Page
import '../features/navigation/main_navigation.dart';
import 'routes.dart';

class YTAnalyzerApp extends StatelessWidget {
  const YTAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Get the current session from Supabase
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Noto-font',
      ),
      routes: Routes.map,
      // 4. If session is not null, load MainNavigation. Otherwise, load LoginPage!
      home: session != null ? const MainNavigation() : const LoginPage(),
    );
  }
}