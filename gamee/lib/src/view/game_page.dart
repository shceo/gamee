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
    _game = DodgefallGame(context.read<GameCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<DodgefallGame>(
        game: _game,
        overlayBuilderMap: {
          'hud': (ctx, game) {
            return BlocBuilder<GameCubit, GameState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Coins: ${state.coinBalance}'),
                );
              },
            );
          },
          'gameover': (_, __) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Game Over'),
                    ElevatedButton(
                      onPressed: () {
                        _game.overlays.remove('gameover');
                        _game.resumeEngine();
                      },
                      child: const Text('Restart'),
                    ),
                  ],
                ),
              ),
        },
        initialActiveOverlays: const ['hud'],
      ),
    );
  }
}
