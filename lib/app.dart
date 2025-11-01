import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hjalpguiden/features/guides/guide_view.dart';
import 'package:hjalpguiden/features/home/home_screen.dart';
import 'package:hjalpguiden/features/language/select_language_screen.dart';
import 'package:hjalpguiden/features/splash/splash_screen.dart';

class HjalpguidenApp extends StatefulWidget {
  const HjalpguidenApp({super.key});

  @override
  State<HjalpguidenApp> createState() => _HjalpguidenAppState();
}

class _HjalpguidenAppState extends State<HjalpguidenApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const SelectLanguageScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/guide/:id',
        builder: (context, state) {
          final guideId = state.pathParameters['id']!;
          return GuideView(guideId: guideId);
        },
      ),
    ],
  );

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
}
