import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoice;
  final bool isRecording;

  const InputField({
    super.key,
      required this.controller,
      required this.onSend,
      required this.onVoice,
      required this.isRecording});
  

  @override
  State<InputField> createState() => _InputFieldState();
}      

class _InputFieldState extends State<InputField>{
  bool isTyping = false;

  @override
  void initState(){
    super.initState();
    widget.controller.addListener(_handlerTextChange);
  }

  @override
  void dispose(){
    widget.controller.removeListener(_handlerTextChange);
    super.dispose();
  }

  void _handlerTextChange(){
    final typing = widget.controller.text.trim().isNotEmpty;
    if (typing != isTyping){
      setState(() {
        isTyping = typing;
      });
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Container(
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
                        hintText: 'Type something...'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: isTyping? widget.onSend : widget.onVoice,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF438BFF),
                    radius: 22,
                    child: Icon(
                      isTyping ? Icons.send : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )));
  }
}
