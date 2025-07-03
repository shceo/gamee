import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/skin_item.dart';
import '../model/upgrade_item.dart';
import '../view_model/game_cubit.dart';
import '../view_model/game_state.dart';

const List<SkinItem> _skins = [
  SkinItem(id: 1, title: 'Default', image: 'assets/images/player.png', price: 100),
  SkinItem(id: 2, title: 'Enemy', image: 'assets/images/enemy.png', price: 200),
];

const List<UpgradeItem> _upgrades = [
  UpgradeItem(
    id: 1,
    title: 'Attack Speed',
    description: 'Shoot faster',
    icon: Icons.flash_on,
    price: 150,
  ),
  UpgradeItem(
    id: 2,
    title: 'Damage',
    description: 'Increase bullet damage',
    icon: Icons.whatshot,
    price: 200,
  ),
];

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Store'),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(child: Text('Coins: ${state.coinBalance}')),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Skins'),
                  Tab(text: 'Upgrades'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildSkins(context, state),
                _buildUpgrades(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkins(BuildContext context, GameState state) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _skins.length,
      itemBuilder: (context, index) {
        final item = _skins[index];
        final disabled =
            state.coinBalance < item.price || state.purchasedSkinIds.contains(item.id);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(item.image, width: 64, height: 64),
              const SizedBox(height: 4),
              Text(item.title),
              Text('Price: ${item.price}'),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: disabled
                    ? null
                    : () => context.read<GameCubit>().purchaseSkin(item.id),
                child: const Text('Buy'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpgrades(BuildContext context, GameState state) {
    return ListView.builder(
      itemCount: _upgrades.length,
      itemBuilder: (context, index) {
        final cubit = context.read<GameCubit>();
        final up = _upgrades[index];
        final price = cubit.upgradePrice(up.id);
        final disabled = state.coinBalance < price;
        String current;
        if (up.id == 1) {
          current = 'Speed: ${(1 / cubit.shootInterval).toStringAsFixed(1)}/s';
        } else {
          current = 'Damage: ${cubit.bulletDamage}';
        }
        return ListTile(
          leading: Icon(up.icon),
          title: Text(up.title),
          subtitle: Text('${up.description}\n$current'),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$price'),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: disabled ? null : () => cubit.purchaseUpgrade(up.id),
                child: const Text('Buy'),
              ),
            ],
          ),
        );
      },
    );
  }
}
