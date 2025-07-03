import 'package:flutter/material.dart';

class TrophyPage extends StatelessWidget {
  const TrophyPage({super.key});

  // фирменные цвета
  static const Color bora = Color(0xFFEAECC6);
  static const Color skyline = Color(0xFF2BC0E4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bora,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: skyline,
          iconSize: 32,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            const Text(
              'Достижения',
              style: TextStyle(
                color: Color(0xFF2BC0E4),
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Иконка трофея
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Color(0xFF2BC0E4),
            ),
            const SizedBox(height: 16),
            // Подсказка
            const Text(
              'Тут будут награды и рекорды',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
