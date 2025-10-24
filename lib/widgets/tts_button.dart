import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class TtsButton extends ConsumerWidget {
  final String text;
  final int stepNumber;

  const TtsButton({
    super.key,
    required this.text,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsService = ref.watch(ttsServiceProvider);
    final currentPlaying = ref.watch(ttsPlayingProvider);
    final selectedLang = ref.watch(selectedLanguageProvider);
    final isPlaying = currentPlaying == 'step_$stepNumber';

    if (text.isEmpty || selectedLang == null) {
      return const SizedBox.shrink();
    }

    return Semantics(
      button: true,
      label: isPlaying ? 'Sluta lyssna på steg $stepNumber' : 'Lyssna på steg $stepNumber',
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
          onPressed: () async {
            if (isPlaying) {
              await ttsService.stop();
              ref.read(ttsPlayingProvider.notifier).state = null;
            } else {
              // Stop any currently playing
              if (currentPlaying != null) {
                await ttsService.stop();
              }
              
              ref.read(ttsPlayingProvider.notifier).state = 'step_$stepNumber';
              
              try {
                await ttsService.speak(text, selectedLang);
                // Add pause after speaking
                await Future.delayed(const Duration(milliseconds: 600));
              } finally {
                if (ref.read(ttsPlayingProvider) == 'step_$stepNumber') {
                  ref.read(ttsPlayingProvider.notifier).state = null;
                }
              }
            }
          },
          tooltip: isPlaying ? 'Stoppa' : 'Lyssna',
        ),
      ),
    );
  }
}