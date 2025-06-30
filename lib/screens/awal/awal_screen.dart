import 'dart:async';
import 'package:flutter/material.dart';

class AwalScreen extends StatefulWidget {
  const AwalScreen({super.key});

  @override
  State<AwalScreen> createState() => _AwalScreenState();
}

class _AwalScreenState extends State<AwalScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Create animations
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    Timer(const Duration(milliseconds: 600), () {
      _textController.forward();
    });
    Timer(const Duration(milliseconds: 1000), () {
      _progressController.forward();
    });

    // Navigasi otomatis ke halaman login setelah 5 detik
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFFE6E3CB),
              Color(0xFFCDC99A),
              Color(0xFF5B5835),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF5B5835).withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFCDC99A).withOpacity(0.15),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo container with shadow
                  AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5B5835).withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo_lokalmart.png',
                            width: 280,
                            height: 280,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Animated text with enhanced styling
                  AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - _textAnimation.value)),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF424021),
                                    Color(0xFF9E9A47)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                blendMode: BlendMode.srcIn,
                                child: const Text(
                                  'LokalMart',
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Inter',
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your Local Marketplace',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color:
                                      const Color(0xFF5B5835).withOpacity(0.8),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // Progress indicator
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Column(
                        children: [
                          Container(
                            width: 240,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: const Color(0xFFCDC99A).withOpacity(0.3),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: 240 * _progressAnimation.value,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5B5835),
                                        Color(0xFFCDC99A)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading your experience...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Inter',
                              color: const Color(0xFF5B5835).withOpacity(0.7),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Loading dots animation
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF5B5835).withOpacity(
                            _progressAnimation.value > (index * 0.33)
                                ? 0.8
                                : 0.3,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
