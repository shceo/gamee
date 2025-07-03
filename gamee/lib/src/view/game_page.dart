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
        onTap: () {
          if (!cubit.state.isRunning) {
            cubit.startGame(mode);
          }
        },
        onHorizontalDragUpdate: (d) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final local = box.globalToLocal(d.globalPosition);
            cubit.movePlayer(local.dx / box.size.width);
          }
        },
        child: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black87),
                ),
                for (final ob in state.obstacles)
                  Positioned(
                    left: ob.x * MediaQuery.of(context).size.width - 10,
                    top: ob.y * MediaQuery.of(context).size.height,
                    child: Container(width: 20, height: 20, color: Colors.red),
                  ),
                Positioned(
                  bottom: 20,
                  left: state.playerX * MediaQuery.of(context).size.width - 15,
                  child: Container(width: 30, height: 30, color: Colors.blue),
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
