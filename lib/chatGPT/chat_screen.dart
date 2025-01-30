import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_content_recommendation_application/chatGPT/chat_message.dart';
import 'package:smart_content_recommendation_application/utils/three_dots.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
 

  final String? geminiApiKey = dotenv.env['API_KEY'] ;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    String userMessage = _controller.text;
    ChatMessage message = ChatMessage(text: userMessage, sender: "user", isImage: false);
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    
      _generateText(userMessage);
  }

  Future<void> _generateText(String userMessage) async {
    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$geminiApiKey'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"contents": [{"parts": [{"text": userMessage}]}]}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String botResponse = responseBody['candidates'][0]['content']['parts'][0]['text'];
      insertNewData(botResponse, isImage: false);
    } else {
      insertNewData("Error occurred", isImage: false);
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(text: response, sender: "bot", isImage: isImage);
    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => _sendMessage(),
              decoration: const InputDecoration.collapsed(
                  hintText: "Ask something "),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            _sendMessage();
          },
        ),
       
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lets Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          if (_isTyping) const ThreeDots(),
          const Divider(height: 10.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
