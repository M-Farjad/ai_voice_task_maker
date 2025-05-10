import 'dart:developer';

import '../headers.dart';
import '../utils/permisson_manager.dart';

class SpeechService {
  static final SpeechToText _speech = SpeechToText();

  static Future<void> listen() async {
    try {
      final isGranted = await requestMicPermission();
      if (!isGranted) {
        Get.snackbar("Permission Denied",
            "Please allow microphone access from App Settings");
      }
      bool available = await _speech.initialize();
      if (!available) {
        log("Speech recognition not available");
        return;
      }

      await _speech.listen(
        // listenMode: ListenMode.confirmation,
        pauseFor: const Duration(seconds: 3),
        listenFor: const Duration(seconds: 30),
        localeId: 'en_US',
        onResult: (result) {
          if (result.finalResult) {
            _speech.stop();
          }
        },
      );

      // await Future.delayed(const Duration(seconds: 20));
      // _speech.stop();
      // _speech.cancel();
      // return _speech.lastRecognizedWords;
    } catch (e) {
      print('Error initializing speech recognition: $e');
      return;
    }
    return;
  }

  static Future<String?> stop() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (_speech.isListening) {
        await _speech.stop();
      }
      await _speech.cancel();
      return _speech.lastRecognizedWords;
    } catch (e) {
      print('Error stopping speech recognition: $e');
    } finally {
      await _speech.cancel();
    }
    return null;
  }
}
