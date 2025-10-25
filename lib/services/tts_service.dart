import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _cacheManager = DefaultCacheManager();

  bool _isPlaying = false;
  String? _currentLang;

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
    });

    _flutterTts.setErrorHandler((msg) {
      _isPlaying = false;
    });

    // Setup audio player completion handler
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
      }
    });
  }

  Future<void> setLanguage(String langCode) async {
    _currentLang = langCode;
  }

  // Map language codes to Edge TTS voice names
  String _mapToEdgeVoice(String code) {
    final voiceMap = {
      'ar': 'ar-SA-ZariyahNeural',      // Arabic (Saudi) - Female
      'so': 'so-SO-UbaxNeural',          // Somali - Female
      'ti': '',                           // Tigrinya - No TTS available
      'fa': 'fa-IR-DilaraNeural',        // Persian - Female
      'prs': 'fa-IR-DilaraNeural',       // Dari (uses Persian voice) - Female
      'uk': 'uk-UA-PolinaNeural',        // Ukrainian - Female
      'ru': 'ru-RU-SvetlanaNeural',      // Russian - Female
      'tr': 'tr-TR-EmelNeural',          // Turkish - Female
      'en': 'en-US-JennyNeural',         // English - Female
      'sv': 'sv-SE-SofieNeural',         // Swedish - Female
    };
    return voiceMap[code] ?? '';
  }

  Future<void> speak(String text, String langCode) async {
    if (_isPlaying) {
      await stop();
    }

    _isPlaying = true;
    await setLanguage(langCode);

    // Check if Edge TTS is available for this language
    if (!hasLocalVoice(langCode)) {
      _isPlaying = false;
      return; // No TTS available (Tigrinya)
    }

    try {
      await _speakWithEdgeTTS(text, langCode);
    } catch (e) {
      print('Edge TTS error: $e');
      _isPlaying = false;
    }
  }

  bool hasLocalVoice(String langCode) {
    // Return false only for Tigrinya, true for all others
    return langCode != 'ti';
  }

  Future<void> _speakWithEdgeTTS(String text, String langCode) async {
    try {
      final voice = _mapToEdgeVoice(langCode);
      if (voice.isEmpty) {
        _isPlaying = false;
        return;
      }

      // Create cache key
      final cacheKey = 'edge_tts_${langCode}_${text.hashCode}';

      // Check if audio is already cached
      final cached = await _cacheManager.getFileFromCache(cacheKey);

      if (cached != null) {
        // Play from cache
        print('Playing from cache: $cacheKey');
        await _audioPlayer.setFilePath(cached.file.path);
        await _audioPlayer.play();
      } else {
        // Generate new audio from Edge TTS
        print('Generating new TTS: $cacheKey');
        final audioData = await _generateEdgeTTS(text, voice);

        if (audioData != null) {
          // Save to cache
          final file = await _cacheManager.putFile(
            cacheKey,
            audioData,
            fileExtension: 'mp3',
          );

          // Play the audio
          await _audioPlayer.setFilePath(file.path);
          await _audioPlayer.play();
        } else {
          _isPlaying = false;
        }
      }
    } catch (e) {
      print('TTS error: $e');
      _isPlaying = false;
    }
  }

  Future<Uint8List?> _generateEdgeTTS(String text, String voice) async {
    try {
      // Use public Edge TTS proxy (OpenAI-compatible format)
      final url = Uri.parse('https://tts.aishare.us.kg/v1/audio/speech');

      final body = jsonEncode({
        'model': 'tts-1',
        'input': text,
        'voice': voice,
        'speed': 0.8, // Slower for clarity (0.25 to 4.0)
        'response_format': 'mp3',
      });

      print('Calling Edge TTS proxy with voice: $voice');

      // Make request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer aisharenet',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('TTS generated successfully');
        return response.bodyBytes;
      } else {
        print('Edge TTS error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Generate TTS error: $e');
      return null;
    }
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _flutterTts.stop();
    await _audioPlayer.stop();
  }

  Future<void> pause() async {
    if (_isPlaying) {
      await _flutterTts.pause();
      await _audioPlayer.pause();
    }
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
  }
}
