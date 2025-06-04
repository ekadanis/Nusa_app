import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoice;
  final VoidCallback onCancelVoice;
  final bool isRecording;

  const InputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onVoice,
    required this.onCancelVoice,
    required this.isRecording,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> with SingleTickerProviderStateMixin {
  bool isTyping = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    _animationController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final typing = widget.controller.text.trim().isNotEmpty;
    if (typing != isTyping) {
      setState(() {
        isTyping = typing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(8),
      child: Column(
        children: [
          if (widget.isRecording)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'Mendengarkan... Ketuk silang untuk berhenti',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type something...',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.isRecording) ...[
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.red[100],
                      child: const Icon(Icons.mic, color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: widget.onCancelVoice,
                  ),
                ] else
                  GestureDetector(
                    onTap: isTyping ? widget.onSend : widget.onVoice,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF438BFF),
                      child: Icon(
                        isTyping ? Icons.send : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
