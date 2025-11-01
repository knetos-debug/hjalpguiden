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

  IconData _getCategoryIcon(String guideId) {
    if (guideId.contains('1177')) return Icons.local_hospital_rounded;
    if (guideId.contains('kivra')) return Icons.mail_rounded;
    if (guideId.contains('arbetsformedlingen') || guideId.contains('af-')) {
      return Icons.work_rounded;
    }
    if (guideId.contains('skatteverket')) return Icons.account_balance_rounded;
    if (guideId.contains('bankid')) return Icons.fingerprint_rounded;
    if (guideId.contains('mobil')) return Icons.smartphone_rounded;
    if (guideId.contains('oversatt') || guideId.contains('translate')) {
      return Icons.translate_rounded;
    }
    return Icons.help_outline_rounded;
  }

  Color _getCategoryColor(String guideId) {
    if (guideId.contains('1177')) return Colors.blue;
    if (guideId.contains('kivra')) return Colors.green;
    if (guideId.contains('arbetsformedlingen') || guideId.contains('af-')) {
      return Colors.orange;
    }
    if (guideId.contains('skatteverket')) return Colors.purple;
    if (guideId.contains('bankid')) return Colors.teal;
    if (guideId.contains('mobil')) return Colors.indigo;
    if (guideId.contains('oversatt') || guideId.contains('translate')) {
      return Colors.pink;
    }
    return Colors.grey;
  }

  String _getEstimatedTime(int steps) {
    final minutes = (steps * 1.5).ceil();
    return '~$minutes min';
  }

  String _getDifficulty(int steps) {
    if (steps <= 3) return 'Enkelt';
    if (steps <= 5) return 'Medel';
    return 'Avancerat';
  }

  @override
  Widget build(BuildContext context) {
    final isSwedish = selectedLang == null || selectedLang == 'sv';
    final hasTranslation = !isSwedish && guide.title.hs.isNotEmpty;
    final primaryTitle =
        hasTranslation ? guide.title.hs : guide.title.svEnkel;
    final secondaryTitle = hasTranslation ? guide.title.svEnkel : null;
    final categoryIcon = _getCategoryIcon(guide.id);
    final categoryColor = _getCategoryColor(guide.id);

    return Card(
      elevation: 2,
      shadowColor: categoryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => context.go('/guide/${guide.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: categoryColor[700],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          primaryTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                        ),
                        if (secondaryTitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            secondaryTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.list_rounded,
                    label: '${guide.steps.length} steg',
                    color: Colors.blue,
                  ),
                  _InfoChip(
                    icon: Icons.schedule_rounded,
                    label: _getEstimatedTime(guide.steps.length),
                    color: Colors.green,
                  ),
                  _InfoChip(
                    icon: Icons.signal_cellular_alt_rounded,
                    label: _getDifficulty(guide.steps.length),
                    color: Colors.orange,
                  ),
                  if (guide.prereq.isNotEmpty)
                    _InfoChip(
                      icon: Icons.checklist_rounded,
                      label: '${guide.prereq.length} förberedelser',
                      color: Colors.purple,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => context.go('/guide/${guide.id}'),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text(
                      'Öppna guide',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: categoryColor[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color[700],
            ),
          ),
        ],
      ),
    );
  }
}
