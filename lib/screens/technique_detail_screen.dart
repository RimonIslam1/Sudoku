import 'package:flutter/material.dart';
import 'package:sudoku_app/models/technique_data.dart';
import 'package:sudoku_app/widgets/technique_grid.dart';

class TechniqueDetailScreen extends StatefulWidget {
  final SolvingTechnique technique;

  const TechniqueDetailScreen({
    super.key,
    required this.technique,
  });

  @override
  State<TechniqueDetailScreen> createState() => _TechniqueDetailScreenState();
}

class _TechniqueDetailScreenState extends State<TechniqueDetailScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _autoPlayController;
  int _currentStepIndex = 0;
  bool _understood = false;
  bool _isAutoPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _autoPlayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _play();
  }

  void _play() {
    _controller.forward(from: 0);
  }

  void _nextStep() {
    if (_currentStepIndex < widget.technique.steps.length - 1) {
      setState(() => _currentStepIndex += 1);
      _play();
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex -= 1);
      _play();
    }
  }

  void _replay() {
    _play();
  }

  void _toggleAutoPlay() {
    setState(() {
      _isAutoPlaying = !_isAutoPlaying;
    });
    
    if (_isAutoPlaying) {
      _autoPlayController.repeat();
      _autoPlayController.addListener(_autoPlayListener);
    } else {
      _autoPlayController.stop();
      _autoPlayController.removeListener(_autoPlayListener);
    }
  }

  void _autoPlayListener() {
    if (_autoPlayController.isCompleted) {
      if (_currentStepIndex < widget.technique.steps.length - 1) {
        _nextStep();
      } else {
        setState(() => _isAutoPlaying = false);
        _autoPlayController.stop();
        _autoPlayController.removeListener(_autoPlayListener);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoPlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentStep = widget.technique.steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.technique.name),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'auto_play') {
                _toggleAutoPlay();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'auto_play',
                child: Row(
                  children: [
                    Icon(_isAutoPlaying ? Icons.pause : Icons.play_arrow),
                    const SizedBox(width: 8),
                    Text(_isAutoPlaying ? 'Stop Auto-play' : 'Start Auto-play'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Technique Info Card
              _buildInfoCard(context, colorScheme),

              const SizedBox(height: 16),

              // Animated Grid with Controls
              _buildGridCard(context, colorScheme, currentStep),

              const SizedBox(height: 16),

              // Current Step Explanation
              _buildStepCard(context, colorScheme, currentStep),

              const SizedBox(height: 16),

              // Tips Section
              if (widget.technique.tips.isNotEmpty) ...[
                _buildTipsCard(context, colorScheme),
                const SizedBox(height: 16),
              ],

              // Examples Section
              if (widget.technique.examples.isNotEmpty) ...[
                _buildExamplesCard(context, colorScheme),
                const SizedBox(height: 16),
              ],

              // Understanding Check
              _buildUnderstandingCard(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ColorScheme colorScheme) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.technique.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              _buildDifficultyChip(widget.technique.difficulty, colorScheme),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.technique.description,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          if (widget.technique.prerequisites.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Prerequisites:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.technique.prerequisites.join(', '),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, ColorScheme colorScheme, TechniqueStep currentStep) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStepIndex + 1} of ${widget.technique.steps.length}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Previous step',
                    onPressed: _currentStepIndex > 0 ? _prevStep : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    tooltip: 'Replay current step',
                    onPressed: _replay,
                    icon: const Icon(Icons.replay),
                  ),
                  IconButton(
                    tooltip: 'Next step',
                    onPressed: _currentStepIndex < widget.technique.steps.length - 1 ? _nextStep : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: TechniqueGrid(
              step: currentStep,
              controller: _controller,
              cellSize: 35.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, ColorScheme colorScheme, TechniqueStep currentStep) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Step',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentStep.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
          if (currentStep.explanation != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentStep.explanation!,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context, ColorScheme colorScheme) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.technique.tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildExamplesCard(BuildContext context, ColorScheme colorScheme) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Examples',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.technique.examples.map((example) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        example,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildUnderstandingCard(BuildContext context, ColorScheme colorScheme) {
    return _buildCard(
      context,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Did you understand this technique?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          FilterChip(
            selected: _understood,
            onSelected: (v) => setState(() => _understood = v),
            label: Text(_understood ? 'Yes' : 'Tap Yes'),
            avatar: Icon(
              _understood ? Icons.check_circle : Icons.help_outline,
              color: _understood ? Colors.green : colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty, ColorScheme colorScheme) {
    Color chipColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        chipColor = Colors.green;
        break;
      case 'medium':
        chipColor = Colors.orange;
        break;
      case 'hard':
        chipColor = Colors.red;
        break;
      case 'expert':
        chipColor = Colors.purple;
        break;
      default:
        chipColor = colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

