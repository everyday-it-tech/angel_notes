import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'messages.dart';

class DailyMessageManager {
  static const _keyMessage = 'daily_message';
  static const _keyDate = 'daily_message_date';

  /// Returns the same message all day, regenerates when a new day begins.
  static Future<String> getDailyMessage() async {
    final prefs = await SharedPreferences.getInstance();

    // Handle date in a safe, Web-friendly format (YYYY-MM-DD)
    final today = DateTime.now();
    final todayKey = "${today.year}-${today.month}-${today.day}";

    final savedDate = prefs.getString(_keyDate);
    final savedMessage = prefs.getString(_keyMessage);

    // If we have a saved message for today → return it
    if (savedDate == todayKey && savedMessage != null) {
      return savedMessage;
    }

    // Safety check: if no messages exist
    if (messages.isEmpty) {
      return "Angel couldn't find a message today… but she wants you to know you're loved.";
    }

    // Select a new random message
    final random = Random();
    final newMessage = messages[random.nextInt(messages.length)];

    // Save for today
    prefs.setString(_keyMessage, newMessage);
    prefs.setString(_keyDate, todayKey);

    return newMessage;
  }
}
