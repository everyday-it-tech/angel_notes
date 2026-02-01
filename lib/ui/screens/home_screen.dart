import "dart:math" as math;
import "package:flutter/material.dart";
import "package:audioplayers/audioplayers.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:angel_notes/data/angel_selector.dart";
import "package:angel_notes/data/message_logic.dart";
import "package:angel_notes/data/message_history_manager.dart";
import "package:angel_notes/data/favorites_manager.dart";

import "../../theme/app_theme.dart";
import "../widgets/sparkle_particle.dart";
import "history_screen.dart";
import "help_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  late String message;
  late AngelSeason _season;
  late String _angelAsset;

  bool _isDailyNote = true;
  bool _isFavorited = false;

  final List<Widget> _particles = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _season = AngelSelector.getCurrentSeason(now);
    _angelAsset = AngelSelector.getAngelAsset(_season);
    message = MessageLogic.getInitialMessage(_season, now);

    _evaluateDailyNote();
    _updateFavoriteState();

    // IMPORTANT: do NOT await here
    MessageHistoryManager.add(
      message: message,
      season: _season,
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

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
    _fadeController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _evaluateDailyNote() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = DateTime.now().toIso8601String().substring(0, 10);
    final lastSeen = prefs.getString("angelnotes_last_daily");

    if (lastSeen == todayKey) {
      _isDailyNote = false;
    } else {
      await prefs.setString("angelnotes_last_daily", todayKey);
      _isDailyNote = true;
    }

    if (mounted) setState(() {});
  }

  Future<void> _updateFavoriteState() async {
    _isFavorited = await FavoritesManager.isFavorited(message);
    if (mounted) setState(() {});
  }

  Future<void> _playChime() async {
    try {
      await _audioPlayer.play(
        AssetSource("audio/angel_chime.wav"),
      );
    } catch (_) {}
  }

  void _spawnSparkles(Offset position) {
    for (int i = 0; i < 6; i++) {
      final key = UniqueKey();
      _particles.add(
        SparkleParticle(
          key: key,
          startPosition: position.translate(
            (math.Random().nextDouble() - 0.5) * 40,
            (math.Random().nextDouble() - 0.5) * 10,
          ),
          onDone: () {
            if (!mounted) return;
            setState(() {
              _particles.removeWhere((w) => w.key == key);
            });
          },
        ),
      );
    }
    setState(() {});
  }

  Future<void> _newMessage() async {
    final now = DateTime.now();

    final nextSeason = AngelSelector.getCurrentSeason(now);
    final nextMessage =
        MessageLogic.getNextMessage(nextSeason, now);

    await _playChime();
    _bounceController.forward(from: 0);

    setState(() {
      _season = nextSeason;
      _angelAsset = AngelSelector.getAngelAsset(nextSeason);
      message = nextMessage;
      _isDailyNote = false;
    });

    await MessageHistoryManager.add(
      message: nextMessage,
      season: nextSeason,
    );

    await _updateFavoriteState();
    _fadeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final seasonLabel = AngelSelector.seasonLabel(_season);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AngelNotes"),
        actions: [
          IconButton(
            tooltip: "History",
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: "Help",
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HelpScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _floatController,
                            builder: (context, child) {
                              final y = math.sin(
                                        _floatController.value *
                                            2 *
                                            math.pi,
                                      ) *
                                      8;
                              return Transform.translate(
                                offset: Offset(0, y),
                                child: child,
                              );
                            },
                            child: GestureDetector(
                              onTapDown: (d) =>
                                  _spawnSparkles(d.localPosition),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: Image.asset(
                                  _angelAsset,
                                  width: 220,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Image.asset(
                                      "assets/angelNotes_splash.png",
                                      width: 220,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.tile,
                                  borderRadius:
                                      BorderRadius.circular(999),
                                ),
                                child: Text(
                                  _isDailyNote
                                      ? "Today’s note"
                                      : "Extra note",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white
                                        .withOpacity(0.85),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: Icon(
                                  _isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorited
                                      ? Colors.redAccent
                                      : Colors.white
                                          .withOpacity(0.85),
                                ),
                                onPressed: () async {
                                  await FavoritesManager.toggleFavorite(
                                    message,
                                  );
                                  await _updateFavoriteState();
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.tile,
                              borderRadius:
                                  BorderRadius.circular(999),
                            ),
                            child: Text(
                              "Season: $seasonLabel",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white
                                    .withOpacity(0.85),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          ScaleTransition(
                            scale: Tween<double>(
                              begin: 1.0,
                              end: 1.04,
                            ).animate(
                              CurvedAnimation(
                                parent: _bounceController,
                                curve: Curves.easeOutBack,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppTheme.tile,
                                borderRadius:
                                    BorderRadius.circular(22),
                              ),
                              child: Text(
                                message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.accent,
                                foregroundColor:
                                    Colors.black,
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _newMessage,
                              child: const Text(
                                "Give me another 🥺",
                                style:
                                    TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
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
