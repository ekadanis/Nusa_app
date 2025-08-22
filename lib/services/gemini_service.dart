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
      );      final prompts = {
        'overview': '''
Buatlah pengantar menarik tentang "${destinationName}" yang terletak di ${location}. 
${subcategory} yang megah ini termasuk dalam kategori warisan ${category}. 
Tulis dalam bahasa Indonesia, maksimal 100 kata. 
Jelaskan keunikan destinasi ini, pentingnya secara budaya, dan mengapa wisatawan harus mengunjunginya. Sertakan pengalaman yang bisa didapat wisatawan seperti tur, pertunjukan budaya, atau aktivitas interaktif.
''',
        'history': '''
Tuliskan sejarah dan perkembangan "${destinationName}" di ${location}. 
Tulis dalam bahasa Indonesia, maksimal 100 kata.
Jelaskan era berdirinya, tokoh penting, periode signifikan, dan peristiwa besar yang membentuk warisan ini. Fokus pada bagaimana wisatawan bisa mempelajari sejarah ini melalui tur, museum, atau pameran interaktif.
''',
        'cultural_significance': '''
Jelaskan fungsi budaya dan pentingnya upacara "${destinationName}" sebagai ${subcategory}. 
Tulis dalam bahasa Indonesia, maksimal 100 kata.
Deskripsikan perannya dalam tradisi lokal, praktik spiritual, upacara komunitas, dan identitas budaya. Jelaskan bagaimana wisatawan bisa mengalami fungsi budaya ini melalui upacara tradisional, workshop, pertunjukan, atau festival budaya.
''',
        'architecture': '''
Deskripsikan asal daerah dan pengaruh arsitektur regional "${destinationName}". 
Tulis dalam bahasa Indonesia, maksimal 100 kata.
Jelaskan dari wilayah/budaya mana asalnya, gaya arsitektur yang mempengaruhi desainnya, dan bagaimana mencerminkan asal daerahnya. Sertakan cara wisatawan bisa menjelajahi arsitektur melalui tur, fotografi, atau workshop.
''',
        'visitor_info': '''
Jelaskan filosofi simbolik dan makna mendalam "${destinationName}" di ${location}. 
Tulis dalam bahasa Indonesia, maksimal 100 kata.
Jelaskan simbol spiritual, konsep filosofis, atau kepercayaan budaya yang terwakili dalam desain dan tujuannya. Detail bagaimana wisatawan bisa memahami aspek filosofis ini melalui sesi meditasi, tur spiritual, atau program edukatif.
''',
        'conservation': '''
Jelaskan material tradisional dan elemen konstruksi utama "${destinationName}". 
Tulis dalam bahasa Indonesia, maksimal 100 kata.
Identifikasi material utama (kayu, batu, tanah liat, logam), teknik konstruksi tradisional, dan kerajinan lokal yang terlibat. Jelaskan bagaimana wisatawan bisa belajar tentang material ini melalui workshop, observasi pengrajin, atau aktivitas konservasi.
''',
        'modern_development': '''
Deskripsikan perkembangan modern dan peningkatan kontemporer di "${destinationName}". 
Tulis dalam bahasa Indonesia, maksimal 100 kata.
Jelaskan renovasi terbaru, penambahan teknologi, peningkatan aksesibilitas, fasilitas baru, dan program edukasi sambil mempertahankan keaslian budaya. Sertakan manfaat perkembangan modern untuk wisatawan seperti aplikasi mobile atau fasilitas yang lebih baik.
''',
        'visitor_guide': '''
Berikan informasi praktis lengkap untuk mengunjungi "${destinationName}" di ${location}.
Tulis dalam bahasa Indonesia, maksimal 100 kata.
Sertakan detail penting: cara ke sana, jam buka, tiket masuk, fasilitas (parkir, toilet, kafe, toko suvenir), aksesibilitas, apa yang dibawa, aturan berpakaian, aturan foto, jadwal tur, waktu terbaik berkunjung, dan tips penting lainnya.
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
      print('Error generating destination content: $e');      // Return default content if generation fails
      return {
        'overview':
            'Informasi detail tentang ${destinationName} sedang dipersiapkan...',
        'history':
            'Sejarah ${destinationName} sedang disusun...',
        'cultural_significance':
            'Makna budaya ${destinationName} sedang didokumentasikan...',
        'architecture':
            'Analisis arsitektur ${destinationName} sedang diproses...',
        'visitor_info':
            'Filosofi simbolik ${destinationName} sedang diteliti...',
        'conservation':
            'Material tradisional ${destinationName} sedang dikatalogkan...',
        'modern_development':
            'Perkembangan kontemporer ${destinationName} sedang ditinjau...',
        'visitor_guide':
            'Informasi praktis pengunjung ${destinationName} sedang disusun...',
      };
    }
  }

}
