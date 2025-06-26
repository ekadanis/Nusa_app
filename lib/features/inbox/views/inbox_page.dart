import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nusa_app/features/inbox/services/inbox_notification_services.dart';
import '../model/notification_item.dart';
import '../widget/notification_tile.dart';

@RoutePage()
class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  List<NotificationItem> systemNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    final dataList = await InboxNotificationServices.getAllNotifications();

    systemNotifications = dataList.map((data) {
      final timestamp = data['updateAt'];
      final formattedDate = timestamp != null && timestamp is Timestamp
          ? _formatDate(timestamp.toDate())
          : _formatDate(DateTime.now());

      final String type = data['type'] ?? 'default';
      final IconData iconData;
      final Color iconColor;

      switch (type) {
        case 'welcome':
          iconData = Icons.campaign;
          iconColor = Colors.blue;
          break;
        case 'post':
          iconData = Icons.forum;
          iconColor = Colors.orange;
          break;
        default:
          iconData = Icons.notifications;
          iconColor = Colors.grey;
      }

      return NotificationItem(
        title: data['title'] ?? 'No Title',
        message: data['message'] ?? '',
        date: formattedDate,
        iconData: iconData,
        iconColor: iconColor,
        postId: data['postId'],
      );
    }).toList();

    setState(() {
      _isLoading = false;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildNotificationsList(),
    );
  }

  Widget _buildNotificationsList() {
    if (systemNotifications.isEmpty) {
      return const Center(child: Text('No notifications'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: systemNotifications.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: Colors.grey,
        indent: 70,
      ),
      itemBuilder: (context, index) {
        final notification = systemNotifications[index];
        return NotificationTile(
          title: notification.title,
          message: notification.message,
          postId: notification.postId,
          date: notification.date,
          iconData: notification.iconData,
          iconColor: notification.iconColor,
          
        );
      },
    );
  }
}
