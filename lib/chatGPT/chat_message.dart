import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: sender == "user" ? Colors.red.shade200 : Colors.green.shade200,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(sender),
          ),
        ),
        Expanded(
          child: isImage
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    text,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const CircularProgressIndicator.adaptive(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    text.trim(),
                    style: const TextStyle(fontSize: 16.0)
                  ),
                ),
        ),
      ],
    );
  }
}
