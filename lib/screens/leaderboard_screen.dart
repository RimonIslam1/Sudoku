import 'package:flutter/material.dart';
import 'package:sudoku_app/models/leaderboard_entry.dart';
import 'package:sudoku_app/services/storage_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final StorageService _storage = StorageService();
  List<LeaderboardEntry> _entries = [];
  String _filterDifficulty = 'All';
  String _sort = 'Fastest';

  @override
  void initState() {
    super.initState();
    _load();
    _storage.leaderboardUpdates.listen((_) => _load());
  }

  Future<void> _load() async {
    final items = await _storage.getLeaderboard();
    setState(() {
      _entries = items;
    });
  }

  List<LeaderboardEntry> get _filtered {
    List<LeaderboardEntry> list = _entries;
    if (_filterDifficulty != 'All') {
      list = list.where((e) => e.difficulty == _filterDifficulty).toList();
    }
    list.sort((a, b) => _sort == 'Fastest'
        ? a.elapsedTime.compareTo(b.elapsedTime)
        : b.completedAt.compareTo(a.completedAt));
    return list.take(50).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _filterDifficulty,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Easy', child: Text('Easy')),
                    DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'Hard', child: Text('Hard')),
                  ],
                  onChanged: (v) => setState(() => _filterDifficulty = v!),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _sort,
                  items: const [
                    DropdownMenuItem(value: 'Fastest', child: Text('Fastest')),
                    DropdownMenuItem(value: 'Recent', child: Text('Recent')),
                  ],
                  onChanged: (v) => setState(() => _sort = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No entries yet',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final e = _filtered[index];
                        final rank = index + 1;
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.15),
                              child: Text(
                                '$rank',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text('${e.playerName} • ${e.difficulty}'),
                            subtitle: Text(
                              _formatDuration(e.elapsedTime) +
                                  ' • ' +
                                  e.completedAt.toLocal().toString(),
                            ),
                            trailing: Text('Solved: ${e.puzzlesSolved}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
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
