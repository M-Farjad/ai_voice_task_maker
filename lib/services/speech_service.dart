import '../headers.dart';

class SpeechService {
  static final SpeechToText _speech = SpeechToText();

  static Future<String?> listen() async {
    try {
      bool available = await _speech.initialize();
      if (!available) return null;

      await _speech.listen(
        listenMode: ListenMode.confirmation,
        onResult: (result) {
          if (result.finalResult) {
            _speech.stop();
          }
        },
      );

      await Future.delayed(const Duration(seconds: 5));
      _speech.stop();
      return _speech.lastRecognizedWords;
    } catch (e) {
      print('Error initializing speech recognition: $e');
      return null;
    }
  }

  static Future<void> stop() async {
    try {
      await _speech.stop();
    } catch (e) {
      print('Error stopping speech recognition: $e');
    } finally {
      await _speech.cancel();
    }
  }
}
