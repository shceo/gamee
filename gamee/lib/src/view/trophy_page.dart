import 'package:flutter/material.dart';

class TrophyPage extends StatelessWidget {
  const TrophyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Достижения')),
      body: const Center(child: Text('Тут будут награды и рекорды')),
    );
  }
}
