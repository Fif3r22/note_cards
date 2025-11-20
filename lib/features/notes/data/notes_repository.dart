import 'package:note_cards/core/db/dao/notes_dao.dart';
import 'package:note_cards/features/notes/domain/note.dart';

// Repository to allow notes feature to access the app's database

class NotesRepository {
  final NotesDao dao;

  NotesRepository(this.dao);

  Future<int> saveNote(Note note) => dao.insert(note); // The insert method provides both insert and update functions

  Future<int> deleteNote(Note note) => dao.delete(where: "id = ?", whereArgs: [note.id]);
  
  Future<int> deleteAll() => dao.delete();

  Future<Map<int, Note>> getAll() => dao.getAll();
}