import 'package:flutter/material.dart';

class VoiceInputButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isRecording;

  const VoiceInputButton({
    super.key,
    required this.onPressed,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isRecording ? const Color(0x19F44336) : Colors.transparent,
          boxShadow: isRecording
              ? [
                  BoxShadow(
                    color: const Color(0x66FF0000),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Icon(
          Icons.mic,
          size: isRecording ? 30 : 26,
          color: isRecording ? Colors.red : Colors.grey[600],
        ),
      ),
    );
  }
}
