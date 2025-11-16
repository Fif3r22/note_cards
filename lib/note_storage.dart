// Defines a class NoteStorage that uses a SQLite database
// to handle Note storage, updates, and retrieval

// Async operations and platform detection
import 'dart:async';
import 'dart:io';
// File path management
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// Basic sqflite for mobile and macOS, sqflite_common_ffi for desktop
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// App classes
import 'note_card.dart';

// NoteStorage Class

class NoteStorage {
  static Database? _db;
  
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('notes.db');
    return _db!;
  }

  static Future<Database> _initDB(String filePath) async {
    // Setup sqflite for cross-paltform use
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      // For mobile and macOS, the databaseFactory is set by default
    } else {
      // Desktop (Windows, Linux) use sqflite_common_ffi and need the databaseFactory set manually
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Set the path to the database. If the platform is Android, using [getDatabasesPath()] is appropriate,
    // otherwise use [getApplicationDocumentsDirectory()]
    final String databasePath = Platform.isAndroid ? await getDatabasesPath() : (await getApplicationDocumentsDirectory()).path;
    final String path = join(databasePath, filePath);

    // Return a reference to a database
    return await openDatabase(
      path, // Specify the path
      version: 1, // Set the version. This executes the onCreate function
      onCreate: (db, version) async { // Create a table to store notes 
        await db.execute('''
          CREATE TABLE notes(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                content TEXT
          )''');
      },
    );
  }
  
  // Clear all notes
  static Future<void> clearNotes() async {
    final db = await database;
    db.delete('notes');
  }

  // Insert a Note into the database and replace any duplicate notes already in the database
  static Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert(
      'notes', // Table to use
      note.toMap(), // Converts the Note to a Map<String, Object?>
      conflictAlgorithm: ConflictAlgorithm.replace, // Specifies the algorithm to resolve duplicate entries
    );
  }
  
  // Get all notes in the database
  static Future<List<Note>> getNotes() async {
    final db = await database;
    final maps = await db.query('notes');

    // Return a list of all the notes
    return maps.map((map) => Note.fromMap(map)).toList();
  }
  
  // Delete a specific note from the database
  static Future<void> deleteNote(Note note) async {
    final db = await database;

    db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

}