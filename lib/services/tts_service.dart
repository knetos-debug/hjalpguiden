import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _cacheManager = DefaultCacheManager();
  
  bool _isPlaying = false;
  String? _currentLang;
  
  // Cloud TTS endpoint (replace with your actual endpoint)
  static const String _cloudTtsEndpoint = 'YOUR_CLOUD_TTS_ENDPOINT';

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.4); // Slower rate for clarity
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
    });
    
    _flutterTts.setErrorHandler((msg) {
      _isPlaying = false;
    });
  }

  Future<void> setLanguage(String langCode) async {
    _currentLang = langCode;
    await _flutterTts.setLanguage(_mapLangCode(langCode));
  }

  String _mapLangCode(String code) {
    final map = {
      'ar': 'ar-SA',
      'so': 'so-SO',
      'ti': 'ti-ER',
      'fa': 'fa-IR',
      'prs': 'fa-IR', // Dari uses Persian voice
      'uk': 'uk-UA',
      'ru': 'ru-RU',
      'tr': 'tr-TR',
      'en': 'en-US',
      'sv': 'sv-SE',
    };
    return map[code] ?? 'sv-SE';
  }

  Future<void> speak(String text, String langCode) async {
    if (_isPlaying) {
      await stop();
    }

    _isPlaying = true;
    await setLanguage(langCode);

    // Try local TTS first
    final hasVoice = await _hasLocalVoice(langCode);
    
    if (hasVoice) {
      await _flutterTts.speak(text);
    } else {
      // Fallback to cloud TTS with caching
      await _speakWithCloud(text, langCode);
    }
  }

  Future<bool> _hasLocalVoice(String langCode) async {
    try {
      final voices = await _flutterTts.getVoices;
      if (voices == null) return false;
      
      final mappedCode = _mapLangCode(langCode);
      final hasVoice = voices.any((v) => 
        v['locale']?.toString().startsWith(mappedCode.split('-')[0]) ?? false
      );
      
      return hasVoice;
    } catch (e) {
      return false;
    }
  }

  Future<void> _speakWithCloud(String text, String langCode) async {
    try {
      final cacheKey = '${langCode}_${text.hashCode}';
      final cached = await _cacheManager.getFileFromCache(cacheKey);
      
      if (cached != null) {
        await _audioPlayer.setFilePath(cached.file.path);
        await _audioPlayer.play();
        _audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
          }
        });
      } else {
        // Note: In production, replace with actual cloud TTS call
        // For MVP, we'll use local TTS even if quality is lower
        await _flutterTts.speak(text);
      }
    } catch (e) {
      // Fallback to local TTS
      await _flutterTts.speak(text);
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