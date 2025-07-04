import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamee/src/view_model/game_state.dart';

import '../view_model/game_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Настройки',
              style: TextStyle(
                color: skyline,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),

            SizedBox(
              width: 280,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Включить звук',
                    style: TextStyle(
                      color: skyline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: Colors.white,
                    activeTrackColor: skyline,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: 280,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Включить музыку',
                    style: TextStyle(
                      color: skyline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: Colors.white,
                    activeTrackColor: skyline,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            BlocBuilder<GameCubit, GameState>(
              buildWhen: (p, c) => p.vibrationEnabled != c.vibrationEnabled,
              builder: (context, state) {
                return SizedBox(
                  width: 280,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Вибрация',
                        style: TextStyle(
                          color: skyline,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: state.vibrationEnabled,
                        onChanged:
                            (v) => context.read<GameCubit>().toggleVibration(v),
                        activeColor: Colors.white,
                        activeTrackColor: skyline,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 48),
            SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: skyline,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => Dialog(
                          backgroundColor: SettingsPage.bora,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          insetPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Очистить данные',
                                  style: TextStyle(
                                    color: SettingsPage.skyline,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Text(
                                  'Вы собираетесь удалить всю историю игры. '
                                  'Это действие необратимо.',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: Text(
                                        'Отмена',
                                        style: TextStyle(
                                          color: SettingsPage.skyline,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 48,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: SettingsPage.skyline,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Text(
                                            'Удалить',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  );

                  if (confirm == true) {
                    await context.read<GameCubit>().resetProgress();
                  }
                },
                child: const Text(
                  'Очистить историю игры',
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
