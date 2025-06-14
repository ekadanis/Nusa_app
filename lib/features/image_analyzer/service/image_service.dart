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
jelaskan objek budaya di gambar tersebut dengan dalam bentuk JSON dengan struktur berikut. Kembalikan HANYA objek JSON, TANPA blok markdown, tanpa penjelasan tambahan, dan TANPA properti type, properties, atau required. Formatnya langsung seperti ini:

{
  "type": "object",
  "properties": {
    "nama_budaya": {
      "type": "string"
    },
    "deskripsi_singkat": {
      "type": "string"
    },
    "sejarah": {
      "type": "string"
    },
    "fungsi_budaya": {
      "type": "string"
    },
    "asal_daerah": {
      "type": "string"
    },
    "filosofi_simbolik": {
      "type": "string"
    },
    "material_utama": {
      "type": "string"
    },
    "perkembangan_kini": {
      "type": "string"
    }
  },
  "required": [
    "nama_budaya",
    "deskripsi_singkat",
    "sejarah",
    "asal_daerah"
  ]
}

berikut deskripsi kolom yang ada: 
nama_budaya: nama budaya tersebut
sejarah: sejarah budaya tersebut
fungsi_budaya: fungsi budaya objek tersebut
asal_daerah: asal daerah objek tersebut
filosofi_simbolik: filosofi simbolik objek tersebut
material_utama: bahan atau material objek tersebut
perkembangan_kini: perkembangan objek tersebut hingga kini
''';

  final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {"text": promptText},
          {
            "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
          }
        ]
      }
    ]
  });

  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final result =
        data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
    return result;
  } else {
    throw Exception('Failed to analyze image: ${response.reasonPhrase}');
  }
}
