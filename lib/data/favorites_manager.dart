import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";

class FavoriteEntry {
  final String id;
  final String dateIso;
  final String message;

  const FavoriteEntry({
    required this.id,
    required this.dateIso,
    required this.message,
  });

  DateTime get date => DateTime.tryParse(dateIso) ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        "id": id,
        "dateIso": dateIso,
        "message": message,
      };

  static FavoriteEntry fromJson(Map<String, dynamic> json) {
    return FavoriteEntry(
      id: (json["id"] ?? "").toString(),
      dateIso: (json["dateIso"] ?? DateTime.now().toIso8601String()).toString(),
      message: (json["message"] ?? "").toString(),
    );
  }
}

class FavoritesManager {
  static const String _key = "angelnotes_favorites_v1";

  static Future<List<FavoriteEntry>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(FavoriteEntry.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> isFavorited(String message) async {
    final items = await getFavorites();
    return items.any((e) => e.message.trim() == message.trim());
  }

  static Future<void> toggleFavorite(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getFavorites();

    final existingIndex =
        items.indexWhere((e) => e.message.trim() == message.trim());

    if (existingIndex >= 0) {
      items.removeAt(existingIndex);
    } else {
      items.insert(
        0,
        FavoriteEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          dateIso: DateTime.now().toIso8601String(),
          message: message,
        ),
      );
    }

    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
