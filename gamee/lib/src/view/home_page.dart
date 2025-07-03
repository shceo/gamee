import 'package:flutter/material.dart';
import '../model/game_mode.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.emoji_events),
          onPressed: () => Navigator.pushNamed(context, '/trophy'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
        title: const Text('Dodgefall'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/game',
                arguments: GameMode.arcade,
              ),
              child: const Text('Аркада'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/game',
                arguments: GameMode.endless,
              ),
              child: const Text('Бесконечный режим'),
            ),
          ],
        ),
      ),
    );
  }
}
