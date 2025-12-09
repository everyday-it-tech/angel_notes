// lib/data/angel_selector.dart

/// High-level seasonal "mode" for the angel art & messages.
enum AngelSeason {
  generic,
  christmas,
  valentine,
  halloween,
}

class AngelSelector {
  /// Decide which seasonal "mode" we're in based on the current date.
  static AngelSeason getCurrentSeason(DateTime now) {
    final month = now.month;

    if (month == 12) {
      return AngelSeason.christmas;
    } else if (month == 2) {
      return AngelSeason.valentine;
    } else if (month == 10) {
      return AngelSeason.halloween;
    }

    return AngelSeason.generic;
  }

  /// Map a season to a specific asset path.
  static String getAngelAsset(AngelSeason season) {
    switch (season) {
      case AngelSeason.christmas:
        return 'lib/assets/seasonal_angels/christmas_angel.png';
      case AngelSeason.valentine:
        return 'lib/assets/seasonal_angels/valentine_angel.png';
      case AngelSeason.halloween:
        return 'lib/assets/seasonal_angels/halloween_angel.png';
      case AngelSeason.generic:
      default:
        // Use your base splash angel as the default.
        return 'lib/assets/angelNotes_splash.png';
    }
  }

  /// Backwards-compatible helper if you just want the current asset.
  static String getCurrentAngel() {
    final now = DateTime.now();
    final season = getCurrentSeason(now);
    return getAngelAsset(season);
  }
}
