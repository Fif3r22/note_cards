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
              NoteCard(note: Note(id: 0, title: "Card 1", content: "Bla bla bla")),
              NoteCard(note: Note(id: 1, content: "Lorem ipsum dolor sit...")),
            ],
          ),
        ),
      ),
    );
  }
}
