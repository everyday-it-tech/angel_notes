import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:angel_notes/data/angel_selector.dart';
import 'package:angel_notes/data/message_logic.dart';
import '../../../theme/app_theme.dart';
import '../widgets/sparkle_particle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _entranceController;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late String message;
  final List<SparkleParticle> _particles = [];

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playChime() async {
    try {
      await _audioPlayer.play(
        AssetSource("audio/angel_chime.wav"),
      );
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final season = AngelSelector.getCurrentSeason(now);
    message = MessageLogic.getInitialMessage(season, now);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _bounceController.dispose();
    _entranceController.dispose();
    _fadeController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _newMessage() {
    final now = DateTime.now();
    final season = AngelSelector.getCurrentSeason(now);

    _fadeController.reverse().then((_) {
      setState(() {
        message = MessageLogic.getNextMessage(season, now);
      });

      _fadeController.forward();
      _playChime();
    });
  }

  Future<void> _openCategories() async {
    Navigator.pushNamed(context, '/categories');
  }

  void _spawnSparkles(TapDownDetails details) {
    final pos = details.globalPosition;

    for (int i = 0; i < 6; i++) {
      _particles.add(SparkleParticle(startPosition: pos));
    }

    setState(() {});
  }

  void _cleanupParticles() {
    _particles.removeWhere((p) => p.shouldRemove);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final season = AngelSelector.getCurrentSeason(now);
    final angelImage = AngelSelector.getAngelAsset(season);

    final screenHeight = MediaQuery.of(context).size.height;

    _cleanupParticles();

    return Scaffold(
      appBar: AppBar(title: const Text("Angel Notes")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accent,
        onPressed: _openCategories,
        child: const Icon(Icons.category, color: Colors.black),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: _spawnSparkles,
                    onTap: () => _bounceController.forward(from: 0),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        _floatController,
                        _bounceController,
                        _entranceController,
                      ]),
                      builder: (context, child) {
                        final floatOffset =
                            math.sin(_floatController.value * 2 * math.pi) * 10;

                        final glowOpacity =
                            (math.sin(_floatController.value * 2 * math.pi) + 1) / 2;

                        final entranceValue = CurvedAnimation(
                          parent: _entranceController,
                          curve: Curves.easeOut,
                        ).value;

                        final entranceOffset = (1 - entranceValue) * 40;

                        return Opacity(
                          opacity: entranceValue,
                          child: Transform.translate(
                            offset: Offset(0, floatOffset + entranceOffset),
                            child: Transform.scale(
                              scale: 1 + (_bounceController.value * 0.12),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amberAccent
                                          .withOpacity(glowOpacity * 0.5),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: SizedBox(
                                  height: screenHeight * 0.22,
                                  child: Image.asset(
                                    angelImage,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ⭐ SLIDE + FADE MESSAGE TRANSITION ⭐
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _newMessage,
                    child: const Text(
                      "Give me another 🥺",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),

          ..._particles,
        ],
      ),
    );
  }
}
