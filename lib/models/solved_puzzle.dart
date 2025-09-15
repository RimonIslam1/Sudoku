import 'dart:convert';

class SolvedPuzzle {
  final String id; // unique ID, e.g., timestamp or hash
  final String difficulty;
  final List<List<int>> originalBoard; // with zeros for empties
  final List<List<int>> solutionBoard; // full solution
  final Duration elapsedTime;
  final DateTime completedAt;

  const SolvedPuzzle({
    required this.id,
    required this.difficulty,
    required this.originalBoard,
    required this.solutionBoard,
    required this.elapsedTime,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'difficulty': difficulty,
        'originalBoard': originalBoard,
        'solutionBoard': solutionBoard,
        'elapsedMs': elapsedTime.inMilliseconds,
        'completedAt': completedAt.toIso8601String(),
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
