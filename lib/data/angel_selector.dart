// lib/data/angel_selector.dart

/// High-level seasonal "mode" for the angel art.
enum AngelSeason {
  generic,
  christmas,
  valentines,
  halloween,
}

class AngelSelector {
  /// Decide which seasonal mode we are in based on the current date.
  ///
  /// Windows are intentionally generous so the app feels alive and intentional.
  static AngelSeason getCurrentSeason(DateTime now) {
    final m = now.month;
    final d = now.day;

    // Christmas: Dec 1 through Jan 5
    if (m == 12) return AngelSeason.christmas;
    if (m == 1 && d <= 5) return AngelSeason.christmas;

    // Valentines: Feb 1 through Feb 14
    if (m == 2 && d <= 14) return AngelSeason.valentines;

    // Halloween: Oct 1 through Oct 31
    if (m == 10) return AngelSeason.halloween;

    return AngelSeason.generic;
  }

  static String seasonLabel(AngelSeason season) {
    switch (season) {
      case AngelSeason.christmas:
        return "Christmas";
      case AngelSeason.valentines:
        return "Valentines";
      case AngelSeason.halloween:
        return "Halloween";
      case AngelSeason.generic:
      default:
        return "Everyday";
    }
  }

  /// Map a season to an asset path.
  static String getAngelAsset(AngelSeason season) {
    switch (season) {
      case AngelSeason.christmas:
        return "assets/seasonal_angels/christmas_angel.png";
      case AngelSeason.valentines:
        // If your file is still named "Valentines_angel.png" then change this line.
        return "assets/seasonal_angels/valentines_angel.png";
      case AngelSeason.halloween:
        // Optional future asset. If missing, we fall back to generic below in UI.
        return "assets/seasonal_angels/halloween_angel.png";
      case AngelSeason.generic:
      default:
        return "assets/angelNotes_splash.png";
    }
  }

  static String getCurrentAngel() {
    final now = DateTime.now();
    final season = getCurrentSeason(now);
    return getAngelAsset(season);
  }
}
