import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.widthOf(context),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white10,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurStyle: BlurStyle.outer,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
