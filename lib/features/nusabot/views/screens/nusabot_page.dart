import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nusa_app/features/nusabot/services/chatbot_service.dart';
import 'package:nusa_app/features/nusabot/views/widgets/common_app_bar.dart';
import 'package:sizer/sizer.dart';
import '../../data/chat_message.dart';
import 'package:nusa_app/features/nusabot/views/widgets/chat_buble.dart';
import 'package:nusa_app/features/nusabot/views/widgets/input_field.dart';

@RoutePage()
class NusaBotPage extends StatefulWidget {
  const NusaBotPage({super.key});

  @override
  State<NusaBotPage> createState() => _NusaBotPageState();
}

class _NusaBotPageState extends State<NusaBotPage> {
  final _controller = TextEditingController();
  final _service = ChatbotService();
  final _scrollController = ScrollController();

  // @override
  // void deactivate() {
  //   _service.stopTts(); //stop suara waktu user keluar dari tab nusabot
  //   super.deactivate();
  //   print("[TTS] Stopped due to screen change");
  // }

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _service.messages.add(
      ChatMessage(
          text: 'Hello Nusa friend , I am here to help you! 😊',
          isUser: false,
          timestamp: DateTime.now()),
    );
    setState(() {}); // biar langsung kelihatan di UI
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _service.stopTts();
    super.dispose();
  }

  void _sendTextMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    // setState(() {});
    await _service.sendMessage(text);
    setState(() {});
    _scrollToBottom();
  }

  void _sendVoiceMessage() async {
    setState(() {});
    await _service.sendVoiceMessage();
    setState(() {});
  }

  Future<void> _stopVoiceRecording() async {
    await _service.stopVoiceRecording();
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _service.messages.length.clamp(0, 50),
              itemBuilder: (context, index) {
                final msg = _service.messages[index];
                return Column(
                  crossAxisAlignment: msg.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    ChatBubble(
                      message: msg.text,
                      isUser: msg.isUser,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('h:mm a').format(msg.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 56 : 0,
            ),
            child: InputField(
              controller: _controller,
              onSend: _sendTextMessage,
              onVoice: _sendVoiceMessage,
              onCancelVoice: _stopVoiceRecording,
              isRecording: _service.isRecording,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(22.h),
      child: CommonAppBar(
        username: "NusaBot",
        subtitle: "Online",
        avatarPath: "assets/images/nusabot_logo-2.png",
        onNotificationTap: () {}, // Kosongkan atau isi sesuai kebutuhan
      ),
    );
  }
}
