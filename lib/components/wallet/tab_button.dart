import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabButton extends StatelessWidget {
  final int index;
  final String title;
  final RxInt activeTab;

  TabButton({required this.index, required this.title, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        activeTab.value = index;
      },
      child: Obx(() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            color: activeTab.value == index ? Colors.pinkAccent : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: activeTab.value == index
                ? [
              Shadow(
                blurRadius: 30,
                color: Colors.pinkAccent,
                offset: const Offset(0, 0),
              ),
            ]
                : null,
          ),
        ),
      )),
    );
  }
}
