import 'package:shared_preferences/shared_preferences.dart';
import 'messages.dart'; // your message list file
import 'dart:math';

class DailyMessageManager {
  static const _keyMessage = 'daily_message';
  static const _keyDate = 'daily_message_date';

  static Future<String> getDailyMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final savedDate = prefs.getString(_keyDate);
    final savedMessage = prefs.getString(_keyMessage);

    // If message exists and date matches → use it
    if (savedDate == today && savedMessage != null) {
      return savedMessage;
    }

    // Otherwise create a new message
    final randomMessage =
        messages[Random().nextInt(messages.length)];

    // Save it
    prefs.setString(_keyMessage, randomMessage);
    prefs.setString(_keyDate, today);

    return randomMessage;
  }
}
