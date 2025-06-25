import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String message;
  final String date;
  final IconData iconData;
  final Color iconColor;
  final String? postId;

  NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    required this.iconData,
    required this.iconColor,
    this.postId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'],
      message: json['message'],
      date: json['date'],
      iconData: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
      iconColor: Color(json['iconColor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'date': date,
      'iconCodePoint': iconData.codePoint,
      'iconColor': iconColor.value,
    };
  }
}
