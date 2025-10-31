import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hjalpguiden/models/guide.dart' as models;
import 'package:hjalpguiden/widgets/tts_button.dart';

class StepCard extends ConsumerWidget {
  final String guideId;
  final int stepNumber;
  final models.Step step;

  const StepCard({
    super.key,
    required this.guideId,
    required this.stepNumber,
    required this.step,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      container: true,
      label: 'Steg $stepNumber: ${step.svEnkel}',
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.svEnkel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    if (step.hs.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        step.hs,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TtsButton(
                guideId: guideId,
                translationText: step.hs,
                swedishText: step.svEnkel,
                stepNumber: stepNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
