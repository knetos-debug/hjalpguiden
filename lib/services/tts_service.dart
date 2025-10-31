import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class TtsService {
  TtsService() {
    _configureAudioSession();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
      }
    });
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isUnlocked = false;

  Future<void> playStep({
    required String guideId,
    required int stepNumber,
    required String langCode,
  }) async {
    final assetSourcePath = 'assets/audio/$langCode/$guideId-step-$stepNumber.mp3';

    if (_isPlaying) {
      await stop();
    }

    await _unlockAudioIfNeeded();

    _isPlaying = true;

    try {
      await _audioPlayer.setVolume(1.0);

      if (kIsWeb) {
        // För web/PWA: resolva fullständig URL från base URI
        final uri = Uri.base.resolve(assetSourcePath);
        await _audioPlayer.setAudioSource(AudioSource.uri(uri));
      } else {
        // För mobil: använd asset-baserad laddning
        await _audioPlayer.setAudioSource(AudioSource.asset(assetSourcePath));
      }

      await _audioPlayer.play();
    } on PlayerException {
      _isPlaying = false;
      rethrow;
    } catch (_) {
      _isPlaying = false;
      rethrow;
    }
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _audioPlayer.stop();
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _audioPlayer.dispose();
  }

  Future<void> _configureAudioSession() async {
    if (kIsWeb) {
      return;
    }

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await session.setActive(true);
      }
    } catch (_) {}
  }

  Future<void> _unlockAudioIfNeeded() async {
    if (_isUnlocked || kIsWeb) {
      _isUnlocked = true;
      return;
    }

    const silentDataUri =
        'data:audio/wav;base64,UklGRiQAAABXQVZFZm10IBIAAAABAAEAQB8AAEAfAAABAAgAZGF0YQAAAAA=';

    try {
      await _audioPlayer.setVolume(0.0);
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(silentDataUri)),
      );
      await _audioPlayer.play();
      await _audioPlayer.stop();
    } catch (_) {
      await _audioPlayer.stop();
    } finally {
      await _audioPlayer.setVolume(1.0);
      _isUnlocked = true;
    }
  }
}
