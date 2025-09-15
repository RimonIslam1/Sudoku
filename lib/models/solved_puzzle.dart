import 'dart:convert';

class SolvedPuzzle {
  final String id; // puzzle_id
  final String difficulty;
  final List<List<int>> originalBoard; // with zeros for empties
  final List<List<int>> solutionBoard; // full solution
  final Duration elapsedTime;
  final DateTime completedAt;
  final int movesCount;
  final int mistakesCount;
  final String? generationSeed;
  final String? userId;
  final String? username;

  const SolvedPuzzle({
    required this.id,
    required this.difficulty,
    required this.originalBoard,
    required this.solutionBoard,
    required this.elapsedTime,
    required this.completedAt,
    this.movesCount = 0,
    this.mistakesCount = 0,
    this.generationSeed,
    this.userId,
    this.username,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'difficulty': difficulty,
        'originalBoard': originalBoard,
        'solutionBoard': solutionBoard,
        'elapsedMs': elapsedTime.inMilliseconds,
        'completedAt': completedAt.toIso8601String(),
        'movesCount': movesCount,
        'mistakesCount': mistakesCount,
        'generationSeed': generationSeed,
        'userId': userId,
        'username': username,
      };

  factory SolvedPuzzle.fromJson(Map<String, dynamic> json) {
    List<dynamic> ob = json['originalBoard'];
    List<dynamic> sb = json['solutionBoard'];
    return SolvedPuzzle(
      id: json['id'],
      difficulty: json['difficulty'],
      originalBoard: ob.map<List<int>>((r) => List<int>.from(r)).toList(),
      solutionBoard: sb.map<List<int>>((r) => List<int>.from(r)).toList(),
      elapsedTime: Duration(milliseconds: json['elapsedMs'] as int),
      completedAt: DateTime.parse(json['completedAt'] as String),
      movesCount: (json['movesCount'] ?? 0) as int,
      mistakesCount: (json['mistakesCount'] ?? 0) as int,
      generationSeed: json['generationSeed'] as String?,
      userId: json['userId'] as String?,
      username: json['username'] as String?,
    );
  }

  static String encodeList(List<SolvedPuzzle> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<SolvedPuzzle> decodeList(String data) {
    if (data.isEmpty) return [];
    final List<dynamic> parsed = jsonDecode(data);
    return parsed.map((e) => SolvedPuzzle.fromJson(e)).toList();
  }
}
