import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_app/models/solved_puzzle.dart';
import 'package:sudoku_app/providers/game_provider.dart';
import 'package:sudoku_app/screens/game_screen.dart';
import 'package:sudoku_app/services/storage_service.dart';

class SolvedPuzzlesScreen extends StatefulWidget {
  const SolvedPuzzlesScreen({super.key});

  @override
  State<SolvedPuzzlesScreen> createState() => _SolvedPuzzlesScreenState();
}

class _SolvedPuzzlesScreenState extends State<SolvedPuzzlesScreen> {
  final StorageService _storage = StorageService();
  List<SolvedPuzzle> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
    _storage.solvedUpdates.listen((_) => _load());
  }

  Future<void> _load() async {
    final items = await _storage.getSolvedPuzzles();
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solved Puzzles'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _items.isEmpty
            ? const Center(child: Text('No solved puzzles yet'))
            : ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final p = _items[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                          '${p.difficulty} • ${_formatDuration(p.elapsedTime)}'),
                      subtitle: Text(p.completedAt.toLocal().toString()),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () {
                              final game = Provider.of<GameProvider>(context,
                                  listen: false);
                              game.loadPuzzle(p.originalBoard, p.solutionBoard,
                                  p.difficulty);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const GameScreen()),
                              );
                            },
                            child: const Text('View'),
                          ),
                          FilledButton(
                            onPressed: () {
                              final game = Provider.of<GameProvider>(context,
                                  listen: false);
                              game.loadPuzzle(p.originalBoard, p.solutionBoard,
                                  p.difficulty);
                              game.resetGame();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const GameScreen()),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:$m:$s';
    }
    return '$m:$s';
  }
}
