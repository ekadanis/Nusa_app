import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/models.dart';
import '../services/firestore_service.dart';

class DestinationSeeder {
  static int _generateRandomRecommendationScore() {
    final random = Random();
    // Generate recommendation scores between 20-95
    return 20 + random.nextInt(76); // 76 = 95 - 20 + 1
  }
  
  static Future<void> seedDestinations(Map<String, String> categoryIds, String userId) async {
    print('🌱 Seeding Destinations...');
    
    // Get all destination data organized by category
    final destinationsData = _getDestinationsData();
    int createdCount = 0;
    
    for (final categoryName in destinationsData.keys) {
      final categoryId = categoryIds[categoryName];
      if (categoryId == null) {
        print('⚠️ Category ID not found for: $categoryName');
        continue;
      }
      
      final destinations = destinationsData[categoryName]!;
      
      for (final destData in destinations) {
        // Check if destination already exists
        final existing = await FirestoreService.destinationsCollection
            .where('title', isEqualTo: destData['title'])
            .where('categoryId', isEqualTo: categoryId)
            .get();
              if (existing.docs.isEmpty) {
          final destination = DestinationModel(
            categoryId: categoryId,
            subcategory: destData['subcategory'],
            imageUrl: destData['imageUrl'],
            location: destData['location'],
            address: destData['address'],
            title: destData['title'],
            like: destData['like'],
            recommendation: _generateRandomRecommendationScore(),
          );
          
          final docRef = await FirestoreService.destinationsCollection.add(destination.toFirestore());
          createdCount++;
          print('🏛️ Created destination: ${destData['title']} (${destData['subcategory']}) with ID: ${docRef.id}');
        } else {
          print('🏛️ Destination "${destData['title']}" already exists');
        }
      }
    }
      print('🌱 Destinations seeding completed: $createdCount new destinations created');
  }
  
  static Map<String, List<Map<String, dynamic>>> _getDestinationsData() {
    return {
      'Cultural Sites': [
        // Temples
        {
          'title': 'Candi Borobudur',
          'subcategory': 'Temples',
          'imageUrl': 'https://images.unsplash.com/photo-1620549146396-9024d914cd99?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Q2FuZGklMjBCb3JvYnVkdXJ8ZW58MHx8MHx8fDA%3D',
          'location': const GeoPoint(-7.6079, 110.2038),
          'address': 'Jl. Badrawati, Kw. Candi Borobudur, Borobudur, Magelang, Central Java 56553',
          'like': 245,
        },
        {
          'title': 'Candi Prambanan',
          'subcategory': 'Temples',
          'imageUrl': 'https://images.unsplash.com/photo-1628488321763-eb2f79b7f3b5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fENhbmRpJTIwUHJhbWJhbmFufGVufDB8fDB8fHww',
          'location': const GeoPoint(-7.7520, 110.4915),
          'address': 'Jl. Raya Solo - Yogyakarta No.16, Kranggan, Bokoharjo, Prambanan, Sleman Regency, Special Region of Yogyakarta 55571',
          'like': 198,
        },
        {
          'title': 'Candi Mendut',
          'subcategory': 'Temples',
          'imageUrl': 'https://lh3.googleusercontent.com/gps-cs-s/AC9h4nqYwxAH3A3yd97ytwkyjCuyoxrn6_aUWX9EYdDw-7ibbbTLkYIggVacvDPnfC9_oij6It4oHdc63FRnDHW5a6NKJme-T0mJPfg___2LQcFg2cbimmmq2dTqYncLU-MBOd7Yh7V_vA=s1360-w1360-h1020-rw',
          'location': const GeoPoint(-7.6044, 110.2319),
          'address': 'Mendut, Mungkid, Magelang Regency, Central Java 56512',
          'like': 89,
        },
        
        // Cultural Parks
        {
          'title': 'Taman Mini Indonesia Indah',
          'subcategory': 'Cultural Parks',
          'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Keong_Emas.jpg/250px-Keong_Emas.jpg',
          'location': const GeoPoint(-6.3025, 106.8951),
          'address': 'Taman Mini Indonesia Indah, Ceger, Cipayung, East Jakarta City, Jakarta 13820',
          'like': 156,
        },
        {
          'title': 'Taman Budaya Garuda Wisnu Kencana',
          'subcategory': 'Cultural Parks',
          'imageUrl': 'https://lh3.googleusercontent.com/gps-cs-s/AC9h4npi2EU7KH8z81Frft1X52Zw0hmIP9TqBrC6mszKK8MhDQMPMVTzUIm9jinW8Tj6f23u2F4PDMWUqqucAo8BT7Fqsun5-qHAc8RjbjOAAsmBgAG3V4rekjcqJrOmCUqw6kwc_3zPCg=s1360-w1360-h1020-rw',
          'location': const GeoPoint(-8.8091, 115.1669),
          'address': 'Jl. Raya Uluwatu, Ungasan, South Kuta, Badung Regency, Bali 80364',
          'like': 203,
        },
        
        
        // Archaeological Sites
        {
          'title': 'Situs Gunung Padang',
          'subcategory': 'Archaeological Sites',
          'imageUrl': 'https://lh3.googleusercontent.com/gps-cs-s/AC9h4nrIt-4NeGemgYqPPVg6A1oC1ZF5EGV6iypCx9VO5dPT94m_jVZ5OrcHOGIsNA0jxA00WIPA8zNaaAWzfliktCRGNyIPRfX6k-UkDFF1OsBESaa3I0Xkcdy2qJb3fZRgM33cfcKk=s1360-w1360-h1020-rw',
          'location': const GeoPoint(-6.9947, 107.0563),
          'address': 'Karyamukti, Campaka, Cianjur Regency, West Java 43292',
          'like': 78,
        },
          {
          'title': 'MPU Tantular',
          'subcategory': 'Archaeological Sites',
          'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Mpu_Tantular_Museum.jpg/500px-Mpu_Tantular_Museum.jpg',
          'location': const GeoPoint(-7.433982, 112.719922),
          'address': 'Buduran, Sidoarjo, Jawa Timur',
          'like': 78,
        },
        {
          'title': 'Kompleks Percandian Dieng',
          'subcategory': 'Archaeological Sites',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.2067, 109.9125),
          'address': 'Dieng Kulon, Batur, Banjarnegara Regency, Central Java 53456',
          'like': 134,
        },
        
        // Traditional Houses
        {
          'title': 'Rumah Gadang Baanjuang',
          'subcategory': 'Traditional Houses',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-0.7893, 100.6501),
          'address': 'Baanjuang, Lima Kaum, Tanah Datar Regency, West Sumatra 27213',
          'like': 92,
        },
        {
          'title': 'Keraton Yogyakarta',
          'subcategory': 'Traditional Houses',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.8053, 110.3642),
          'address': 'Alun-alun Utara No.1, Patehan, Kraton, Yogyakarta City, Special Region of Yogyakarta 55133',
          'like': 167,
        },
      ],

      'Arts & Culture': [
        // Hand-drawn Batiks
        {
          'title': 'Batik Parang Klasik',
          'subcategory': 'Hand-drawn Batiks',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-7.5575, 110.8317), // Solo coordinates
          'address': 'Laweyan, Surakarta City, Central Java 57146',
          'like': 143,
        },
        {
          'title': 'Batik Kawung Yogya',
          'subcategory': 'Hand-drawn Batiks',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address': 'Taman, Yogyakarta City, Special Region of Yogyakarta 55243',
          'like': 128,
        },
        
        // Stamped Batiks
        {
          'title': 'Batik Cap Pekalongan',
          'subcategory': 'Stamped Batiks',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-6.8886, 109.6753),
          'address': 'Kauman, Pekalongan City, Central Java 51123',
          'like': 95,
        },
        
        // Woven Fabrics
        {
          'title': 'Tenun Ikat Sumba',
          'subcategory': 'Woven Fabrics',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-9.6540, 120.2640),
          'address': 'Waingapu, East Sumba Regency, East Nusa Tenggara 87112',
          'like': 67,
        },
        
        // Songkets
        {
          'title': 'Songket Palembang',
          'subcategory': 'Songkets',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-2.9761, 104.7754),
          'address': '13 Ulu, Seberang Ulu II, Palembang City, South Sumatra 30267',
          'like': 112,
        },
      ],

      'Folk Instruments': [
        // Bamboo Instruments
        {
          'title': 'Angklung Udjo Bandung',
          'subcategory': 'Bamboo Instruments',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-6.9175, 107.6191),
          'address': 'Jl. Padasuka No.118, Pasirlayung, Cibeunying Kidul, Bandung City, West Java 40192',
          'like': 187,
        },
        
        // Percussion Drums
        {
          'title': 'Kendang Bali',
          'subcategory': 'Percussion Drums',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-8.3405, 115.0920),
          'address': 'Ubud, Gianyar Regency, Bali 80571',
          'like': 94,
        },
        
        // String Instruments
        {
          'title': 'Sasando Rote',
          'subcategory': 'String Instruments',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-10.6872, 123.0576),
          'address': 'Ba\'a, Rote Ndao Regency, East Nusa Tenggara 85982',
          'like': 56,
        },
        
        // Gongs
        {
          'title': 'Gamelan Jawa',
          'subcategory': 'Gongs',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address': 'Kraton, Yogyakarta City, Special Region of Yogyakarta 55133',
          'like': 205,
        },
      ],

      'Traditional Wear': [
        // Women's Dresses
        {
          'title': 'Kebaya Jawa Klasik',
          'subcategory': 'Women\'s Dresses',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address': 'Malioboro, Yogyakarta City, Special Region of Yogyakarta 55271',
          'like': 172,
        },
        {
          'title': 'Baju Bodo Makassar',
          'subcategory': 'Women\'s Dresses',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-5.1477, 119.4327),
          'address': 'Somba Opu, Gowa Regency, South Sulawesi 92113',
          'like': 108,
        },
        
        // Men's Outfits
        {
          'title': 'Beskap Jawa',
          'subcategory': 'Men\'s Outfits',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Kauman, Surakarta City, Central Java 57122',
          'like': 89,
        },
        
        // Ritual Attires
        {
          'title': 'Pakaian Adat Toraja',
          'subcategory': 'Ritual Attires',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-2.9441, 119.8707),
          'address': 'Rantepao, North Toraja Regency, South Sulawesi 91831',
          'like': 76,
        },
        
        // Festival Costumes
        {
          'title': 'Pakaian Adat Dayak',
          'subcategory': 'Festival Costumes',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-0.0263, 109.3425),
          'address': 'Pontianak City, West Kalimantan 78111',
          'like': 84,
        },
      ],

      'Crafts & Artifacts': [
        // Puppetries & Masks
        {
          'title': 'Wayang Kulit Purwa',
          'subcategory': 'Puppetries & Masks',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Sriwedari, Laweyan, Surakarta City, Central Java 57142',
          'like': 156,
        },
        {
          'title': 'Topeng Malangan',
          'subcategory': 'Puppetries & Masks',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.9797, 112.6304),
          'address': 'Pakisaji, Malang Regency, East Java 65162',
          'like': 73,
        },
        
        // Wood Carvings
        {
          'title': 'Ukiran Jepara',
          'subcategory': 'Wood Carvings',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-6.5890, 110.6684),
          'address': 'Jepara, Jepara Regency, Central Java 59419',
          'like': 134,
        },
        
        // Potteries & Ceramics
        {
          'title': 'Keramik Plered',
          'subcategory': 'Potteries & Ceramics',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-6.7026, 107.3191),
          'address': 'Plered, Purwakarta Regency, West Java 41162',
          'like': 97,
        },
        
        // Traditional Weapons
        {
          'title': 'Keris Surakarta',
          'subcategory': 'Traditional Weapons',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Kauman, Surakarta City, Central Java 57122',
          'like': 118,
        },
      ],

      'Local Foods': [
        // Meat Dishes
        {
          'title': 'Rendang Padang',
          'subcategory': 'Meat Dishes',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-0.9471, 100.4172), // Padang coordinates
          'address': 'Jl. M. Yamin, Padang Barat, Padang City, West Sumatra 25113',
          'like': 298,
        },
        {
          'title': 'Sate Madura',
          'subcategory': 'Meat Dishes',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.0299, 113.8435),
          'address': 'Pamekasan, Madura, East Java 69319',
          'like': 234,
        },

        // Rice Meals
        {
          'title': 'Nasi Gudeg Yogya',
          'subcategory': 'Rice Meals',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address': 'Wijilan, Kraton, Yogyakarta City, Special Region of Yogyakarta 55131',
          'like': 187,
        },
        {
          'title': 'Nasi Liwet Solo',
          'subcategory': 'Rice Meals',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Keprabon, Banjarsari, Surakarta City, Central Java 57132',
          'like': 165,
        },
        
        // Street Snacks
        {
          'title': 'Kerak Telor Betawi',
          'subcategory': 'Street Snacks',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-6.1751, 106.8650),
          'address': 'Kota Tua, West Jakarta, DKI Jakarta 11110',
          'like': 145,
        },
        
        // Traditional Desserts
        {
          'title': 'Klepon Jawa',
          'subcategory': 'Traditional Desserts',
          'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address': 'Kotagede, Yogyakarta City, Special Region of Yogyakarta 55173',
          'like': 123,
        },
        {
          'title': 'Es Cendol Bandung',
          'subcategory': 'Traditional Desserts',
          'imageUrl': 'https://images.unsplash.com/photo-1565967511849-76a60a516170',
          'location': const GeoPoint(-6.9175, 107.6191),
          'address': 'Braga, Sumur Bandung, Bandung City, West Java 40111',
          'like': 178,
        },
      ],
    };
  }
}
