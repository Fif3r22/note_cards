import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_cards/features/notes/domain/note.dart';
import 'package:note_cards/core/db/dao/notes_dao.dart';
import 'package:note_cards/core/db/app_storage.dart';
import 'package:note_cards/features/notes/data/notes_repository.dart';

// DAO Provider
final notesDaoProvider = FutureProvider<NotesDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return NotesDao(db);
});

// Repository Provider
final notesRepositoryProvider = FutureProvider<NotesRepository>((ref) async {
  final notesDao = await ref.watch(notesDaoProvider.future);
  return NotesRepository(notesDao);
});


// Notifier to expose database operations to the app
class NotesNotifier extends AsyncNotifier<Map<int,Note>> {
  @override
  Future<Map<int,Note>> build() async {
    // Initial load
    final repo = await ref.watch(notesRepositoryProvider.future);
    return await repo.getAll();
  }

  // Insert or update a Note in the database and update the state
  Future<int> saveNote(Note note) async {
      final repo = await ref.read(notesRepositoryProvider.future);

      // Insert the note and extract the ID
      final id = await repo.saveNote(note);
      final updated = Note(id: id, title: note.title, content: note.content);
  
      // Update the state safely
      final current = Map<int,Note>.from(state.value ?? {});
      current[id] = updated;
      state = AsyncData(current);

      // Return the ID
      return id;
  }

  // Delete a Note from the database and update the state
  Future<void> deleteNote(Note note) async {
    final repo = await ref.read(notesRepositoryProvider.future);

    // Delete the note from the database
    await repo.deleteNote(note);
    
    // Updates the state safely
    final current = Map<int, Note>.from(state.value ?? {});
    current.remove(note.id);
    state = AsyncData(current);
  }

  // Load all the Notes in the database into current state
  Future<void> getNotes() async {
    // Reloads all the notes
    final repo = await ref.read(notesRepositoryProvider.future);
    state = AsyncData(await repo.getAll());
  }

  // Clear all Notes from the database and update the state
  Future<void> clearNotes() async {
    // Delete all notes in the database
    final repo = await ref.read(notesRepositoryProvider.future);
    await repo.deleteAll();

    // Update state to be an empty dictionary
    state = AsyncData(<int,Note>{});
  }

}

// Expose the note provider to the app
final notesProvider = AsyncNotifierProvider<NotesNotifier, Map<int,Note>>(NotesNotifier.new);