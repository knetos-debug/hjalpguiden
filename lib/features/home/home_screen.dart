import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../models/guide.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(contentBundleProvider);
    final selectedLang = ref.watch(selectedLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hjälpguiden'),
        actions: [
          Semantics(
            button: true,
            label: 'Byt språk',
            child: IconButton(
              icon: const Icon(Icons.language),
              onPressed: () => context.go('/'),
              tooltip: 'Byt språk',
            ),
          ),
        ],
      ),
      body: contentAsync.when(
        data: (bundle) => _buildGuideGrid(context, bundle.guides),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Kunde inte ladda guider: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(contentBundleProvider),
                child: const Text('Försök igen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideGrid(BuildContext context, List<Guide> guides) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index];
        return _GuideCard(guide: guide);
      },
    );
  }
}

class _GuideCard extends StatelessWidget {
  final Guide guide;

  const _GuideCard({required this.guide});

  IconData _getModuleIcon(Module module) {
    switch (module) {
      case Module.BankID:
        return Icons.security;
      case Module.m1177:
        return Icons.local_hospital;
      case Module.Kivra:
        return Icons.mail;
      case Module.AF:
        return Icons.work;
      case Module.Skatteverket:
        return Icons.account_balance;
      case Module.FK:
        return Icons.family_restroom;
      case Module.Epost:
        return Icons.email;
      case Module.Mobil:
        return Icons.phone_android;
      case Module.AI:
        return Icons.translate;
      case Module.Kommun:
        return Icons.location_city;
      case Module.Trygghet:
        return Icons.favorite;
    }
  }

  Color _getModuleColor(Module module) {
    switch (module) {
      case Module.BankID:
        return Colors.blue;
      case Module.m1177:
        return Colors.green;
      case Module.Kivra:
        return Colors.orange;
      case Module.AF:
        return Colors.purple;
      case Module.Skatteverket:
        return Colors.indigo;
      case Module.FK:
        return Colors.teal;
      case Module.Epost:
        return Colors.red;
      case Module.Mobil:
        return Colors.cyan;
      case Module.AI:
        return Colors.amber;
      case Module.Kommun:
        return Colors.brown;
      case Module.Trygghet:
        return Colors.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getModuleColor(guide.module);
    final icon = _getModuleIcon(guide.module);

    return Semantics(
      button: true,
      label: 'Öppna guide: ${guide.title.svEnkel}',
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () => context.go('/guide/${guide.id}'),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 26, color: color),
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Text(
                      guide.title.svEnkel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (guide.title.hs.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        guide.title.hs,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}