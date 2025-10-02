import 'package:flutter/material.dart';
import 'chat_screen.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool isMuted = false;
  bool isSpeakerOn = false;

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white.withOpacity(0.15),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 1),
              // Info telpon
              const Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/driver.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Budi is MAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1:25',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),

              // Layout Tombol Grid 2x2
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Baris pertama: Tombol Mute dan Chat
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMuted = !isMuted;
                          });
                        },
                        child: isMuted
                            ? _buildActionButton(Icons.mic, 'Unmute')
                            : _buildActionButton(Icons.mic_off, 'Mute'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
                            ),
                          );
                        },
                        child: _buildActionButton(Icons.chat_bubble, 'Chat'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Baris kedua: Tombol Speaker dan Record
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSpeakerOn = !isSpeakerOn;
                          });
                        },
                        child: isSpeakerOn
                            ? _buildActionButton(Icons.volume_up, 'Speaker')
                            : _buildActionButton(Icons.volume_down, 'Speaker'),
                      ),
                      _buildActionButton(Icons.voicemail, 'Record'),
                    ],
                  ),
                ],
              ),

              // Tutup Telepon
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.call_end, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
