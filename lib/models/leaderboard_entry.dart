import 'dart:convert';

class LeaderboardEntry {
  final String id; // unique id
  final String playerName;
  final String difficulty;
  final Duration elapsedTime;
  final int puzzlesSolved;
  final DateTime completedAt;

  const LeaderboardEntry({
    required this.id,
    required this.playerName,
    required this.difficulty,
    required this.elapsedTime,
    required this.puzzlesSolved,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerName': playerName,
        'difficulty': difficulty,
        'elapsedMs': elapsedTime.inMilliseconds,
        'puzzlesSolved': puzzlesSolved,
        'completedAt': completedAt.toIso8601String(),
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        id: json['id'],
        playerName: json['playerName'] ?? 'Player',
        difficulty: json['difficulty'],
        elapsedTime: Duration(milliseconds: json['elapsedMs'] as int),
        puzzlesSolved: json['puzzlesSolved'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );

  static String encodeList(List<LeaderboardEntry> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<LeaderboardEntry> decodeList(String data) {
    if (data.isEmpty) return [];
    final List<dynamic> parsed = jsonDecode(data);
    return parsed.map((e) => LeaderboardEntry.fromJson(e)).toList();
  }
}
