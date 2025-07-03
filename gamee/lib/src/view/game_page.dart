import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../flame/dodgefall_game.dart';
import '../view_model/game_cubit.dart';
import '../view_model/game_state.dart';
import '../model/game_mode.dart';

class GamePage extends StatefulWidget {
  final GameMode mode;
  const GamePage({super.key, required this.mode});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late DodgefallGame _game;

  // фирменные цвета
  static const Color bora = Color(0xFFEAECC6);
  static const Color skyline = Color(0xFF2BC0E4);

  @override
  void initState() {
    super.initState();
    _game = DodgefallGame(context.read<GameCubit>(), widget.mode);
    _game.pauseEngine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bora,
      body: GameWidget<DodgefallGame>(
        
        game: _game,
        overlayBuilderMap: {
          // — HUD (строка сверху) —
          'hud': (ctx, game) {
            final textStyle = const TextStyle(
              color: skyline,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            );
            Widget modeInfo;
            if (game.mode == GameMode.endless) {
              modeInfo = ValueListenableBuilder<double>(
                valueListenable: game.elapsed,
                builder:
                    (_, t, __) =>
                        Text('Time: ${t.toStringAsFixed(1)}', style: textStyle),
              );
            } else {
              modeInfo = ValueListenableBuilder<int>(
                valueListenable: game.levelNotifier,
                builder: (_, l, __) => Text('Level: $l', style: textStyle),
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: skyline,
                      iconSize: 32,
                      onPressed: () {
                        _game.reset();
                        Navigator.pop(context);
                      },
                    ),
                    modeInfo,
                    BlocBuilder<GameCubit, GameState>(
                      builder:
                          (_, state) => Text(
                            'Coins: ${state.coinBalance}',
                            style: textStyle,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },

          // — Start Overlay —
          'start':
              (ctx, __) => SafeArea(
                child: Stack(
                  children: [
                    // Центр: «нажмите что бы начать»
                    Center(
                      child: Text(
                        'нажмите\nчто бы начать',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: skyline,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
                          iconSize: 64,
                          color: skyline,
                          onPressed: () {
                            _game.pauseEngine();
                            Navigator.pushNamed(ctx, '/store');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          'gameover':
              (ctx, __) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // «Game Over»
                    const Text(
                      'Game Over',
                      style: TextStyle(
                        color: skyline,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
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
                        onPressed: () {
                          _game.reset();
                        },
                        child: const Text(
                          'Restart',
                          style: TextStyle(
                            color: bora,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/images/player.png',
                      width: 64,
                      height: 64,
                    ),
                  ],
                ),
              ),
        },
        initialActiveOverlays: const ['hud', 'start'],
      ),
    );
  }
}
