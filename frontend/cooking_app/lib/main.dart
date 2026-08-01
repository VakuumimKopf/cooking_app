import 'package:cooking_app/core/layout/main_shell_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail App',
      debugShowCheckedModeBanner: false, // Blendet das 'Debug'-Banner oben rechts aus
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      // Hier setzen wir deinen CocktailListScreen als Einstiegspunkt:
      home: const MainShellScreen(),
    );
  }
}