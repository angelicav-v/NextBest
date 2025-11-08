import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'login_screen.dart';
import '../widgets/gradient_background.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // setup animation controller (controls timing)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // scale animation (makes logo grow)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // fade animation (makes logo appear)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // start animation after screen builds
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    // go to login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // logo with purple glow
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D0D0D),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFFA855F7).withValues(alpha: 0.75),
                              blurRadius: 80,
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD946EF),
                                width: 0.75,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/nextbest_logo.png',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // app name with gradient
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFC27AFF),
                            Color(0xFFED6AFF),
                            Color(0xFFC27AFF),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ).createShader(bounds),
                        child: const Text(
                          'NextBest',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // tagline
                      Text(
                        'Your Next Best Experience',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: const Color(0xFFDAB2FF).withValues(alpha: 0.7),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}