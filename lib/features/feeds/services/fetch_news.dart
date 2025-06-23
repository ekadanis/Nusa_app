import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../../models/article_model.dart';
import 'dart:convert';

String encodeUrlToDocId(String url) => base64Url.encode(utf8.encode(url));

Future<int> getLikesForUrl(String url) async {
  final docId = encodeUrlToDocId(url);
  final doc = await FirebaseFirestore.instance
      .collection('news_likes')
      .doc(docId)
      .get();
  if (doc.exists) {
    return doc['likes'] ?? 0;
  }
  return 0;
}

Future<List<NewsArticle>> fetchFeaturedIndonesianCultureNews({int max = 10}) async {
  const apiKey = '44d8f45a235401d6ae05b0633d7b0fb5';
  final url = Uri.parse(
    'https://gnews.io/api/v4/search?q=indonesia%20culture&lang=en&max=$max&apikey=$apiKey',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List articles = data['articles'];

    final List<NewsArticle> result = [];

    for (final json in articles) {
      final article = NewsArticle.fromJson(json);
      article.likes = await getLikesForUrl(article.url);
      result.add(article);
    }

    // Sort descending by likes
    result.sort((a, b) => b.likes.compareTo(a.likes));

    return result;
  } else {
    throw Exception('Failed to load featured news');
  }
}

Future<List<NewsArticle>> fetchIndonesianCultureNews({String query = 'indonesia culture'}) async {
  const apiKey = 'pub_9d217e316495475f9d478adc50fac52c';

  // Ganti spasi dengan %20
  final encodedQuery = query.replaceAll(' ', '%20');
  print("\n\nENCODED QUERY: <<< $encodedQuery");

  final url = Uri.parse(
    'https://newsdata.io/api/1/latest?apikey=${apiKey}&q=${encodedQuery}',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List articles = data['results'];

    final List<NewsArticle> result = [];
    for (final json in articles) {
      final article = NewsArticle.fromJson(json);
      result.add(article);
    }

    return result;
  } else {
    throw Exception('Failed to load news');
  }
}


