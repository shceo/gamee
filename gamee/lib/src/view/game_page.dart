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

  @override
  void initState() {
    super.initState();
    _game = DodgefallGame(context.read<GameCubit>(), widget.mode);
    _game.pauseEngine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<DodgefallGame>(
        game: _game,
        overlayBuilderMap: {
          'hud': (ctx, game) {
            final g = game as DodgefallGame;
            Widget modeInfo;
            if (g.mode == GameMode.endless) {
              modeInfo = ValueListenableBuilder<double>(
                valueListenable: g.elapsed,
                builder: (_, t, __) => Text('Time: ${t.toStringAsFixed(1)}'),
              );
            } else {
              modeInfo = ValueListenableBuilder<int>(
                valueListenable: g.levelNotifier,
                builder: (_, l, __) => Text('Level: $l'),
              );
            }
            return SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _game.reset();
                      Navigator.pop(context);
                    },
                  ),
                  modeInfo,
                  BlocBuilder<GameCubit, GameState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Coins: ${state.coinBalance}'),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          'gameover': (_, __) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Game Over'),
                    ElevatedButton(
                      onPressed: () {
                        _game.reset();
                      },
                      child: const Text('Restart'),
                    ),
                  ],
                ),
              ),
          'start': (_, __) => Stack(
                children: [
                  Center(
                    child: Text(
                      'нажмите что бы начать',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Positioned(
                    bottom: 32,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/store'),
                        child: const Text('StorePage'),
                      ),
                    ),
                  ),
                ],
              ),
        },
        initialActiveOverlays: const ['hud', 'start'],
      ),
    );
  }
}
