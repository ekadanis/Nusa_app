import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nusa_app/database/constants.dart';

class GeminiService {
  // Method untuk generate destination content
  Future<Map<String, String>> generateDestinationContent(String destinationName,
      String category, String subcategory, String location) async {
    try {
      final model = GenerativeModel(
        model: Constants.geminiModelId,
        apiKey: Constants.geminiApiKey,
      );
      final prompts = {
        'overview':
            'Write an engaging introduction about "${destinationName}" located in ${location}. This magnificent ${subcategory} belongs to the ${category} heritage category. Write in English, maximum 100 words. Describe the uniqueness of this destination, its cultural importance, and why tourists should visit. Include experiences visitors can have such as tours, cultural performances, or interactive activities.',
        'history':
            'Write the history and development of "${destinationName}" in ${location}. Write in English, maximum 100 words. Describe its founding era, key figures, significant periods, and major events that shaped this heritage. Focus on how visitors can learn about this history through tours, museums, or interactive exhibits.',
        'cultural_significance':
            'Explain the cultural function and ceremonial importance of "${destinationName}" as a ${subcategory}. Write in English, maximum 100 words. Describe its role in local traditions, spiritual practices, community ceremonies, and cultural identity. Explain how visitors can experience this cultural function through traditional ceremonies, workshops, performances, or cultural festivals.',
        'architecture':
            'Describe the regional origin and architectural influences of "${destinationName}". Write in English, maximum 100 words. Explain which region/culture it comes from, the architectural styles that influence its design, and how it reflects its origin. Include how visitors can explore the architecture through tours, photography, or workshops.',
        'visitor_info':
            'Explain the symbolic philosophy and deep meaning of "${destinationName}" in ${location}. Write in English, maximum 100 words. Describe spiritual symbols, philosophical concepts, or cultural beliefs represented in its design and purpose. Detail how visitors can understand these philosophical aspects through meditation sessions, spiritual tours, or educational programs.',
        'conservation':
            'Describe the traditional materials and main construction elements of "${destinationName}". Write in English, maximum 100 words. Identify the main materials (wood, stone, clay, metal), traditional construction techniques, and local craftsmanship involved. Explain how visitors can learn about these materials through workshops, observing artisans, or conservation activities.',
        'modern_development':
            'Describe modern developments and contemporary enhancements at "${destinationName}". Write in English, maximum 100 words. Explain recent renovations, technology additions, improved accessibility, new facilities, and educational programs while maintaining cultural authenticity. Include the benefits of modern developments for visitors such as mobile apps or better facilities.',
        'visitor_guide':
            'Provide complete practical information for visiting "${destinationName}" in ${location}. Write in English, maximum 100 words. Include essential details: how to get there, opening hours, entrance fees, facilities (parking, toilets, cafes, souvenir shops), accessibility, what to bring, dress code, photo rules, tour schedules, best visiting times, and other important tips.'
      };

      Map<String, String> results = {};

      for (String key in prompts.keys) {
        final response =
            await model.generateContent([Content.text(prompts[key]!)]);

        String? text = response.text;
        if (text != null) {
          // Remove leading/trailing whitespace and any leading/trailing asterisks or bullet points
          text = text
              .trim()
              .replaceAll(RegExp(r'^[*•\s]+', multiLine: true), '')
              .replaceAll(RegExp(r'^[*•\s]+', multiLine: false), '');
          // Remove all asterisks and bullet points in the text
          text = text.replaceAll('*', '').replaceAll('•', '');
          results[key] = text;
          print('Generated $key: \\${text.substring(0, 50)}...');
        } else {
          results[key] = 'Content cannot be generated for this section.';
        }

        // Add small delay to avoid rate limiting
        await Future.delayed(Duration(milliseconds: 500));
      }

      return results;
    } catch (e) {
      print(
          'Error generating destination content: $e'); // Return default content if generation fails
      return {
        'overview':
            'Detailed information about ${destinationName} is being prepared...',
        'history': 'The history of ${destinationName} is being compiled...',
        'cultural_significance':
            'The cultural significance of ${destinationName} is being documented...',
        'architecture':
            'The architectural analysis of ${destinationName} is being processed...',
        'visitor_info':
            'The symbolic philosophy of ${destinationName} is being researched...',
        'conservation':
            'Traditional materials of ${destinationName} are being catalogued...',
        'modern_development':
            'Contemporary developments of ${destinationName} are being reviewed...',
        'visitor_guide':
            'Practical visitor information for ${destinationName} is being compiled...',
      };
    }
  }
}
