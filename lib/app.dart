// app.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/language/select_language_screen.dart';
import 'features/home/home_screen.dart';
import 'features/guides/guide_view.dart';

class HjalpguidenApp extends StatelessWidget {
  const HjalpguidenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hjälpguiden',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, height: 1.5),
          bodyMedium: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }

  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SelectLanguageScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/guide/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GuideView(guideId: id);
        },
      ),
    ],
  );
}