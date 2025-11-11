import 'package:flutter/material.dart';
import 'package:note_cards/note_card.dart';
import 'package:note_cards/note_storage.dart';

void main() async {
  var storage = NoteStorage();
  await storage.initialize();
  await storage.clear();
  for (int i = 1; i <= 5; i++) {
    await storage.addNote(Note(id: i - 1, title: "#$i", content: "This is note number $i"));
  }
  var notes = await storage.getNotes();
  print(notes);

  runApp(NotesApp(notes: notes));
}

class NotesApp extends StatefulWidget {
  final List<Note> notes;

  const NotesApp({super.key, required this.notes});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  late List<Note> _notes;

  @override
  void initState() {
    super.initState();
    // copy initial notes so we can mutate the local list
    _notes = List<Note>.from(widget.notes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NotesView(notes: _notes)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
              setState(() {
                _notes.add(Note(id: _notes.length, title: 'New', content: 'New note'));
              });
              print(_notes);
              print(_notes.length);
          },
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}