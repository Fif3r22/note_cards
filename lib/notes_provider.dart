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
    
    if (note.id == null) {
      // Insert the note and extract the ID
      final id = await NoteStorage.insertNote(note);
      note = Note.withID(id: id, title: note.title, content: note.content);
  
      // Update state safely
      final current = state.value ?? [];
      state = AsyncData([...current, note]);
  
      // Return the ID
      return id;
    } else {
      // Inserts the note
      final id = await NoteStorage.insertNote(note);

      // Reloads all the notes
      loadNotes();

      // Returns the id of the note
      return id;
    }
  }
  
  Future<void> deleteNote(Note note) async {
    // Delete the note from the database
    await NoteStorage.deleteNote(note);
    // Reload the notes
    loadNotes();
  }

  Future<void> loadNotes() async {
    // Reloads all the notes
    state = AsyncData(await NoteStorage.getNotes());
  }

}

// Expose the provider to the app
final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);