import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  Future<void> speak(String text, String langCode, String guideId, int stepNumber) async {
    if (_isPlaying) {
      await stop();
    }

    _isPlaying = true;
    await setLanguage(langCode);

    // Check if TTS is available for this language
    if (!hasLocalVoice(langCode)) {
      _isPlaying = false;
      return; // No TTS available (Tigrinya)
    }

    try {
      await _speakFromAsset(langCode, guideId, stepNumber);
    } catch (e) {
      print('TTS error: $e');
      _isPlaying = false;
    }
  }

  bool hasLocalVoice(String langCode) {
    // Return false only for Tigrinya, true for all others
    return langCode != 'ti';
  }

  Future<void> _speakFromAsset(String langCode, String guideId, int stepNumber) async {
    try {
      // Build path to audio file: assets/audio/{lang}/{guideId}-step-{number}.mp3
      final assetPath = 'assets/audio/$langCode/$guideId-step-$stepNumber.mp3';

      print('Loading audio from: $assetPath');

      // Check if asset exists and load it
      try {
        final byteData = await rootBundle.load(assetPath);

        // Copy to temp file so AudioPlayer can play it
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$guideId-step-$stepNumber.mp3');
        await tempFile.writeAsBytes(byteData.buffer.asUint8List());

        // Play the audio
        await _audioPlayer.setFilePath(tempFile.path);
        await _audioPlayer.play();

        print('Playing audio from asset');
      } catch (assetError) {
        print('Asset not found: $assetPath - $assetError');
        _isPlaying = false;
      }
    } catch (e) {
      print('Error loading audio: $e');
      _isPlaying = false;
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
