import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final String? avatarImage;
  final IconData? iconData;
  final Color? iconColor;

  const MessageTile({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    this.avatarImage,
    this.iconData,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor ?? Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: avatarImage != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.image,
                color: Colors.grey,
                size: 24,
              ),
            ),
          )
              : Icon(
            iconData ?? Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }
}
