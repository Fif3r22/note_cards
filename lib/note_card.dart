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
  
  // For when Note is inserted into a database and assigned an ID
  factory Note.withID({required int id, required String title, required String content}) {
    return Note(id: id, title: title, content: content);
  }

  // Make a factory constructor to convert a Note from a Map<String, Object?>
  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as int?, 
      title: map['title'] as String, 
      content: map['content'] as String,
    );
  }
}


// NoteCard Class

enum Mode {view, edit}
class NoteCard extends ConsumerStatefulWidget {
  final Note note;

  const NoteCard(this.note, {super.key,});

  @override
  ConsumerState<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends ConsumerState<NoteCard> {
  Mode mode = Mode.view;

  @override
  Widget build(BuildContext context) {
    // Build based on the current mode
    if (mode == Mode.view) {
      return viewMode(context); // If it's in view mode
    } else {
      return editMode(context); // If it's in edit mode
    }
  }

  Widget viewMode(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text("${widget.note.id}"),
        title: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.centerLeft,
          ),
          child: Text(widget.note.content),
          onPressed: () {
            setState(() => mode = Mode.edit);
          },
        ),
        subtitle: Text(widget.note.title),
      ),
    );
  }

  Widget editMode(BuildContext context) {
    TextEditingController controller = TextEditingController(text: widget.note.content);

    return Card(
      child: ListTile(
        leading: SelectableText("${widget.note.id}"),
        title: TextField(controller: controller),
        subtitle: Row(
          children: [
            Text(widget.note.title),
            IconButton(
              icon: Icon(Icons.check_circle_outline_sharp),
              onPressed: () {
                // Save the note
                ref.read(notesProvider.notifier).saveNote(Note(id: widget.note.id, title: widget.note.title, content: controller.text));
                // Change the NoteCard into view mode
                setState(() => mode = Mode.view);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete the note
                ref.read(notesProvider.notifier).deleteNote(widget.note);
                // Call setState to update the widget
                setState(() => mode = Mode.view);
              },
            ),
          ]
        ),
      ),
    );
  }
}


// NotesView Class

class NotesView extends ConsumerWidget {
    
  const NotesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesMap = ref.watch(notesProvider).value;

    if (notesMap == null || notesMap.isEmpty) {
      return ListView(children: []);
    } else {
      // Gets the keys as a list so that the builder can iterate over them
      final keys = notesMap.keys.toList();
      // Build the list of notes for the view
      return ListView.builder(
          itemCount: notesMap.length,
          itemBuilder: (context, index) {
            final key = keys[index];
            return NoteCard(notesMap[key] ?? Note());
          }
      );
    }
  }
}