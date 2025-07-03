import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/game_cubit.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  // фирменные цвета
  static const Color bora = Color(0xFFEAECC6);
  static const Color skyline = Color(0xFF2BC0E4);
  // фон карточек
  static const Color surface = Color(0xFFDCEEEA);

  static const List<Map<String, dynamic>> _skins = [
    {'title': 'Default', 'image': 'assets/images/player.png', 'price': 100},
    // {'title': 'Red', 'image': 'assets/images/skin_red.png', 'price': 200},
    // {'title': 'Purple', 'image': 'assets/images/skin_purple.png', 'price': 300},
  ];
  static const List<Map<String, dynamic>> _upgrades = [
    {
      'id': 1,
      'title': 'Attack Speed',
      'icon': Icons.flash_on,
    },
    {
      'id': 2,
      'title': 'Damage',
      'icon': Icons.whatshot,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bora,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: skyline,
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Store',
            style: TextStyle(
              color: skyline,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: BlocBuilder<GameCubit, GameState>(
                  builder: (_, state) => Text(
                    'Coins: ${state.coinBalance}',
                    style: TextStyle(color: skyline, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Column(
              children: [
                TabBar(
                  labelColor: skyline,
                  unselectedLabelColor: skyline.withOpacity(0.6),
                  indicatorColor: skyline,
                  indicatorWeight: 4,
                  tabs: const [Tab(text: 'Skins'), Tab(text: 'Upgrades')],
                ),
                Container(height: 1, color: skyline.withOpacity(0.3)),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children:
                          _skins.map((item) {
                            return Container(
                              width: 140,
                              height: 200,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    item['image'],
                                    width: 64,
                                    height: 64,
                                  ),
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                      color: skyline,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: skyline,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {}, // заглушка
                                      child: Text(
                                        item['price']!.toString(),
                                        style: const TextStyle(
                                          color: bora,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
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
                      onPressed: () {}, // заглушка
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                          color: bora,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),

            BlocBuilder<GameCubit, GameState>(
              builder: (context, state) {
                final cubit = context.read<GameCubit>();
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: _upgrades.map((item) {
                            final id = item['id'] as int;
                            final price = cubit.upgradePrice(id);
                            final lines = id == 1
                                ? [
                                    'Shoot faster',
                                    'Speed: '
                                        '${(1 / cubit.shootInterval).toStringAsFixed(1)}/s'
                                  ]
                                : [
                                    'Increase bullet damage',
                                    'Damage: ${cubit.bulletDamage}'
                                  ];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: surface,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item['icon'] as IconData,
                                    size: 40,
                                    color: skyline,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title']!,
                                          style: const TextStyle(
                                            color: skyline,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          lines[0],
                                          style: const TextStyle(
                                            color: skyline,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          lines[1],
                                          style: const TextStyle(
                                            color: skyline,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 80,
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: skyline,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => cubit.purchaseUpgrade(id),
                                      child: Text(
                                        price.toString(),
                                        style: const TextStyle(
                                          color: bora,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
