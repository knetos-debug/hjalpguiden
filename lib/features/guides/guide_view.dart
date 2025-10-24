import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/guide.dart';
import '../../providers/providers.dart';
import '../../widgets/step_card.dart';

class GuideView extends ConsumerWidget {
  final String guideId;

  const GuideView({super.key, required this.guideId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guide = ref.watch(guideProvider(guideId));

    if (guide == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Laddar...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              guide.title.svEnkel,
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (guide.title.hs.isNotEmpty)
              Text(
                guide.title.hs,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Visa information',
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showInfoDialog(context, guide),
              tooltip: 'Information',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPrerequisites(context, guide.prereq),
          const SizedBox(height: 24),
          _buildSteps(context, guide.steps, ref),
          const SizedBox(height: 24),
          _buildTroubleshooting(context, guide.troubleshoot, ref),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPrerequisites(BuildContext context, List<LangLine> prereq) {
    if (prereq.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Förberedelser',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...prereq.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 18)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.svEnkel,
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (item.hs.isNotEmpty)
                              Text(
                                item.hs,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSteps(BuildContext context, List<GuideStep> steps, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Steg för steg',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: StepCard(
              stepNumber: index + 1,
              step: step,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTroubleshooting(
      BuildContext context, List<Trouble> troubleshoot, WidgetRef ref) {
    if (troubleshoot.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  'Om det strular',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...troubleshoot.map((trouble) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (trouble.stepIndex != null)
                        Text(
                          'Vid steg ${trouble.stepIndex}:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        trouble.svEnkel,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (trouble.hs.isNotEmpty)
                        Text(
                          trouble.hs,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, Guide guide) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (guide.lastVerified != null) ...[
                const Text(
                  'Senast verifierad:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(guide.lastVerified!),
                const SizedBox(height: 16),
              ],
              if (guide.sources.isNotEmpty) ...[
                const Text(
                  'Källor:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...guide.sources.map((source) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(source['label'] ?? ''),
                          if (source['url'] != null)
                            Text(
                              source['url']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stäng'),
          ),
        ],
      ),
    );
  }
}