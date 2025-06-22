import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/routes/router.dart';
import 'package:http/http.dart' as http;

Future<String> analyzeImage(BuildContext context, File pickedImage) async {
  final bytes = await pickedImage.readAsBytes();
  final base64Image = base64Encode(bytes);

  if (base64Image != null) {
    print("\n\nIMAGE ADAAA\n\n");
  }
  final isValid = await verifyObject(base64Image);
  print("\n\n<<<<OBJEKNYA : ${isValid}\n\n");

  if (isValid) {
    final response = await sendImageToGeminiAPI(base64Image);
    return response;
  } else {
    throw Exception(
        'Objek budaya pada gambar tidak valid atau tidak dikenali sebagai budaya tradisional Indonesia.');
  }
}

Future<bool> verifyObject(String base64Image) async {
  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyBAc6PoDqzUUHCF-56-_C__ofRXrfjzh78",
  );

  final _prompt = '''
analisa objek budaya di gambar tersebut untuk melakukan validasi apakah objek budaya pada gambar tersebut ada dalam objek budaya tradisional di indonesia atau bukan. Contoh objek budaya yang dimaksud seperti tari reog, batik, wayang, dsb. Kembalikan HANYA objek JSON dengan format seperti berikut:  
  
  {"is_valid_object": bool}
  ''';

  final _body = jsonEncode({
    "contents": [
      {
        "parts": [
          {"text": _prompt},
          {
            "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
          }
        ]
      }
    ]
  });

  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: _body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final text =
        data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
    final jsonResult = jsonDecode(text);
    print("\n\n<< ISI VALIDASI: ${jsonResult}\n\n");
    final isValid = jsonResult['is_valid_object'] == true ||
        jsonResult['is_valid_object'] == 'true';
    return isValid;
  } else {
    throw Exception('Failed to analyze image: ${response.reasonPhrase}');
  }
}

Future<String> sendImageToGeminiAPI(String base64Image) async {
  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyBAc6PoDqzUUHCF-56-_C__ofRXrfjzh78",
  );

  final promptText = '''
Analyze the cultural object in the image and respond with a JSON object only (no markdown or explanations), using the structure below. Each field should contain content between **100–150 words**, but each paragraph can only content between **40-50 words** written in English.

Return **ONLY** a raw JSON like this (no markdown, no preface, no explanation, no schema keywords like "type", "properties", or "required"):

{
  "nama_budaya": "string",
  "asal_kota" : "string",
  "asal_provinsi" : "string",
  "kategori_objek" : "string",
  "deskripsi_singkat": "string (100–150 words)",
  "sejarah": "string (100–150 words)",
  "fungsi_budaya": "string (100–150 words)",
  "asal_daerah": "string (100–150 words)",
  "filosofi_simbolik": "string (100–150 words)",
  "material_utama": "string (100–150 words)",
  "perkembangan_kini": "string (100–150 words)",
  "panduan_pengunjung": "string (100–150 words)"
}

Explanation of each field:
- **nama_budaya**: The name of the cultural object
- **asal_kota**: The city or town of origin
- **asal_provinsi**: The province or state of origin
- **kategori_objek**: The category or type of cultural object
- **deskripsi_singkat**: General description and overview
- **sejarah**: Historical background and development
- **fungsi_budaya**: Cultural and ceremonial functions
- **asal_daerah**: Region or place of origin and architectural influence
- **filosofi_simbolik**: Symbolic meaning and spiritual philosophy
- **material_utama**: Main traditional materials used
- **perkembangan_kini**: Current developments and modern aspects
- **panduan_pengunjung**: Practical visitor guide with how to visit, dress code, facilities, tips, etc.
''';

  final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {"text": promptText},
          {
            "inline_data": {
              "mime_type": "image/jpeg",
              "data": base64Image,
            }
          }
        ]
      }
    ]
  });

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final result =
        data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
    return result;
  } else {
    throw Exception('Failed to analyze image: ${response.reasonPhrase}');
  }
}
