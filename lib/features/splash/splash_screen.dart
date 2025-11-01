import 'dart:math' as math;

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

  @override
  void initState() {
    super.initState();

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

    // Pre-defined positions for welcome texts
    final welcomeTexts = [
      _WelcomeItem('Välkommen!', 0.1, 0.15, 32.0, 0.5),
      _WelcomeItem('Welcome!', 0.7, 0.1, 24.0, 0.4),
      _WelcomeItem('مرحبا!', 0.15, 0.7, 28.0, 0.45),
      _WelcomeItem('Soo dhawoow!', 0.75, 0.65, 20.0, 0.35),
      _WelcomeItem('خوش آمدید!', 0.8, 0.35, 26.0, 0.4),
      _WelcomeItem('Ласкаво просимо!', 0.1, 0.4, 22.0, 0.38),
      _WelcomeItem('Добро пожаловать!', 0.65, 0.8, 18.0, 0.35),
      _WelcomeItem('Hoş geldiniz!', 0.25, 0.85, 24.0, 0.42),
    ];

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
            ...welcomeTexts.map((item) {
              return Positioned(
                left: item.x * size.width,
                top: item.y * size.height,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: item.size,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900.withOpacity(item.opacity),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              );
            }),

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

class _WelcomeItem {
  final String text;
  final double x;
  final double y;
  final double size;
  final double opacity;

  _WelcomeItem(this.text, this.x, this.y, this.size, this.opacity);
}
