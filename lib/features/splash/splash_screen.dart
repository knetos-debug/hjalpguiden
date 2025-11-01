import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const List<WelcomeText> _welcomeTexts = [
    WelcomeText('Välkommen!', 'sv'),
    WelcomeText('Welcome!', 'en'),
    WelcomeText('مرحبا!', 'ar'),
    WelcomeText('Soo dhawoow!', 'so'),
    WelcomeText('እንቋዕ ብደሓን መፃእኩም!', 'ti'),
    WelcomeText('خوش آمدید!', 'fa'),
    WelcomeText('خوش آمدید!', 'prs'),
    WelcomeText('Ласкаво просимо!', 'uk'),
    WelcomeText('Добро пожаловать!', 'ru'),
    WelcomeText('Hoş geldiniz!', 'tr'),
  ];

  // Pre-generated random positions for consistent layout
  late final List<WelcomePosition> _positions;

  @override
  void initState() {
    super.initState();

    // Generate random positions
    final random = Random(42); // Fixed seed for consistency
    _positions = _welcomeTexts.map((text) {
      return WelcomePosition(
        text: text,
        left: random.nextDouble(),
        top: random.nextDouble(),
        fontSize: 12 + random.nextDouble() * 36, // 12-48px
        opacity: 0.2 + random.nextDouble() * 0.5, // 0.2-0.7
        rotation: (random.nextDouble() - 0.5) * 0.3, // -0.15 to 0.15 radians
      );
    }).toList();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Random welcome texts in background
            ...(_positions.map((pos) {
              final left = pos.left * size.width * 0.9;
              final top = pos.top * size.height * 0.9;

              // Avoid center area (for the icon)
              final centerX = size.width / 2;
              final centerY = size.height / 2;
              final distanceFromCenter = sqrt(
                pow(left - centerX, 2) + pow(top - centerY, 2),
              );

              // Skip if too close to center
              if (distanceFromCenter < 150) {
                return const SizedBox.shrink();
              }

              return Positioned(
                left: left,
                top: top,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.rotate(
                    angle: pos.rotation,
                    child: Text(
                      pos.text.text,
                      style: TextStyle(
                        fontSize: pos.fontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900.withOpacity(pos.opacity),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              );
            })),

            // Center content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main tap area with icon
                      GestureDetector(
                        onTap: _onTap,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 60,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Subtle instruction text
                      Text(
                        'Tryck för att börja',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Branding at top
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Text(
                    'Hjälpguiden',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),

            // Branding at bottom
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Text(
                    'Hjälpguiden',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700.withOpacity(0.6),
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeText {
  final String text;
  final String langCode;

  const WelcomeText(this.text, this.langCode);
}

class WelcomePosition {
  final WelcomeText text;
  final double left;
  final double top;
  final double fontSize;
  final double opacity;
  final double rotation;

  WelcomePosition({
    required this.text,
    required this.left,
    required this.top,
    required this.fontSize,
    required this.opacity,
    required this.rotation,
  });
}
