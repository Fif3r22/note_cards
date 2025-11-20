import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_cards/features/notes/application/notes_provider.dart';
import 'package:note_cards/features/notes/domain/note.dart';

// NoteCard Class displays a Note as a Material widget

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
