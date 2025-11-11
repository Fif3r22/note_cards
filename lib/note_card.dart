// Defines the [Note], [NoteCard], and [NotesView] classes
// [Note] contains and handles data such as title, source, and content
// [NoteCard] is a widget to display a single [Note]
// [NotesView] is a widget to display a list of [Note]s

import 'package:flutter/material.dart';


// Note Class

class Note {
  final int id;
  final String title;
  final String content;

  const Note({this.id = 0, this.title = "", this.content = ""});

  // Convert the Note into a Map for database purposes. The keys must correspond to the
  // names of the columns in the database table.
  Map<String, Object?> toMap() => {'id': id, 'title': title, 'content': content};

  // Implement toString to make info easy to see when using print()
  @override
  String toString() => 'Note{id: $id, title: $title, content: $content}';
}


//  NoteCard Class

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});
  
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

class NotesView extends StatelessWidget {
  final List<Note> notes;
  
  const NotesView({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: notes.length,
            prototypeItem: NoteCard(note: notes.first),
            itemBuilder: (context, index) => NoteCard(note: notes[index]),
          );
  }
}