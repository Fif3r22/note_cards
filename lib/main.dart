import 'package:flutter/material.dart';
import 'package:note_cards/note_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              NoteCard(icon: Icons.drag_indicator, title: "Card 1", content: "Bla bla bla"),
              NoteCard(content: "Lorem ipsum dolor sit...")
            ],
          ),
        ),
      ),
    );
  }
}
