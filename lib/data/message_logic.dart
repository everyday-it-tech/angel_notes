// lib/data/message_logic.dart

import 'dart:math';
import 'angel_selector.dart';

enum AngelMood {
  comfort,
  motivate,
  celebrate,
  romantic,
  spooky,
  gentle,
}

enum TimeBand {
  any,
  morning,
  afternoon,
  evening,
  night,
}

class MessageEntry {
  final String text;
  final Set<AngelSeason> seasons;
  final Set<TimeBand> timeBands;
  final AngelMood mood;

  const MessageEntry({
    required this.text,
    required this.mood,
    this.seasons = const {AngelSeason.generic},
    this.timeBands = const {TimeBand.any},
  });

  bool matches(AngelSeason season, TimeBand band) {
    final seasonOk =
        seasons.contains(season) || seasons.contains(AngelSeason.generic);
    final timeOk =
        timeBands.contains(TimeBand.any) || timeBands.contains(band);
    return seasonOk && timeOk;
  }
}

class MessageLogic {
  static final _rand = Random();
  static int? _lastIndex;

  // Core message library: generic + seasonal.
  static const List<MessageEntry> _messages = [
    // ---------- Generic comfort ----------
    MessageEntry(
      text: "You don’t have to have it all figured out today. One tiny step is enough 💛",
      mood: AngelMood.comfort,
    ),
    MessageEntry(
      text: "You’ve survived 100% of your hardest days so far. Your record is flawless 🌟",
      mood: AngelMood.comfort,
    ),
    MessageEntry(
      text: "You are not behind. You’re on a path only you can walk, at a pace only you can set 💚",
      mood: AngelMood.comfort,
    ),
    MessageEntry(
      text: "Your effort counts, even when nobody sees it. I see you 👀💛",
      mood: AngelMood.gentle,
    ),

    // ---------- Motivation / energy ----------
    MessageEntry(
      text: "Future you is quietly cheering for you right now. You’re building their life 🔧✨",
      mood: AngelMood.motivate,
      timeBands: {TimeBand.morning, TimeBand.afternoon, TimeBand.any},
    ),
    MessageEntry(
      text: "You don’t need perfect energy, just 10 seconds of bravery at a time ⚡",
      mood: AngelMood.motivate,
    ),
    MessageEntry(
      text: "Remember: resting on purpose still counts as progress. You’re charging your stats 🕹️",
      mood: AngelMood.motivate,
      timeBands: {TimeBand.evening, TimeBand.night, TimeBand.any},
    ),

    // ---------- Gentle night messages ----------
    MessageEntry(
      text: "It’s okay to be done for today. Let the world spin without you for a bit 🌙",
      mood: AngelMood.gentle,
      timeBands: {TimeBand.evening, TimeBand.night},
    ),
    MessageEntry(
      text: "You made it through today. That alone is something to be proud of 💫",
      mood: AngelMood.comfort,
      timeBands: {TimeBand.evening, TimeBand.night},
    ),

    // ---------- Christmas ----------
    MessageEntry(
      text: "You are allowed to be the soft one this season. Not every day has to be strong day 🎄💛",
      mood: AngelMood.comfort,
      seasons: {AngelSeason.christmas},
    ),
    MessageEntry(
      text: "If all you bring to this season is your presence, it’s already enough. You’re the gift 🎁",
      mood: AngelMood.celebrate,
      seasons: {AngelSeason.christmas},
    ),
    MessageEntry(
      text: "Some years are about surviving, not decorating. You’re still worthy of cozy moments 🎄☕",
      mood: AngelMood.comfort,
      seasons: {AngelSeason.christmas},
      timeBands: {TimeBand.evening, TimeBand.night, TimeBand.any},
    ),

    // ---------- valentines / romantic (for Megan vibes) ----------
    MessageEntry(
      text: "Reminder: you are deeply, ridiculously loved. No performance required 💘",
      mood: AngelMood.romantic,
      seasons: {AngelSeason.valentines},
    ),
    MessageEntry(
      text: "Your brain, your heart, your weird little quirks — all of it is ridiculously lovable 💌",
      mood: AngelMood.romantic,
      seasons: {AngelSeason.valentines, AngelSeason.generic},
    ),
    MessageEntry(
      text: "Somebody out there is genuinely grateful that you exist. (Spoiler: it’s more than one person) 💕",
      mood: AngelMood.romantic,
      seasons: {AngelSeason.valentines, AngelSeason.generic},
    ),

    // ---------- Halloween (spooky but soft) ----------
    MessageEntry(
      text: "Even your fears are just stories your brain is telling in the dark. You’re still the main character 🎃💛",
      mood: AngelMood.spooky,
      seasons: {AngelSeason.halloween},
    ),
    MessageEntry(
      text: "You’ve already defeated scarier bosses than today’s worries. Consider this a tutorial level 👻🕹️",
      mood: AngelMood.spooky,
      seasons: {AngelSeason.halloween},
    ),
    MessageEntry(
      text: "You are not haunted by your past. You’re escorted by your growth 🕯️",
      mood: AngelMood.spooky,
      seasons: {AngelSeason.halloween, AngelSeason.generic},
    ),

    // ---------- Little wins / celebrate ----------
    MessageEntry(
      text: "Existing is already effort. Everything else you did today is extra credit 🌈",
      mood: AngelMood.celebrate,
    ),
    MessageEntry(
      text: "Tiny invisible victories still count. You don’t need an audience for your progress 🪽",
      mood: AngelMood.celebrate,
    ),
  ];

  static TimeBand _bandFor(DateTime now) {
    final h = now.hour;
    if (h < 5) return TimeBand.night;
    if (h < 12) return TimeBand.morning;
    if (h < 17) return TimeBand.afternoon;
    if (h < 21) return TimeBand.evening;
    return TimeBand.night;
  }

  static String getInitialMessage(AngelSeason season, DateTime now) {
    return _pickMessage(season, now);
  }

  static String getNextMessage(AngelSeason season, DateTime now) {
    return _pickMessage(season, now);
  }

  static String _pickMessage(AngelSeason season, DateTime now) {
    final band = _bandFor(now);

    final candidates = _messages
        .asMap()
        .entries
        .where((e) => e.value.matches(season, band))
        .toList();

    // If filtering got too narrow, fall back to all messages.
    final pool = candidates.isNotEmpty
        ? candidates
        : _messages.asMap().entries.toList();

    if (pool.isEmpty) {
      return "Hi Angel… just wanted to remind you you're doing better than you think 💛";
    }

    int idx;
    if (pool.length == 1) {
      idx = pool.first.key;
    } else {
      do {
        idx = pool[_rand.nextInt(pool.length)].key;
      } while (_lastIndex != null && idx == _lastIndex);
    }

    _lastIndex = idx;
    return _messages[idx].text;
  }
}
