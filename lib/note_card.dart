// Defines the [Note], [NoteCard], and [NotesView] classes
// [Note] contains and handles data such as title, source, and content
// [NoteCard] is a widget to display a single [Note]
// [NotesView] is a widget to display a list of [Note]s

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notes_provider.dart';

// Note Class

class Note {
  final int? id;
  final String title;
  final String content;

  const Note({this.id, this.title = '', this.content = ''});

  // Convert the Note into a Map for database purposes. The keys must correspond to the
  // names of the columns in the database table.
  Map<String, Object?> toMap() => {'id': id, 'title': title, 'content': content};

  // Implement toString to make info easy to see when using print()
  @override
  String toString() => 'Note{id: $id, title: $title, content: $content}';

  // Make a factory constructor to convert a Note from a Map<String, Object?>
  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as int?, 
      title: map['title'] as String, 
      content: map['content'] as String,
    );
  }
}


//  NoteCard Class

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard(this.note, {super.key,});
  
  // Builds a list tile to display the info saved in [Note note]
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.drag_indicator),
        title: Text(note.title),
        subtitle: Text(note.content),
      ),
    );
  }
}


// NotesView Class

class NotesView extends ConsumerWidget {
    
  const NotesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesList = ref.watch(notesProvider).value;
    
    if (notesList == null || notesList.isEmpty) {
      return ListView(children: []);
    } else {
      return ListView.builder(
          itemCount: notesList.length,
          prototypeItem: NoteCard(notesList.first),
          itemBuilder: (context, index) => NoteCard(notesList[index]),
      );
    }
  }
}

/*
class NotesView extends StatefulWidget {
  final List<Note> notes;

  const NotesView({super.key, required this.notes});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late List<Note> _notes;
  
  @override
  void initState() {
    super.initState();
    // Copy initial notes so we can mutate the list
    _notes = List<Note>.from(widget.notes);
  }
  
  void addNote(Note note) {
    setState(() {
      _notes.add(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: _notes.length,
            prototypeItem: NoteCard(note: _notes.first),
            itemBuilder: (context, index) => NoteCard(note: _notes[index]),
          );
  }
}*/