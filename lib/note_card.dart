// Defines two classes: `Note` and `NoteCard`
// Note contains and handles note data such as title, source, and content
// NoteCard is a stateless widget that accepts a Note as an argument and handles display of a Note in a flutter Widget tree
import 'package:flutter/material.dart';

/*
   Note Class Implementation
*/

class Note {
  final int id;
  final String title;
  final String content;

  const Note({required this.id, this.title = "", required this.content});

  // Convert the Note into a Map for database purposes. The keys must correspond to the
  // names of the columns in the database table.
  Map<String, Object?> toMap() => {'id': id, 'title': title, 'content': content};

  // Implement toString to make info easy to see when using print()
  @override
  String toString() => 'Note{id: $id, title: $title, content: $content}';
}



/*
    NoteCard Widget Class Implementation
*/

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

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