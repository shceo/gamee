import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/game_cubit.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final coins = context.select((GameCubit c) => c.state.coins);
    return Scaffold(
      appBar: AppBar(title: const Text('Магазин')),
      body: Center(child: Text('Монет: $coins\nЗдесь будут улучшения')),
    );
  }
}
