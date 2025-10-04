import 'package:flutter/material.dart';
import 'call_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "sender": "user",
      "text": "Pickup notes from customers:\nmain entrance UNTAR 2",
      "time": "01:46 PM",
    },
    {
      "sender": "driver",
      "text": "Okay, I'll go there yeah",
      "time": "01:47 PM",
    },
    {"sender": "driver", "text": "Please wait", "time": "01:47 PM"},
    {"sender": "user", "text": "Okey 👍", "time": "01:49 PM"},
  ];

  bool _isQuickReplyVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE7DE),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isMe = message['sender'] == 'user';
                return _buildMessageBubble(
                  isMe: isMe,
                  text: message['text']!,
                  time: message['time']!,
                );
              },
            ),
          ),
          if (_isQuickReplyVisible) _buildQuickReplyPanel(),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black54),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/driver.png'),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Budi Is Man",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "B1TOIN",
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Colors.black54),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CallScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMessageBubble({
    required bool isMe,
    required String text,
    required String time,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe
              ? const Color.fromARGB(255, 255, 228, 129)
              : const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.black.withAlpha(150),
                    fontSize: 11,
                  ),
                ),
                if (isMe) const SizedBox(width: 4),
                if (isMe)
                  const Icon(Icons.check, color: Colors.blueAccent, size: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplyPanel() {
    final quickReplies = [
      "Oke 👍",
      "I'm at the Entrance",
      "Ya",
      "Okey, wait",
      "Delivery point as per application, yes",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFE7DE))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pesan cepat",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Icon(Icons.expand_more, color: Colors.black54),
              ],
            ),
          ),
          ...quickReplies.map((text) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _textController.text = text;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.messenger_outline,
                        color: Colors.black54,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(text, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.black54, size: 20),
                const SizedBox(width: 12),
                Text(
                  "Create your quick message (0/2)",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 235, 202),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black54),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _isQuickReplyVisible = !_isQuickReplyVisible;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 255, 196, 0),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
