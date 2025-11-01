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

  // Hardcoded positions - no dart:math needed!
  static const List<_WelcomeItem> _welcomeItems = [
    _WelcomeItem('Välkommen!', 0.1, 0.15, 32.0, 0.5),
    _WelcomeItem('Welcome!', 0.7, 0.1, 24.0, 0.4),
    _WelcomeItem('مرحبا!', 0.15, 0.7, 28.0, 0.45),
    _WelcomeItem('Soo dhawoow!', 0.8, 0.65, 20.0, 0.35),
    _WelcomeItem('خوش آمدید!', 0.05, 0.4, 26.0, 0.4),
    _WelcomeItem('Ласкаво просимо!', 0.75, 0.35, 22.0, 0.38),
    _WelcomeItem('Добро пожаловать!', 0.1, 0.85, 18.0, 0.3),
    _WelcomeItem('Hoş geldiniz!', 0.85, 0.8, 24.0, 0.42),
  ];

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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
              Colors.purple[50]!,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background welcome texts
            ..._welcomeItems.map((item) {
              return Positioned(
                left: item.left * size.width,
                top: item.top * size.height,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: item.fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900]!.withOpacity(item.opacity),
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
                                color: Colors.blue[200]!.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 60,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Instruction text
                      Text(
                        'Tryck för att börja',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[800],
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
                      color: Colors.blue[900],
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
                      color: Colors.blue[700]!.withOpacity(0.6),
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
  final double left;
  final double top;
  final double fontSize;
  final double opacity;

  const _WelcomeItem(
    this.text,
    this.left,
    this.top,
    this.fontSize,
    this.opacity,
  );
}
