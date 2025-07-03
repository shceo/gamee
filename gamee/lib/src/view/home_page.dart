import 'package:flutter/material.dart';
import '../model/game_mode.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Ваши фирменные цвета
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
          icon: const Icon(Icons.emoji_events),
          color: skyline,
          onPressed: () => Navigator.pushNamed(context, '/trophy'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: skyline,
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Text(
              'Dodgefall',
              style: TextStyle(
                color: skyline,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),

            // Кнопка «Аркада»
            SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: skyline,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: GameMode.arcade,
                ),
                child: const Text(
                  'Аркада',
                  style: TextStyle(
                    color: bora,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Кнопка «Бесконечный режим»
            SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: skyline,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/game',
                  arguments: GameMode.endless,
                ),
                child: const Text(
                  'Бесконечный режим',
                  style: TextStyle(
                    color: bora,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
