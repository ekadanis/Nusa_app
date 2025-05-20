import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import '../data/chat_message.dart';

class ChatbotService {
  final List<ChatMessage> _message = [];
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  List<ChatMessage> get messages => _message;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  Future<void> sendMessage(String inputText) async {
    _message.add(ChatMessage(text: inputText, isUser: true));
    _setLoading(true);

    try {
      final reply = await _sendToGemini(inputText);
      _message.add(ChatMessage(text: reply, isUser: false));
      _clearError();
    } catch (e) {
      _setError("Failed to process message: $e");
      _message.add(ChatMessage(text: "Error occurred", isUser: false));
    } finally{
      _setLoading(false);
    }
  }

//=================================//

  Future<String> _sendToGemini(String inputText) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("apiKey is not found in .env file");
    }

    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key= $apiKey';

    final conditionedPrompt = '''
    Your name is NusaBot. Your task is to answer questions related to Indonesian culture or history.
    If the question is appropriate, answer in a casual and easy-to-understand style, don't use slank. Answers with english language.
    If it doesn't fit, apologize and say you can only help about Indonesian culture or history.
    Here is the question:
    $inputText
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

    if (response.statusCode == 503) {
      throw Exception("Nusabot is busy");
    }

    if (response.statusCode != 200) {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }

    final json = jsonDecode(response.body);
    return json['candidate']?[0]['content']?['parts']?[0]['text'] ??
        '(NO Response)';
  }

  Future<void> sendVoiceMessage() async {
    _setLoading(true);

    try{
      bool available = await _speechToText.initialize();
      if(!available) throw Exception("SpeechToText is not available");
      
      String finalResult = '';

      await _speechToText.listen(
        // ignore: deprecated_member_use
        listenMode: stt.ListenMode.confirmation,
        onResult: (result) {
          if(result.finalResult){
            finalResult = result.recognizedWords;
          }
        });

        while(_speechToText.isListening){
          await Future.delayed(const Duration(milliseconds: 100));
        }

        if (finalResult.isEmpty) throw Exception("No sound detected");

        _message.add(ChatMessage(text: finalResult, isUser: true));
        final reply = await _sendToGemini(finalResult);
        _message.add(ChatMessage(text: reply, isUser: false));

        await _speak(reply);
        _clearError();
    }catch(e){
      _setError("An error occurred while recording sound: $e");
      _message.add(ChatMessage(text: "Error occurred", isUser: false));

    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
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
