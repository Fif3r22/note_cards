import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'note_card.dart';
import 'app_storage.dart';

// Perform operations on a database and expose the data to the app
class NotesNotifier extends AsyncNotifier<Map<int,Note>> {
  @override
  Future<Map<int,Note>> build() async {
    // Initial load
    return await AppStorage.getNotes();
  }

  // Load all the Notes in the database and update state
  Future<void> loadNotes() async {
    // Reloads all the notes
    state = AsyncData(await AppStorage.getNotes());
  }

  // Clear all Notes from the database and update the state
  Future<void> clearNotes() async {
    // Delete all notes in the database
    await AppStorage.clearNotes();

    // Update state to be an empty dictionary
    state = AsyncData(<int,Note>{});
  }

  // Insert or update a Note in the database and update the state
  Future<int> saveNote(Note note) async {
      // Insert the note and extract the ID
      final id = await AppStorage.insertNote(note);
      note = Note.withID(id: id, title: note.title, content: note.content);
  
      // Update the state safely
      final current = state.value ?? <int,Note>{};
      state = AsyncData({...current, id: note});

      // Return the ID
      return id;
  }

  // Delete a Note from the database and update the state
  Future<void> deleteNote(Note note) async {
    // Delete the note from the database
    await AppStorage.deleteNote(note);
    
    // Updates the state safely
    final current = state.value ?? <int,Note>{};
    current.remove(note.id); // Only remove the note if the state is not null
    state = AsyncData({...current});
  }

}

// Expose the note provider to the app
final notesProvider = AsyncNotifierProvider<NotesNotifier, Map<int,Note>>(NotesNotifier.new);