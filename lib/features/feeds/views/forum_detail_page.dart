import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/core/app_colors.dart';
import 'package:nusa_app/core/styles.dart';
import 'package:nusa_app/l10n/l10n.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:nusa_app/routes/router.dart';

@RoutePage()
class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({super.key});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildPostContent(),
          const Divider(),
          _buildCommentsHeader(),
          Expanded(
            child: _buildCommentsList(),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, size: 16),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          const Text(
            'Saif Desur',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.verified,
              size: 16,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Batik is a traditional fabric known for its detailed patterns and handmade dyeing process. Each design tells a unique cultural story.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite_border,
                      color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  const Text('12rb', style: TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.comment_outlined, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  const Text('300', style: TextStyle(fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return const Padding(
      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Komentar',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    final comments = [
      {
        'name': 'Andi Pratama',
        'text':
            'Batik is a traditional fabric known for its detailed designs and unique hand-dyeing process. Each pattern has its own cultural story behind it.',
        'time': '1 jam yang lalu',
      },
      {
        'name': 'Ricky Hidayat',
        'text':
            'Making batik involves applying hot wax to fabric and then dyeing it in natural dye. It\'s a labor intensive process to get all these intricate designs.',
        'time': '2 jam yang lalu',
      },
      {
        'name': 'Hikista Uzumaki',
        'text':
            'Batik is such an important part of our heritage, often tied to various animals, or even historical events. So it\'s more than just clothing - it\'s a way to tell a story.',
        'time': '3 jam yang lalu',
      },
      {
        'name': 'Bayu Ramadhan',
        'text':
            'Batik is a major part of Indonesian culture and was even recognized by UNESCO as an intangible cultural heritage. Different regions have their own styles like Pekalongan or Yogyakarta.',
        'time': '3 jam yang lalu',
      },
      {
        'name': 'Sakura Hando',
        'text':
            'Batik fabric is usually made from cotton or silk, making it comfy to wear. Silk batik is often used for fancy occasions, while cotton is great for everyday use.',
        'time': '3 jam yang lalu',
      },
      {
        'name': 'Mikaza Jaeger',
        'text':
            'Nowadays, batik is getting a modern twist, and people from all over the world are wearing it. It\'s cool to see how it\'s evolving!',
        'time': '3 jam yang lalu',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: comments.length,
      itemBuilder: (context, index) => _buildComment(
        comments[index]['name']!,
        comments[index]['text']!,
        comments[index]['time']!,
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.purple,
            child: Text('T', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Type your message here...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(String name, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentAvatar(name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentAvatar(String name) {
    final Color avatarColor = _getAvatarColor(name);

    return CircleAvatar(
      radius: 16,
      backgroundColor: avatarColor,
      child: Text(
        name[0],
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final firstLetter = name[0].toUpperCase();

    switch (firstLetter) {
      case 'A':
        return Colors.black;
      case 'R':
        return Colors.black;
      case 'H':
        return Colors.green;
      case 'B':
        return Colors.brown;
      case 'S':
        return Colors.orange;
      case 'M':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }
}
