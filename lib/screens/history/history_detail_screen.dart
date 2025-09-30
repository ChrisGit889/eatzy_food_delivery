import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0x00000000)),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Placeholder(),
      ),
    );
  }
}
