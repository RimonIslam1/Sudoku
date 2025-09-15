import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_app/models/solved_puzzle.dart';
import 'package:sudoku_app/models/leaderboard_entry.dart';

class StorageService {
  static const String _keySolved = 'solved_puzzles_v1';
  static const String _keyLeaderboard = 'leaderboard_entries_v1';
  static const String _keyPlayerName = 'player_name_v1';

  StorageService._internal();
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  final StreamController<void> _leaderboardController =
      StreamController<void>.broadcast();
  final StreamController<void> _solvedController =
      StreamController<void>.broadcast();

  Stream<void> get leaderboardUpdates => _leaderboardController.stream;
  Stream<void> get solvedUpdates => _solvedController.stream;

  Future<List<SolvedPuzzle>> getSolvedPuzzles() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keySolved) ?? '';
    return SolvedPuzzle.decodeList(data);
  }

  Future<void> saveSolvedPuzzle(SolvedPuzzle puzzle) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getSolvedPuzzles();
    // Prevent duplicates by id
    final List<SolvedPuzzle> updated = [
      puzzle,
      ...existing.where((p) => p.id != puzzle.id),
    ];
    await prefs.setString(_keySolved, SolvedPuzzle.encodeList(updated));
    _solvedController.add(null);
  }

  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyLeaderboard) ?? '';
    return LeaderboardEntry.decodeList(data);
  }

  Future<void> addLeaderboardEntry(LeaderboardEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getLeaderboard();
    final List<LeaderboardEntry> updated = [entry, ...existing];
    await prefs.setString(
        _keyLeaderboard, LeaderboardEntry.encodeList(updated));
    _leaderboardController.add(null);
  }

  Future<void> setPlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlayerName, name);
  }

  Future<String> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPlayerName) ?? 'Player';
  }
}
