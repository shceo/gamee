import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view/home_page.dart';
import 'view/game_page.dart';
import 'view/settings_page.dart';
import 'view/trophy_page.dart';
import 'view/store_page.dart';
import 'view_model/game_cubit.dart';

class GameeApp extends StatelessWidget {
  const GameeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit()..loadState(),
      child: MaterialApp(
        title: 'Dodgefall',
        theme: ThemeData.dark(useMaterial3: true),
        routes: {
          '/': (_) => const HomePage(),
          '/settings': (_) => const SettingsPage(),
          '/trophy': (_) => const TrophyPage(),
          '/store': (_) => const StorePage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/game') {
            final mode = settings.arguments as GameMode;
            return MaterialPageRoute(
              builder: (_) => GamePage(mode: mode),
            );
          }
          return null;
        },
      ),
    );
  }
}
