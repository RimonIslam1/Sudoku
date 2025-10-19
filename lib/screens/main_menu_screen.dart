import 'package:flutter/material.dart';
import 'package:sudoku_app/screens/difficulties_screen.dart';
import 'package:sudoku_app/screens/settings_screen.dart';
import 'package:sudoku_app/screens/rules_screen.dart';
import 'package:sudoku_app/screens/techniques_screen.dart';
import 'package:sudoku_app/screens/leaderboard_screen.dart';
import 'package:sudoku_app/screens/solved_puzzles_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // App Title
                Text(
                  'SUDOKU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose Your Challenge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 24),
                // Menu Buttons
                _buildMenuButton(
                  context,
                  'Difficulties',
                  Icons.trending_up,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DifficultiesScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuButton(
                  context,
                  'Rules',
                  Icons.rule,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RulesScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuButton(
                  context,
                  'Solving Techniques',
                  Icons.lightbulb_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TechniquesScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuButton(
                  context,
                  'Solved Puzzles',
                  Icons.checklist,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SolvedPuzzlesScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuButton(
                  context,
                  'Leaderboard',
                  Icons.leaderboard,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuButton(
                  context,
                  'Settings',
                  Icons.settings,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Challenge Your Mind',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
