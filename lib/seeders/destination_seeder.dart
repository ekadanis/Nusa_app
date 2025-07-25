import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/models.dart';
import '../services/firestore_service.dart';

class DestinationSeeder {
  static int _generateRandomRecommendationScore() {
    final random = Random();
    return 20 + random.nextInt(76);
  }

  static Future<void> seedDestinations(
      Map<String, String> categoryIds, String userId) async {
    final destinationsData = _getDestinationsData();

    for (final categoryName in destinationsData.keys) {
      final categoryId = categoryIds[categoryName];
      if (categoryId == null) {
        continue;
      }

      final destinations = destinationsData[categoryName]!;

      for (final destData in destinations) {
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

          await FirestoreService.destinationsCollection
              .add(destination.toFirestore());
        }
      }
    }
  }

  static Map<String, List<Map<String, dynamic>>> _getDestinationsData() {
    return {
      'Cultural Sites': [
        // Temples
        {
          'title': 'Candi Borobudur',
          'subcategory': 'Temples',
          'imageUrl':
              'https://images.unsplash.com/photo-1620549146396-9024d914cd99?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Q2FuZGklMjBCb3JvYnVkdXJ8ZW58MHx8MHx8fDA%3D',
          'location': const GeoPoint(-7.6079, 110.2038),
          'address':
              'Jl. Badrawati, Kw. Candi Borobudur, Magelang, Central Java ',
          'like': 245,
        },
        {
          'title': 'Candi Prambanan',
          'subcategory': 'Temples',
          'imageUrl':
              'https://images.unsplash.com/photo-1628488321763-eb2f79b7f3b5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fENhbmRpJTIwUHJhbWJhbmFufGVufDB8fDB8fHww',
          'location': const GeoPoint(-7.7520, 110.4915),
          'address':
              'Sleman, Yogyakarta',
          'like': 198,
        },
        {
          'title': 'Candi Mendut',
          'subcategory': 'Temples',
          'imageUrl':
              'https://lh3.googleusercontent.com/gps-cs-s/AC9h4nqYwxAH3A3yd97ytwkyjCuyoxrn6_aUWX9EYdDw-7ibbbTLkYIggVacvDPnfC9_oij6It4oHdc63FRnDHW5a6NKJme-T0mJPfg___2LQcFg2cbimmmq2dTqYncLU-MBOd7Yh7V_vA=s1360-w1360-h1020-rw',
          'location': const GeoPoint(-7.6044, 110.2319),
          'address': 'Mendut, Mungkid, Magelang, Central Java',
          'like': 89,
        },

        // Cultural Parks
        {
          'title': 'Taman Mini Indonesia Indah',
          'subcategory': 'Cultural Parks',
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Keong_Emas.jpg/250px-Keong_Emas.jpg',
          'location': const GeoPoint(-6.3025, 106.8951),
          'address':
              'Ceger, Cipayung, East Jakarta, Jakarta',
          'like': 156,
        },
        {
          'title': 'Taman Budaya Garuda Wisnu Kencana',
          'subcategory': 'Cultural Parks',
          'imageUrl':
              'https://lh3.googleusercontent.com/gps-cs-s/AC9h4npi2EU7KH8z81Frft1X52Zw0hmIP9TqBrC6mszKK8MhDQMPMVTzUIm9jinW8Tj6f23u2F4PDMWUqqucAo8BT7Fqsun5-qHAc8RjbjOAAsmBgAG3V4rekjcqJrOmCUqw6kwc_3zPCg=s1360-w1360-h1020-rw',
          'location': const GeoPoint(-8.8091, 115.1669),
          'address':
              'Jl. Raya Uluwatu, Ungasan, South Kuta, Badung, Bali',
          'like': 203,
        },

        // Archaeological Sites
        {
          'title': 'Situs Gunung Padang',
          'subcategory': 'Archaeological Sites',
          'imageUrl':
              'https://lh3.googleusercontent.com/gps-cs-s/AC9h4nrIt-4NeGemgYqPPVg6A1oC1ZF5EGV6iypCx9VO5dPT94m_jVZ5OrcHOGIsNA0jxA00WIPA8zNaaAWzfliktCRGNyIPRfX6k-UkDFF1OsBESaa3I0Xkcdy2qJb3fZRgM33cfcKk=s1360-w1360-h1020-rw',
          'location': const GeoPoint(-6.9947, 107.0563),
          'address': 'Karyamukti, Campaka, Cianjur, West Java',
          'like': 78,
        },
        {
          'title': 'MPU Tantular',
          'subcategory': 'Archaeological Sites',
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Mpu_Tantular_Museum.jpg/500px-Mpu_Tantular_Museum.jpg',
          'location': const GeoPoint(-7.433982, 112.719922),
          'address': 'Buduran, Sidoarjo, East Java',
          'like': 78,
        },
        {
          'title': 'Kompleks Percandian Dieng',
          'subcategory': 'Archaeological Sites',
          'imageUrl':
              'https://asset.kompas.com/crops/pHi-W-EvMqogNjq368W6XdqWJfw=/0x0:1800x1200/780x390/data/photo/2021/09/25/614ea1f2206ed.jpg',
          'location': const GeoPoint(-7.2067, 109.9125),
          'address':
              'Dieng Kulon, Batur, Banjarnegara',
          'like': 134,
        },

        // Traditional Houses
        {
          'title': 'Rumah Gadang Baanjuang',
          'subcategory': 'Traditional Houses',
          'imageUrl':
              'https://cdn.antaranews.com/cache/1200x800/2021/12/08/08.museum_1.jpg.webp',
          'location': const GeoPoint(-0.7893, 100.6501),
          'address':
              'Baanjuang, Lima Kaum, Tanah Datar',
          'like': 92,
        },
        {
          'title': 'Keraton Yogyakarta',
          'subcategory': 'Traditional Houses',
          'imageUrl':
              'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/222/2024/10/17/WhatsApp-Image-2024-10-17-at-154421-3260115575.jpeg',
          'location': const GeoPoint(-7.8053, 110.3642),
          'address':
              'Alun-alun Utara No.1, Patehan, Kraton, Yogyakarta',
          'like': 167,
        },
      ],
      'Arts & Culture': [
        // Hand-drawn Batiks
        {
          'title': 'Batik Parang Klasik',
          'subcategory': 'Hand-drawn Batiks',
          'imageUrl':
              'https://sintesakonveksi.com/info/wp-content/uploads/2021/02/Motif-Batik-Parang-Kusumo-2.jpg',
          'location': const GeoPoint(-7.5575, 110.8317), // Solo coordinates
          'address': 'Laweyan, Surakarta, Central Java',
          'like': 143,
        },
        {
          'title': 'Batik Kawung Yogya',
          'subcategory': 'Hand-drawn Batiks',
          'imageUrl':
              'https://www.jogjasiana.net/photo/handycrafts/kawung%20(1).jpg',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address':
              'Taman, Yogyakarta',
          'like': 128,
        },

        // Stamped Batiks
        {
          'title': 'Batik Cap Pekalongan',
          'subcategory': 'Stamped Batiks',
          'imageUrl':
              'https://img.freepik.com/premium-photo/batik-tulis-dan-batik-cap-asal-pekalongan-dari-indonesia-koleksi-museum-pekalongan_1048944-4780995.jpg',
          'location': const GeoPoint(-6.8886, 109.6753),
          'address': 'Kauman, Pekalongan, Central Java',
          'like': 95,
        },

        // Woven Fabrics
        {
          'title': 'Tenun Ikat Sumba',
          'subcategory': 'Woven Fabrics',
          'imageUrl':
              'https://mongabay.co.id/wp-content/uploads/2018/03/tenun-ikat.jpg',
          'location': const GeoPoint(-9.6540, 120.2640),
          'address': 'Waingapu, East Nusa Tenggara ',
          'like': 67,
        },

        // Songkets
        {
          'title': 'Songket Palembang',
          'subcategory': 'Songkets',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7rjeNTvHn9GXU_UEWc9GypqWYwoP_s7QvIA&s',
          'location': const GeoPoint(-2.9761, 104.7754),
          'address':
              'Seberang Ulu II, Palembang, South Sumatra',
          'like': 112,
        },
      ],
      'Folk Instruments': [
        // Bamboo Instruments
        {
          'title': 'Angklung Udjo Bandung',
          'subcategory': 'Bamboo Instruments',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYiCpk8OhYfiseCDpwRb7UNYzHsgeprtgF7A&s',
          'location': const GeoPoint(-6.9175, 107.6191),
          'address':
              'Pasirlayung, Cibeunying Kidul, Bandung',
          'like': 187,
        },

        // Percussion Drums
        {
          'title': 'Kendang Bali',
          'subcategory': 'Percussion Drums',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_fmM6uKe9J8tnltYefxHNdu5JkBB5_4hm7A&s',
          'location': const GeoPoint(-8.3405, 115.0920),
          'address': 'Ubud, Gianyar, Bali',
          'like': 94,
        },

        // String Instruments
        {
          'title': 'Sasando Rote',
          'subcategory': 'String Instruments',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpinWh1Ft76Z5LpTEt3BXVnCgINYg4NKlVLg&s',
          'location': const GeoPoint(-10.6872, 123.0576),
          'address': 'Rote Ndao, East Nusa Tenggara',
          'like': 56,
        },

        // Gongs
        {
          'title': 'Gamelan Jawa',
          'subcategory': 'Gongs',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7tf5-IW-WTfRAWjaGRBqf5s-a9RWn4qdhEg&s',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address':
              'Kraton, Yogyakarta',
          'like': 205,
        },
      ],
      'Traditional Wear': [
        // Women's Dresses
        {
          'title': 'Kebaya Jawa Klasik',
          'subcategory': 'Women\'s Dresses',
          'imageUrl':
              'https://hypeabis.id/assets/content/20220322181920000000sdgsdwa.jpg',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address':
              'Malioboro, Yogyakarta',
          'like': 172,
        },
        {
          'title': 'Baju Bodo Makassar',
          'subcategory': 'Women\'s Dresses',
          'imageUrl':
              'https://awsimages.detik.net.id/community/media/visual/2021/03/04/baju-bodo_169.jpeg?w=1200',
          'location': const GeoPoint(-5.1477, 119.4327),
          'address': 'Somba Opu, Gowa, South Sulawesi',
          'like': 108,
        },

        // Men's Outfits
        {
          'title': 'Beskap Jawa',
          'subcategory': 'Men\'s Outfits',
          'imageUrl':
              'https://i.pinimg.com/originals/4c/73/5e/4c735e8bf3a113375e05c53ebcd36e06.jpg',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Kauman, Surakarta, Central Java',
          'like': 89,
        },

        // Ritual Attires
        {
          'title': 'Pakaian Adat Toraja',
          'subcategory': 'Ritual Attires',
          'imageUrl':
              'https://intimedianetpedia.com/wp-content/uploads/2024/08/Baju-Pokko-1.webp',
          'location': const GeoPoint(-2.9441, 119.8707),
          'address': 'Rantepao, North Toraja, South Sulawesi',
          'like': 76,
        },

        // Festival Costumes
        {
          'title': 'Pakaian Adat Dayak',
          'subcategory': 'Festival Costumes',
          'imageUrl':
              'https://awsimages.detik.net.id/community/media/visual/2022/09/19/baju-adat-bulang-burai-king_169.jpeg?w=1200',
          'location': const GeoPoint(-0.0263, 109.3425),
          'address': 'Pontianak, West Kalimantan',
          'like': 84,
        },
      ],
      'Crafts & Artifacts': [
        // Puppetries & Masks
        {
          'title': 'Wayang Kulit Purwa',
          'subcategory': 'Puppetries & Masks',
          'imageUrl':
              'https://javanologi.uns.ac.id/wp-content/uploads/sites/26/2022/11/wayang-kulit-1024x576.jpg',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Sriwedari, Laweyan, Surakarta, Central Java',
          'like': 156,
        },
        {
          'title': 'Topeng Malangan',
          'subcategory': 'Puppetries & Masks',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVlU9kFsMVh0g3SMiubs2KCuYuwdJcaFjUvw&s',
          'location': const GeoPoint(-7.9797, 112.6304),
          'address': 'Pakisaji, Malang, East Java',
          'like': 73,
        },

        // Wood Carvings
        {
          'title': 'Ukiran Jepara',
          'subcategory': 'Wood Carvings',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9qFAbFxjZlNFrumYyp22gaE43etqGYgo7yA&s',
          'location': const GeoPoint(-6.5890, 110.6684),
          'address': 'Jepara, Jepara, Central Java',
          'like': 134,
        },

        // Potteries & Ceramics
        {
          'title': 'Keramik Plered',
          'subcategory': 'Potteries & Ceramics',
          'imageUrl':
              'https://salamolahraga.com/wp-content/uploads/2024/06/a92788c0-f3f5-4c4b-aa88-42294e9bef03.jpeg',
          'location': const GeoPoint(-6.7026, 107.3191),
          'address': 'Plered, Purwakarta, West Java',
          'like': 97,
        },

        // Traditional Weapons
        {
          'title': 'Keris Surakarta',
          'subcategory': 'Traditional Weapons',
          'imageUrl':
              'https://assets-a1.kompasiana.com/items/album/2023/08/12/gambar-2-1-64d76c2208a8b561fd4edeb2.jpg',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Kauman, Surakarta, Central Java',
          'like': 118,
        },
      ],
      'Local Foods': [
        // Meat Dishes
        {
          'title': 'Rendang Padang',
          'subcategory': 'Meat Dishes',
          'imageUrl':
              'https://images.tokopedia.net/img/KRMmCm/2022/8/9/51584c5e-2713-4895-88d5-30b677255ffd.jpg',
          'location': const GeoPoint(-0.9471, 100.4172),
          'address':
              'Jl. M. Yamin, Padang Barat, Padang, West Sumatra 25113',
          'like': 298,
        },
        {
          'title': 'Sate Madura',
          'subcategory': 'Meat Dishes',
          'imageUrl':
              'https://i.ytimg.com/vi/R0mDzP0A_DQ/sddefault.jpg',
          'location': const GeoPoint(-7.0299, 113.8435),
          'address': 'Pamekasan, Madura, East Java',
          'like': 234,
        },

        // Rice Meals
        {
          'title': 'Nasi Gudeg Yogya',
          'subcategory': 'Rice Meals',
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtMcTBIt-BHKn7NhOyeE5fOTxOUNzIU6-dCw&s',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address':
              'Wijilan, Kraton, Yogyakarta',
          'like': 187,
        },
        {
          'title': 'Nasi Liwet Solo',
          'subcategory': 'Rice Meals',
          'imageUrl':
              'https://asset-a.grid.id/crop/0x0:0x0/x/photo/2022/06/15/resep-nasi-liwet-solo-sajian-tr-20220615112823.jpg',
          'location': const GeoPoint(-7.5575, 110.8317),
          'address': 'Keprabon, Banjarsari, Surakarta, Central Java',
          'like': 165,
        },

        // Street Snacks
        {
          'title': 'Kerak Telor Betawi',
          'subcategory': 'Street Snacks',
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/b/bd/Kerak_telor_Betawi.jpg',
          'location': const GeoPoint(-6.1751, 106.8650),
          'address': 'Kota Tua, West Jakarta, DKI Jakarta',
          'like': 145,
        },

        // Traditional Desserts
        {
          'title': 'Klepon Jawa',
          'subcategory': 'Traditional Desserts',
          'imageUrl':
              'https://static.uc.ac.id/fikom/2020/12/Pic-1.jpeg',
          'location': const GeoPoint(-7.7956, 110.3695),
          'address':
              'Kotagede, Yogyakarta',
          'like': 123,
        },
        {
          'title': 'Es Cendol Bandung',
          'subcategory': 'Traditional Desserts',
          'imageUrl':
              'https://asset.kompas.com/crops/t3tdD3PwNMMiPxm7WKH-_qq4MmM=/0x0:1000x667/1200x800/data/photo/2023/03/12/640d6eac51567.jpg',
          'location': const GeoPoint(-6.9175, 107.6191),
          'address': 'Braga, Sumur Bandung, Bandung, West Java',
          'like': 178,
        },
      ],
    };
  }
}
