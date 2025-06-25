import 'package:flutter/material.dart';

class MessageItem {
  final String title;
  final String message;
  final String date;
  final String? avatarImage;
  final IconData? iconData;
  final Color? iconColor;
  final String? notificationType; // 'like', 'comment', etc.
  final Map<String, dynamic>? data;

  MessageItem({
    required this.title,
    required this.message,
    required this.date,
    this.avatarImage,
    this.iconData,
    this.iconColor,
    this.notificationType,
    this.data,
  });

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      title: json['title'],
      message: json['message'],
      date: json['date'],
      avatarImage: json['avatarImage'],
      iconData: json['iconCodePoint'] != null
          ? IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons')
          : null,
      iconColor: json['iconColor'] != null ? Color(json['iconColor']) : null,
      notificationType: json['notificationType'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'date': date,
      'avatarImage': avatarImage,
      'iconCodePoint': iconData?.codePoint,
      'iconColor': iconColor?.value,
      'notificationType': notificationType,
      'data': data,
    };
  }
}
