import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hjalpguiden/providers/providers.dart';

class SelectLanguageScreen extends ConsumerWidget {
  const SelectLanguageScreen({super.key});

  static final List<LanguageOption> _languages = [
    LanguageOption('sv', 'Svenska', 'Svenska', '🇸🇪'),
    LanguageOption('ar', 'العربية', 'Arabiska', '🇸🇦'),
    LanguageOption('so', 'Soomaali', 'Somaliska', '🇸🇴'),
    LanguageOption('ti', 'ትግርኛ', 'Tigrinska', '🇪🇷'),
    LanguageOption('fa', 'فارسی', 'Persiska (Farsi)', '🇮🇷'),
    LanguageOption('prs', 'دری', 'Dari', '🇦🇫'),
    LanguageOption('uk', 'Українська', 'Ukrainska', '🇺🇦'),
    LanguageOption('ru', 'Русский', 'Ryska', '🇷🇺'),
    LanguageOption('tr', 'Türkçe', 'Turkiska', '🇹🇷'),
    LanguageOption('en', 'English', 'Engelska', '🇬🇧'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                'Välj språk',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose language',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    for (final lang in _languages)
                      _LanguageCard(
                        language: lang,
                        onTap: () {
                          ref.read(selectedLanguageProvider.notifier).state =
                              lang.code;
                          context.go('/home');
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageOption {
  final String code;
  final String endonym;
  final String swedish;
  final String flag;

  LanguageOption(this.code, this.endonym, this.swedish, this.flag);
}

class _LanguageCard extends StatelessWidget {
  final LanguageOption language;
  final VoidCallback onTap;

  const _LanguageCard({required this.language, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Välj ${language.swedish}',
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(language.flag, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  language.endonym,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (language.swedish != language.endonym) ...[
                  const SizedBox(height: 4),
                  Text(
                    language.swedish,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
