import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hjalpguiden/models/guide.dart' as models;
import 'package:hjalpguiden/providers/providers.dart';
import 'package:hjalpguiden/widgets/step_card.dart';

class GuideView extends ConsumerWidget {
  final String guideId;

  const GuideView({super.key, required this.guideId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guide = ref.watch(guideProvider(guideId));
    final selectedLang = ref.watch(selectedLanguageProvider);

    if (guide == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Laddar...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isSwedish = selectedLang == null || selectedLang == 'sv';
    final hasTranslation = !isSwedish && guide.title.hs.isNotEmpty;
    final primaryTitle = hasTranslation ? guide.title.hs : guide.title.svEnkel;
    final secondaryTitle = hasTranslation ? guide.title.svEnkel : null;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              primaryTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (secondaryTitle != null)
              Text(
                secondaryTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
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
          _buildSteps(context, guide.steps, guide.id, ref),
          const SizedBox(height: 24),
          _buildTroubleshooting(context, guide.troubleshoot, ref),
          const SizedBox(height: 32),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Tillbaka till alla guider'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPrerequisites(
    BuildContext context,
    List<models.LangLine> prereq,
  ) {
    if (prereq.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Förberedelser',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...prereq.map(
              (item) => Padding(
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
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSteps(
    BuildContext context,
    List<models.Step> steps,
    String guideId,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Steg för steg',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: StepCard(
              guideId: guideId,
              stepNumber: index + 1,
              step: step,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTroubleshooting(
    BuildContext context,
    List<models.Trouble> troubleshoot,
    WidgetRef ref,
  ) {
    if (troubleshoot.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  'Om det strular',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...troubleshoot.map(
              (trouble) => Padding(
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
                          color: Colors.orange[800],
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(trouble.svEnkel, style: const TextStyle(fontSize: 16)),
                    if (trouble.hs.isNotEmpty)
                      Text(
                        trouble.hs,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, models.Guide guide) {
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
                ...guide.sources.map(
                  (source) => Padding(
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
                  ),
                ),
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
