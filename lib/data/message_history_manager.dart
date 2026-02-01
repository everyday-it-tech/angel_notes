// lib/data/message_history_manager.dart

import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import "angel_selector.dart";

class MessageHistoryEntry {
  final String id;
  final String dateIso;
  final String message;
  final AngelSeason season;

  const MessageHistoryEntry({
    required this.id,
    required this.dateIso,
    required this.message,
    required this.season,
  });

  DateTime get date => DateTime.tryParse(dateIso) ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        "id": id,
        "dateIso": dateIso,
        "message": message,
        "season": season.name,
      };

  static MessageHistoryEntry fromJson(Map<String, dynamic> json) {
    final seasonName = (json["season"] ?? "generic").toString();
    final season = AngelSeason.values.firstWhere(
      (s) => s.name == seasonName,
      orElse: () => AngelSeason.generic,
    );

    return MessageHistoryEntry(
      id: (json["id"] ?? "").toString(),
      dateIso: (json["dateIso"] ?? DateTime.now().toIso8601String()).toString(),
      message: (json["message"] ?? "").toString(),
      season: season,
    );
  }
}

class MessageHistoryManager {
  static const String _key = "angelnotes_message_history_v2";
  static const int _maxItems = 120;

  static Future<List<MessageHistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      final items = decoded
          .whereType<Map<String, dynamic>>()
          .map(MessageHistoryEntry.fromJson)
          .toList();

      items.sort((a, b) => b.date.compareTo(a.date));
      return items;
    } catch (_) {
      return [];
    }
  }

  static Future<void> add({
    required String message,
    required AngelSeason season,
    DateTime? timestamp,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final now = timestamp ?? DateTime.now();

    final existing = await getHistory();

    // Avoid storing exact duplicates back to back.
    if (existing.isNotEmpty && existing.first.message.trim() == message.trim()) {
      return;
    }

    final entry = MessageHistoryEntry(
      id: "${now.microsecondsSinceEpoch}",
      dateIso: now.toIso8601String(),
      message: message,
      season: season,
    );

    final next = [entry, ...existing];
    final trimmed = next.take(_maxItems).toList();

    final encoded = jsonEncode(trimmed.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
