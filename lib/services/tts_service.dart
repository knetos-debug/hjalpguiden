import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hjalpguiden/utils/environment.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _cacheManager = DefaultCacheManager();
  StreamSubscription<PlayerState>? _playerStateSub;

  bool _isPlaying = false;
  String? _currentLang;
  final bool _isTestEnvironment = isFlutterTestEnvironment();

  TtsService() {
    if (!_isTestEnvironment) {
      _initTts();
    }
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

  Future<void> playStep({
    required String guideId,
    required int stepNumber,
    required String langCode,
    required String text,
  }) async {
    if (_isPlaying) {
      await stop();
    }

    if (_isTestEnvironment) {
      await Future.delayed(const Duration(milliseconds: 50));
      _isPlaying = false;
      return;
    }

    final audioAsset = 'assets/audio/$langCode/$guideId-step-$stepNumber.mp3';

    if (await _prepareAsset(audioAsset)) {
      _playPreparedSource();
      return;
    }

    _playFallbackTts(text, langCode);
  }

  Future<void> setLanguage(String langCode) async {
    _currentLang = langCode;
    if (_isTestEnvironment) return;
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

  Future<bool> _prepareAsset(String assetPath) async {
    try {
      if (kIsWeb) {
        final url = Uri.base.resolve(assetPath).toString();
        await _audioPlayer.setUrl(url);
      } else {
        await _audioPlayer.setAsset(assetPath);
      }
      _attachPlayerListener();
      return true;
    } on PlayerException {
      return false;
    } catch (_) {
      return false;
    }
  }

  void _playPreparedSource() {
    _isPlaying = true;
    _audioPlayer.play();
  }

  void _playFallbackTts(String text, String langCode) {
    _isPlaying = true;
    if (_isTestEnvironment) {
      Future.delayed(const Duration(milliseconds: 50)).then((_) {
        _isPlaying = false;
      });
      return;
    }

    setLanguage(langCode).then((_) {
      _flutterTts.speak(text).whenComplete(() {
        _isPlaying = false;
      });
    });
  }

  void _attachPlayerListener() {
    _playerStateSub?.cancel();
    _playerStateSub = _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
      }
    });
  }

  Future<void> stop() async {
    _isPlaying = false;
    _playerStateSub?.cancel();
    _playerStateSub = null;

    if (_isTestEnvironment) {
      await _audioPlayer.stop();
      return;
    }

    await _flutterTts.stop();
    await _audioPlayer.stop();
  }

  Future<void> pause() async {
    if (!_isPlaying) return;
    if (_isTestEnvironment) return;

    await _flutterTts.pause();
    await _audioPlayer.pause();
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _playerStateSub?.cancel();
    if (_isTestEnvironment) {
      _audioPlayer.dispose();
      return;
    }

    _flutterTts.stop();
    _audioPlayer.dispose();
  }
}
