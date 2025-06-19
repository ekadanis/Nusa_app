import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/quiz_models.dart';
import '../../../database/constants.dart';

class GeminiService {
  static const String _apiKey = Constants.geminiApiKey;
  static const String _baseUrl =
      '${Constants.baseGeminiUrl}/v1beta/models/${Constants.geminiModelId}:generateContent';
  static Future<List<Question>> generateQuestions({
    required String categoryName,
    required int level,
    required int questionCount,
  }) async {
    print(
        '🤖 Generating new questions with AI for $categoryName (Level $level)...');
    print('🔑 Using API Key: ${_apiKey.substring(0, 10)}...');
    print('🌐 API URL: $_baseUrl');

    try {
      final prompt = _buildPrompt(categoryName, level, questionCount);
      print('📝 Prompt prepared, sending request to Gemini...');
      final response = await http
          .post(
            Uri.parse('$_baseUrl?key=$_apiKey'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'generationConfig': {
                'temperature': 0.8,
                'topK': 40,
                'topP': 0.95,
                'maxOutputTokens': 2048,
              }
            }),
          )
          .timeout(Duration(seconds: 30)); // Add timeout

      print('📡 API Response Status: ${response.statusCode}');
      print('📡 API Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('📦 Response Data: ${data.toString().substring(0, 200)}...');

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final generatedText =
              data['candidates'][0]['content']['parts'][0]['text'];
          print('✅ AI Response received, parsing questions...');
          print(
              '📄 Generated Text Preview: ${generatedText.substring(0, 100)}...');

          final questions =
              _parseQuestionsFromResponse(generatedText, categoryName);
          print('✅ Successfully generated ${questions.length} questions');
          return questions;
        } else {
          print('❌ No candidates in response: $data');
          throw Exception('No candidates in AI response');
        }
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('❌ Error Response: ${response.body}');
        throw Exception(
            'Failed to generate questions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error generating questions: $e');
      print('❌ Error type: ${e.runtimeType}');

      if (e.toString().contains('TimeoutException')) {
        print('⏰ Request timeout - Gemini API took too long to respond');
      } else if (e.toString().contains('SocketException')) {
        print('🌐 Network error - Check internet connection');
      } else if (e.toString().contains('FormatException')) {
        print('📦 JSON parsing error - Invalid response format');
      }

      rethrow;
    }
  }

  static String _buildPrompt(
      String categoryName, int level, int questionCount) {
    String difficulty = _getDifficultyByLevel(level);
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return '''
Generate $questionCount unique and fresh multiple choice questions about Indonesian $categoryName with $difficulty difficulty level.

Context: User level $level, category $categoryName
Timestamp: $timestamp (to ensure questions are always different)

IMPORTANT RULES:
1. Questions in ENGLISH language
2. Each question must have 4 answer choices (A, B, C, D)
3. Questions should be short and clear (maximum 20 words)
4. Answers should be short and factual (maximum 5 words per option)
5. Focus on Indonesian culture, traditions, and heritage
6. CREATE DIFFERENT questions from previously generated ones
7. Difficulty level: $difficulty
8. ALWAYS provide educational explanation for each question
9. Explanation should be informative and help users learn

CATEGORY FOCUS: $categoryName
- If Cultural Sites: focus on temples, museums, historical sites
- If Arts & Culture: focus on dances, music, traditional arts
- If Folk Instruments: focus on traditional musical instruments
- If Traditional Wear: focus on traditional clothing
- If Crafts & Artifacts: focus on handicrafts and cultural objects
- If Local Foods: focus on traditional foods

EXACT JSON Format:
[
  {
    "question": "Short question about $categoryName?",
    "options": ["Answer A", "Answer B", "Answer C", "Answer D"],
    "correctAnswer": 0,
    "explanation": "Brief explanation why the correct answer is right and others are wrong"
  },
  {
    "question": "Second question?",
    "options": ["Option A", "Option B", "Option C", "Option D"],
    "correctAnswer": 1,
    "explanation": "Brief explanation of the correct answer"
  }
]

IMPORTANT: 
- Provide ONLY the JSON array, no additional text
- Include explanation for each question (max 100 words)
- Explanation should be educational and informative
''';
  }

  static String _getDifficultyByLevel(int level) {
    if (level <= 3) return 'Basic';
    if (level <= 6) return 'Intermediate';
    if (level <= 8) return 'Advanced';
    return 'Expert';
  }

  static List<Question> _parseQuestionsFromResponse(
      String response, String categoryName) {
    try {
      print('🔍 Parsing AI response...');

      // Clean response from markdown and whitespace
      String cleanResponse = response.trim();

      // Remove markdown code blocks if any
      cleanResponse =
          cleanResponse.replaceAll('```json', '').replaceAll('```', '');

      // Find JSON array
      int jsonStart = cleanResponse.indexOf('[');
      int jsonEnd = cleanResponse.lastIndexOf(']') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        print('❌ No valid JSON found in response');
        throw Exception('Invalid JSON format - no array found');
      }

      final jsonString = cleanResponse.substring(jsonStart, jsonEnd);
      print(
          '📝 Extracted JSON: ${jsonString.substring(0, jsonString.length > 200 ? 200 : jsonString.length)}...');

      final List<dynamic> questionsJson = jsonDecode(jsonString);
      print(
          '✅ Successfully parsed ${questionsJson.length} questions from JSON');

      return questionsJson.asMap().entries.map((entry) {
        final index = entry.key;
        final questionData = entry.value;
        // Validate question data
        if (questionData['question'] == null ||
            questionData['options'] == null ||
            questionData['correctAnswer'] == null) {
          throw Exception('Invalid question format at index $index');
        }

        final options = List<String>.from(questionData['options']);
        if (options.length != 4) {
          throw Exception(
              'Question must have exactly 4 options at index $index');
        }

        final correctAnswer = questionData['correctAnswer'] as int;
        if (correctAnswer < 0 || correctAnswer >= 4) {
          throw Exception('Invalid correct answer index at index $index');
        } // Get explanation if available
        final explanation = questionData['explanation']?.toString().trim();
        print(
            '📝 Question ${index + 1} explanation: ${explanation ?? "NO EXPLANATION"}');

        return Question(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}_$index',
          question: questionData['question'].toString().trim(),
          options: options,
          correctAnswerIndex: correctAnswer,
          categoryId: categoryName
              .toLowerCase()
              .replaceAll(' ', '-')
              .replaceAll('&', ''),
          explanation: explanation, // Add explanation to Question
        );
      }).toList();
    } catch (e) {
      print('❌ Error parsing questions: $e');
      print('📄 Raw response: $response');
      throw Exception('Failed to parse AI generated questions: $e');
    }
  }
}
