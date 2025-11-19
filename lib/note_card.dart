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
// Toggles between edit mode and display mode using a button
// In display mode, the text portion of the widget is displayed as a textbutton
// When the button is clicked the state is updated to edit mode
// In edit mode, the text portion is displayed with a textfield with a save button and a cancel button
// When the save button or cancel button is pressed, the note is either saved or not, and the state is updated to display mode
/*class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard(this.note, {super.key,});
  
  // Builds a list tile to display the info saved in [Note note]
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        //leading: Icon(Icons.drag_indicator),
        leading: SelectableText("${note.id}"),
        title: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.centerLeft,
          ),
          child: Text(note.content),
          onPressed: () {},
        ),
        subtitle: SelectableText(note.title),
      ),
    );
  }

}*/

enum Mode {view, edit}

// Refactored into a ConsumerStatefulWidget
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