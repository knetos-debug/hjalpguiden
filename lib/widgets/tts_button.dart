import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hjalpguiden/providers/providers.dart';

class TtsButton extends ConsumerWidget {
  final String guideId;
  final String translationText;
  final String swedishText;
  final int stepNumber;

  const TtsButton({
    super.key,
    required this.guideId,
    required this.translationText,
    required this.swedishText,
    required this.stepNumber,
  });

  String _normalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed == '[HS]') {
      return '';
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsService = ref.watch(ttsServiceProvider);
    final currentPlaying = ref.watch(ttsPlayingProvider);
    final selectedLang = ref.watch(selectedLanguageProvider);
    final langCode = (selectedLang ?? 'sv').toLowerCase();
    final normalizedTranslation = _normalize(translationText);
    final normalizedSwedish = _normalize(swedishText);
    final playbackText = langCode != 'sv' && normalizedTranslation.isNotEmpty
        ? normalizedTranslation
        : normalizedSwedish.isNotEmpty
        ? normalizedSwedish
        : normalizedTranslation;

    if (playbackText.isEmpty) {
      return const SizedBox.shrink();
    }

    final stepKey = '$guideId-step-$stepNumber';
    final isPlaying = currentPlaying == stepKey;

    return Semantics(
      button: true,
      label: isPlaying
          ? 'Sluta lyssna på steg $stepNumber'
          : 'Lyssna på steg $stepNumber',
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isPlaying
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            isPlaying ? Icons.stop : Icons.volume_up,
            color: isPlaying
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            final notifier = ref.read(ttsPlayingProvider.notifier);

            if (isPlaying) {
              ttsService.stop();
              notifier.state = null;
              return;
            }

            if (currentPlaying != null) {
              ttsService.stop();
            }

            notifier.state = stepKey;

            ttsService
                .playStep(
                  guideId: guideId,
                  stepNumber: stepNumber,
                  langCode: langCode,
                  text: playbackText,
                )
                .whenComplete(() {
                  if (ref.read(ttsPlayingProvider) == stepKey) {
                    notifier.state = null;
                  }
                });
          },
          tooltip: isPlaying ? 'Stoppa' : 'Lyssna',
        ),
      ),
    );
  }
}
