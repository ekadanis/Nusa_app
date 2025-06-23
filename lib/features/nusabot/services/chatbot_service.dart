import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import '../data/chat_message.dart';

class ChatbotService {
  //set singleton
  // static final ChatbotService _instance = ChatbotService._internal();

  // factory ChatbotService() {
  //   return _instance;
  // }

  // ChatbotService._internal();

  final List<ChatMessage> _message = [];
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _isRecording = false;

  bool get isRecording => _isRecording;
  List<ChatMessage> get messages => _message;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  Future<void> sendMessage(String inputText) async {
    await stopTts(); //stop tts ketika ada req. baru

    _message.add(
        ChatMessage(text: inputText, isUser: true, timestamp: DateTime.now()));
    _setLoading(true);

    try {
      final reply = await _sendToGemini(inputText);
      _message.add(
          ChatMessage(text: reply, isUser: false, timestamp: DateTime.now()));
      _clearError();
    } catch (e) {
      _setError("Failed to process message: $e");
      _message.add(ChatMessage(
          text: "Error occurred", isUser: false, timestamp: DateTime.now()));
    } finally {
      _setLoading(false);
    }
  }

  Future<String> _sendToGemini(String inputText) async {
    final apiKey = "AIzaSyDmCT0apoGo8DirEKrkGMzY3G-QGuqi9P0";
    print('🔑 API Key: $apiKey');
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("apiKey is not found in .env file");
    }

    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    print('🌐 Sending request to Gemini...');
    print('➡️ Prompt: $inputText');
    print('➡️ URL: $url');

    final conditionedPrompt = '''
    Your name is NusaBot. Your task is to answer questions related to Indonesian culture or history.
    If the question is appropriate, answer in a casual and easy-to-understand style, don't use slank. Answers with english language.
    If it doesn't fit, apologize and say you can only help about Indonesian culture or history.
    Here is the question:
    $inputText, please explain slowly
  ''';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": conditionedPrompt,
              }
            ]
          }
        ]
      }),
    );

    print('🟡 Status Code: ${response.statusCode}');
    print('🟡 Response Body: ${response.body}');

    if (response.statusCode == 503) {
      throw Exception("Nusabot is busy");
    }

    if (response.statusCode != 200) {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }

    final json = jsonDecode(response.body);
    return json['candidates']?[0]['content']?['parts']?[0]['text'] ??
        '(NO Response)';
  }

  Future<void> sendVoiceMessage() async {
    await stopTts();

    _isRecording = true;
    _setLoading(true);

    try {
      bool available = await _speechToText.initialize();
      if (!available) throw Exception("SpeechToText is not available");

      String finalResult = '';

      await _speechToText.listen(
        // ignore: deprecated_member_use
        listenMode: stt.ListenMode.confirmation,
        onResult: (result) {
          if (result.finalResult) {
            finalResult = result.recognizedWords;
          }
        },
      );

      // Tunggu sampai user selesai bicara
      while (_speechToText.isListening) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Stop efek recording setelah rekaman selesai
      await stopVoiceRecording();

      // Jika tidak ada suara dikenali, jangan lanjut
      if (finalResult.isEmpty) return;

      // Tambahkan ke chat
      _message.add(ChatMessage(
          text: finalResult, isUser: true, timestamp: DateTime.now()));

      // Kirim ke Gemini
      final reply = await _sendToGemini(finalResult);

      _message.add(
          ChatMessage(text: reply, isUser: false, timestamp: DateTime.now()));
      await _speak(reply);
      _clearError();
    } catch (e) {
      _setError("An error occurred while recording: $e");
      _message.add(ChatMessage(
          text: "Error occurred", isUser: false, timestamp: DateTime.now()));
      await stopVoiceRecording(); // pastikan berhenti juga saat error
    }
  }

  Future<void> _speak(String text) async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.speak(text);
      print("[TTS] Speaking: $text"); // Log untuk cek
    } catch (e) {
      print("[TTS ERROR] $e");
    }
  }

  Future<void> stopVoiceRecording() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
    _isRecording = false;
    _setLoading(false); // supaya isRecording jadi false
  }

  Future<void> stopTts() async {
    await _flutterTts.stop();
  }

// STATE HELPER //

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = null;
  }

  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
  }
}
