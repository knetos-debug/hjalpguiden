import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/guide.dart';
import '../services/content_loader.dart';
import '../services/tts_service.dart';

// Language provider
final selectedLanguageProvider = StateProvider<String?>((ref) => null);

// Content loader instance
final contentLoaderProvider = Provider((ref) => ContentLoader());

// TTS service instance
final ttsServiceProvider = Provider((ref) => TtsService());

// Content bundle for selected language
final contentBundleProvider = FutureProvider<ContentBundle>((ref) async {
  final lang = ref.watch(selectedLanguageProvider);
  if (lang == null) {
    throw Exception('No language selected');
  }
  
  final loader = ref.watch(contentLoaderProvider);
  return await loader.loadForLanguage(lang);
});

// Individual guide provider
final guideProvider = Provider.family<Guide?, String>((ref, guideId) {
  final contentAsync = ref.watch(contentBundleProvider);
  
  return contentAsync.when(
    data: (bundle) => bundle.guides.firstWhere(
      (g) => g.id == guideId,
      orElse: () => throw Exception('Guide not found'),
    ),
    loading: () => null,
    error: (_, __) => null,
  );
});

// TTS playing state
final ttsPlayingProvider = StateProvider<String?>((ref) => null);