import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nusa_app/database/constants.dart';
import 'package:mime/mime.dart';
import 'dart:io';
import 'dart:typed_data';

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
        'overview': '''
Create an engaging introduction to "${destinationName}" situated in ${location}. 
This magnificent ${subcategory} belongs to the ${category} heritage category. 
Write in English, 100-150 words. 
Highlight what makes this destination unique, its cultural importance, and why visitors should explore it. Include what tourists can expect to experience when visiting - such as guided tours, cultural performances, interactive exhibits, or hands-on activities.
''',
        'history': '''
Write about the historical development and timeline of "${destinationName}" in ${location}. 
Write in English, 150-200 words.
Cover its founding era, key historical figures, significant periods, and major events that shaped its legacy. Focus on HOW tourists can learn about and experience this history during their visit: guided historical tours, museum displays, storytelling sessions, historical reenactments, documentary screenings, or interactive timeline exhibits that visitors can engage with.
''',
        'cultural_significance': '''
Explain the cultural functions and ceremonial importance of "${destinationName}" as a ${subcategory}. 
Write in English, 120-180 words.
Describe its role in local traditions, spiritual practices, community ceremonies, and cultural identity. Most importantly, detail HOW tourists can experience these cultural functions: attending traditional ceremonies, participating in cultural workshops, watching traditional performances, joining prayer sessions, learning traditional crafts, or experiencing cultural festivals and celebrations that tourists are welcome to observe or join.
''',
        'architecture': '''
Describe the place of origin and regional architectural influences of "${destinationName}". 
Write in English, 120-180 words.
Explain which region/culture it originates from, what architectural styles influenced its design, and how it represents its place of origin. Include HOW tourists can explore and appreciate the architecture: guided architectural tours, climbing specific structures, touching certain elements, photography opportunities, architectural workshops, or learning about building techniques through hands-on demonstrations.
''',
        'visitor_info': '''
Explore the symbolic philosophy and deeper meanings embedded in "${destinationName}" located in ${location}. 
Write in English, 150-200 words.
Explain the spiritual symbols, philosophical concepts, sacred geometry, or cultural beliefs represented in its design and purpose. Detail HOW tourists can understand and experience these philosophical aspects: meditation sessions, spiritual guidance tours, symbol interpretation workshops, philosophical discussions with local guides, traditional blessing ceremonies, or educational programs that help visitors connect with the deeper meanings.
''',
        'conservation': '''
Detail the main traditional materials and construction elements used in building "${destinationName}". 
Write in English, 120-180 words.
Identify the primary materials (wood, stone, clay, metals, etc.), traditional construction techniques, and local craftsmanship involved. Explain HOW tourists can learn about and experience these materials: visiting material sources, watching craftsmen work, participating in traditional building workshops, touching and examining materials, purchasing handcrafted items made from the same materials, or joining conservation activities.
''',
        'modern_development': '''
Describe the modern developments and contemporary enhancements at "${destinationName}". 
Write in English, 120-180 words.
Cover recent renovations, technological additions, accessibility improvements, new facilities, and educational programs while maintaining cultural authenticity. Explain HOW tourists can benefit from these modern developments: using mobile apps for self-guided tours, accessing digital exhibits, enjoying improved facilities, participating in modern educational programs, or using contemporary amenities that enhance their cultural experience without diminishing the traditional atmosphere.
''',
        'visitor_guide': '''
Provide comprehensive practical visitor information for "${destinationName}" located in ${location}.
Write in English, 150-200 words.
Include essential details: how to get there (transportation options, nearest airport/station), opening hours, entrance fees, available facilities (parking, restrooms, cafeteria, souvenir shops), accessibility features, what to bring, dress code requirements, photography rules, guided tour options and schedules, best times to visit, weather considerations, nearby accommodations, and important visitor tips. Also mention any special requirements, seasonal closures, or booking procedures that tourists should know about.
'''
      };

      Map<String, String> results = {};

      for (String key in prompts.keys) {
        final response =
            await model.generateContent([Content.text(prompts[key]!)]);

        if (response.text != null) {
          results[key] = response.text!.trim();
          print('Generated $key: ${response.text!.substring(0, 50)}...');
        } else {
          results[key] = 'Content cannot be generated for this section.';
        }

        // Add small delay to avoid rate limiting
        await Future.delayed(Duration(milliseconds: 500));
      }

      return results;
    } catch (e) {
      print('Error generating destination content: $e');
      // Return default content if generation fails
      return {
        'overview':
            'Detailed information about ${destinationName} is currently being prepared...',
        'history':
            'Historical timeline of ${destinationName} is being compiled...',
        'cultural_significance':
            'Cultural importance of ${destinationName} is being documented...',
        'architecture':
            'Architectural analysis of ${destinationName} is being processed...',
        'visitor_info':
            'Symbolic philosophy of ${destinationName} is being researched...',
        'conservation':
            'Traditional materials of ${destinationName} are being catalogued...',
        'modern_development':
            'Contemporary developments at ${destinationName} are being reviewed...',
        'visitor_guide':
            'Practical visitor information for ${destinationName} is being compiled...',
      };
    }
  }

  Future<String> uploadFileToGemini(
      String filePath, String prompt, Schema schema) async {
    File file = File(filePath);
    final String mimeType =
        lookupMimeType(filePath) ?? 'application/octet-stream';
    final Uint8List bytes = await file.readAsBytes();

    try {
      GenerateContentResponse response;

      final generateCv = GenerativeModel(
        model: Constants.geminiModelId,
        apiKey: Constants.geminiApiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: schema,
        ),
      );
      final content = [
        Content('user', [
          TextPart(prompt),
          DataPart(mimeType, bytes),
        ])
      ];

      response = await generateCv.generateContent(content);

      if (response.text != null) {
        print('Generated Response: ${response.text}');
        return response.text!;
      } else {
        throw Exception('No valid response from Gemini');
      }
    } catch (e) {
      print('Error: $e');
      return 'Error: ${e.toString()}';
    }
  }
}
