import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'note_card.dart';
import 'note_storage.dart';

// Uses the static class NoteStorage to perform operations on a database and expose the data to the app
class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    // Initial load
    return await NoteStorage.getNotes();
  }

  Future<void> clearNotes() async {
    await NoteStorage.clearNotes();

    // Update state
    state = AsyncData([]);
  }

  Future<int> insertNote(Note note) async {
    // Insert the note and extract the ID
    final id = await NoteStorage.insertNote(note);
    note = Note.withID(id: id, title: note.title, content: note.content);

    // Update state safely
    final current = state.value ?? [];
    state = AsyncData([...current, note]);

    // Return the ID
    return id;
  }

}

// Expose the provider to the app
final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);