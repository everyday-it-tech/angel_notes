import "package:flutter/material.dart";
import "../../theme/app_theme.dart";


class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("From Pookie 💚"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SectionTitle("Hey my angel 💚"),
            Text(
              "AngelNotes is a quiet little place for a message when you need one.\n\n"
              "No streaks, no pressure, no falling behind. Just a gentle note, a little sparkle, and a reminder that you are loved.",
            ),

            SizedBox(height: 22),

            _SectionTitle("What AngelNotes is"),
            _Bullets([
              "A daily message that stays steady for the day.",
              "Extra messages any time you want one.",
              "Seasonal angels that change through the year.",
              "A private history of your past notes saved on your device.",
            ]),

            SizedBox(height: 22),

            _SectionTitle("What AngelNotes is not"),
            _Bullets([
              "Not a tracker, not a score, not a task list.",
              "Not a place where you can fail.",
              "Not something you have to keep up with.",
            ]),

            SizedBox(height: 22),

            _SectionTitle("Seasonal angels"),
            Text(
              "AngelNotes changes her outfit through the year.\n\n"
              "Christmas shows up in December and the first few days of January.\n"
              "Valentines shows up in early February.\n\n"
              "More seasonal angels can be added later, but the app already knows how to rotate them.",
            ),

            SizedBox(height: 22),

            _SectionTitle("History and privacy"),
            Text(
              "Your history is saved on this device only.\n\n"
              "There is no account, no login, and no cloud sync. If you clear browser data or delete the app, the saved history can be removed too.",
            ),

            SizedBox(height: 26),

            _SectionTitle("If the app looks old or not updated"),
            _Steps([
              "Close AngelNotes. Swipe up, then swipe it away.",
              "Open it again.",
            ]),

            _SectionTitle("The Safari refresh fix"),
            _Steps([
              "Open Settings.",
              "Tap Safari.",
              "Tap Advanced.",
              "Tap Website Data.",
              "Find AngelNotes or everydayit.tech.",
              "Swipe left, then tap Delete.",
              "Open AngelNotes again.",
            ]),

            _SectionTitle("If buttons do not work or it feels frozen"),
            _Steps([
              "Close AngelNotes.",
              "Turn on Airplane Mode for about 5 seconds.",
              "Turn it back off.",
              "Open AngelNotes again.",
            ]),

            _SectionTitle("If the screen is blank or white"),
            _Steps([
              "Close AngelNotes.",
              "Open Safari.",
              "Go to the AngelNotes website.",
              "Refresh once.",
              "Open AngelNotes again.",
            ]),

            SizedBox(height: 26),

            _SectionTitle("Tiny reminder"),
            Text(
              "If you are having a rough day, you do not have to earn a message here.\n"
              "You already deserve kindness. Always.",
              style: TextStyle(fontSize: 18, height: 1.35),
            ),

            SizedBox(height: 30),
            _Footer(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("•  "),
                  Expanded(
                    child: Text(
                      t,
                      style: const TextStyle(fontSize: 18, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Steps extends StatelessWidget {
  final List<String> steps;
  const _Steps(this.steps);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps
          .asMap()
          .entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "${e.key + 1}. ${e.value}",
                style: const TextStyle(fontSize: 18, height: 1.35),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.tile,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Text(
        "AngelNotes.\n"
        "Built with love, for Megan.\n"
        "If anything ever feels weird, it is not you. It is just tech being tech.\n\n"
        "You are doing better than you think 💚",
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 16,
          height: 1.35,
        ),
      ),
    );
  }
}
