class NewsArticle {
  final String title;
  final String url;
  final String image;
  final DateTime publishedAt;
  int likes;


  NewsArticle({
    required this.title,
    required this.url,
    required this.image,
    required this.publishedAt,
    this.likes = 0,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      url: json['link'] ?? '',
      image: json['image_url'] ?? '',
      publishedAt: DateTime.tryParse(json['pubDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'url': url,
    'image': image,
    'publishedAt': publishedAt.toIso8601String(),
  };
}
