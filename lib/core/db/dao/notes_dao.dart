import 'package:note_cards/features/notes/domain/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_cards/core/db/base_dao.dart';

// Database Access Object (DAO) for notes

class NotesDao extends BaseDao<Note> {
  NotesDao(Database db) : super(db: db, tableName: 'notes');

  @override
  Note fromMap(Map<String, Object?> map) => Note.fromMap(map);
}