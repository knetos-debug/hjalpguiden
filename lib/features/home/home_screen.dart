import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hjalpguiden/models/guide.dart' as models;
import 'package:hjalpguiden/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guidesAsync = ref.watch(contentBundleProvider);
    final selectedLang = ref.watch(selectedLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hjälpguiden'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: 'Byt språk',
            onPressed: () {
              ref.read(selectedLanguageProvider.notifier).state = null;
              context.go('/');
            },
          ),
        ],
      ),
      body: guidesAsync.when(
        data: (bundle) {
          if (bundle.guides.isEmpty) {
            return const Center(
              child: Text(
                'Inga guider hittades för det valda språket.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bundle.guides.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final guide = bundle.guides[index];
              return _GuideCard(guide: guide, selectedLang: selectedLang);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kunde inte ladda guider just nu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(contentBundleProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Försök igen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.guide, required this.selectedLang});

  final models.Guide guide;
  final String? selectedLang;

  @override
  Widget build(BuildContext context) {
    final isSwedish = selectedLang == null || selectedLang == 'sv';
    final hasTranslation = !isSwedish && guide.title.hs.isNotEmpty;
    final primaryTitle = hasTranslation ? guide.title.hs : guide.title.svEnkel;
    final secondaryTitle = hasTranslation ? guide.title.svEnkel : null;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.go('/guide/${guide.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                primaryTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (secondaryTitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  secondaryTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Steg: ${guide.steps.length}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (guide.prereq.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Förberedelser: ${guide.prereq.length}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => context.go('/guide/${guide.id}'),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Öppna'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
