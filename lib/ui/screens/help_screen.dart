import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('From Pookie 💚'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            _SectionTitle('Hey my angel 💚'),
            Text(
              'If something ever looks weird, stuck, or not updated — it’s not you.\n'
              'It’s just Safari being… Safari.\n\n'
              'I already thought through this so you don’t have to. '
              'Just follow these steps — slow, easy, no stress.',
            ),

            SizedBox(height: 24),

            _SectionTitle('If the app looks old or not updated'),
            _Steps([
              'Close AngelNotes (swipe up → swipe it away)',
              'Open it again',
            ]),

            _SectionTitle('The “Safari, behave yourself” fix'),
            _Steps([
              'Open Settings',
              'Tap Safari',
              'Tap Advanced',
              'Tap Website Data',
              'Find AngelNotes / everydayit.tech',
              'Swipe left → Delete',
              'Open AngelNotes again',
            ]),

            _SectionTitle('If buttons don’t work or it feels frozen'),
            _Steps([
              'Close AngelNotes',
              'Turn on Airplane Mode for about 5 seconds',
              'Turn it back off',
              'Open AngelNotes again',
            ]),

            _SectionTitle('If the screen is blank or white'),
            _Steps([
              'Close AngelNotes',
              'Open Safari',
              'Go to the AngelNotes website',
              'Refresh once',
              'Open AngelNotes again',
            ]),

            _SectionTitle('Reset everything (only if needed)'),
            _Steps([
              'Press and hold the AngelNotes icon',
              'Tap Remove App',
              'Open Safari → AngelNotes website',
              'Tap Share → Add to Home Screen',
            ]),

            SizedBox(height: 16),

            Text(
              'If you’re ever unsure, just text me:\n\n'
              '“Pookie, AngelNotes is being weird.”\n\n'
              'That’s all I need 💚',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),

            SizedBox(height: 24),

            Center(
              child: Text(
                'AngelNotes v0.1.1 • Dec 25, 2025',
                style: TextStyle(color: Colors.grey),
              ),
            ),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  final List<String> steps;
  const _Steps(this.steps);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: steps
            .map(
              (step) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $step'),
              ),
            )
            .toList(),
      ),
    );
  }
}
