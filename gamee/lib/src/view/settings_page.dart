import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/game_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dodgefall — это игра, в которой вы уклоняетесь от препятствий '
              'и собираете монеты для покупки улучшений и скинов.',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Очистить данные'),
                    content: const Text(
                      'Вы собираетесь удалить всю историю игры. Это действие '
                      'необратимо.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Удалить'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await context.read<GameCubit>().resetProgress();
                }
              },
              child: const Text('Очистить историю игры'),
            ),
          ],
        ),
      ),
    );
  }
}
