import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const SocialAutopsyApp());

class SocialAutopsyApp extends StatelessWidget {
  const SocialAutopsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social autopsy',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
