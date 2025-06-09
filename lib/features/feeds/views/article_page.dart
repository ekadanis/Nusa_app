import 'package:flutter/material.dart';
import 'package:nusa_app/features/feeds/widgets/build_category_name.dart';
import 'package:nusa_app/models/article_model.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ArticlePage extends StatelessWidget {
  final ArticleModel article;
  const ArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title ?? 'Detail Artikel'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar artikel
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
              Image.network(
                article.imageUrl!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    article.title ?? '-',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Info kategori dan tanggal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.category, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      buildCategoryName(article.categoryId),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text(
                        article.date != null
                            ? "${article.date!.day}/${article.date!.month}/${article.date!.year}"
                            : '-',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red[400]),
                          const SizedBox(width: 6),
                          Text('${article.like ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Isi artikel
                  Text(
                    article.content ?? '-',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
