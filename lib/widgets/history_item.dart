import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Color.fromARGB(255, 184, 184, 184),
        width: MediaQuery.widthOf(context),
        height: 100,
      ),
    );
  }
}
