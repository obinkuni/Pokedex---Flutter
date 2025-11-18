import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'pages/pokedex_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const PokedexPage(),
    );
  }
}
