import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tube_lens/app/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://fduxpglsgzmiomggwlei.supabase.co',
      publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZkdXhwZ2xzZ3ptaW9tZ2d3bGVpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM4Mjc3MjAsImV4cCI6MjA5OTQwMzcyMH0.9nZOtSTNR94XHn_ygmSuS9HIA9Wu2d3Wg0cs5LiIX0I',
  );

  runApp(const YTAnalyzerApp());
}

