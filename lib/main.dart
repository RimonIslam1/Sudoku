import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/providers/theme_provider.dart';
import 'package:sudoku_app/providers/game_provider.dart';
import 'package:sudoku_app/screens/splash_screen.dart';

void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Sudoku App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: themeProvider.primaryColor,
                brightness: themeProvider.isDarkMode
                    ? Brightness.dark
                    : Brightness.light,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor:
                    themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
                foregroundColor:
                    themeProvider.isDarkMode ? Colors.white : Colors.black,
                elevation: 0, // You can use scrolledUnderElevation for Material 3
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
