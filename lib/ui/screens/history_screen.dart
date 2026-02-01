import "package:flutter/material.dart";
import "../../data/message_history_manager.dart";
import "../../data/angel_selector.dart";
import "../../theme/app_theme.dart";

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${dt.year}-${two(dt.month)}-${two(dt.day)}  ${two(dt.hour)}:${two(dt.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: FutureBuilder<List<MessageHistoryEntry>>(
        future: MessageHistoryManager.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No saved messages yet.\n\nYour past notes will appear here automatically.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = items[index];
              final seasonLabel =
                  AngelSelector.seasonLabel(entry.season);

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.tile,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            seasonLabel,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _formatDate(entry.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      entry.message,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
