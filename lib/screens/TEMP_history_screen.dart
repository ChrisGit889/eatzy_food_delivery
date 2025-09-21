import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TempHistoryScreen extends StatelessWidget {
  const TempHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text("History"),
                IconButton(
                  onPressed: () => {
                    FirebaseFirestore.instance.collection('test').add({
                      'testNum': 10,
                      'testString': "Test",
                      "testDate": DateTime.now(),
                    }),
                  },
                  icon: Icon(Icons.play_arrow_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
