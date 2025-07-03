import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/game_mode.dart';
import '../view_model/game_cubit.dart';
import '../view_model/game_state.dart';
import 'store_page.dart';

class GamePage extends StatelessWidget {
  final GameMode mode;
  const GamePage({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(mode == GameMode.arcade ? 'Аркада' : 'Бесконечный')),
      body: GestureDetector(
        onPanStart: (d) {
          if (!cubit.state.isRunning) {
            cubit.startGame(mode);
          }
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final local = box.globalToLocal(d.globalPosition);
            cubit.movePlayer(local.dx / box.size.width);
          }
          cubit.startShooting();
        },
        onPanUpdate: (d) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final local = box.globalToLocal(d.globalPosition);
            cubit.movePlayer(local.dx / box.size.width);
          }
        },
        onPanEnd: (_) => cubit.stopShooting(),
        onPanCancel: cubit.stopShooting,
        child: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black87),
                ),
                for (final ob in state.obstacles)
                  Positioned(
                    left: ob.x * MediaQuery.of(context).size.width - 15,
                    top: ob.y * MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 30,
                          child: LinearProgressIndicator(
                            value: ob.health / ob.maxHealth,
                            color: Colors.red,
                            backgroundColor: Colors.grey.shade800,
                          ),
                        ),
                        Image.asset(
                          'assets/images/enemy.png',
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                for (final bullet in state.bullets)
                  Positioned(
                    left: bullet.x * MediaQuery.of(context).size.width - 2,
                    top: bullet.y * MediaQuery.of(context).size.height,
                    child: Container(width: 4, height: 10, color: Colors.yellow),
                  ),
                Positioned(
                  bottom: state.isRunning ? 20 : 70,
                  left: state.playerX * MediaQuery.of(context).size.width - 15,
                  child: Image.asset(
                    'assets/images/player.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text('Coins: ${state.coins}'),
                ),
                if (!state.isRunning && !state.isGameOver)
                  Center(
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(16),
                      child: const Text('Нажмите чтобы начать'),
                    ),
                  ),
                if (state.isGameOver)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Игра окончена'),
                        ElevatedButton(
                          onPressed: cubit.restart,
                          child: const Text('Заново'),
                        )
                      ],
                    ),
                  ),
                if (!state.isRunning)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.grey.shade900,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const StorePage()),
                            ),
                            child: const Text('Магазин'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
