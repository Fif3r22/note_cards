// Defines a class NoteStorage that uses a SQLite database
// to handle Note storage, updates, and retrieval

// Async operations and platform detection
import 'dart:async';
import 'dart:io';

// File path management
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// Basic sqflite for SQLite databases on mobile and macOS
import 'package:sqflite/sqflite.dart';

// Sqflite_common_ffi for SQLite databases on desktop
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// App classes
import 'note_card.dart';


// NoteStorage Class handles Note storage, update, and retrieval
class AppStorage {
  static Database? _db;

  // Getter to streamline first-time initialization
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('notes.db');
    return _db!;
  }

  // Initialize the database for the first time
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
  
  // Get all notes in the database as a dictionary of id: Note pairs
  static Future<Map<int,Note>> getNotes() async {
    final db = await database;
    final maps = await db.query('notes');

    // Return a dictionary of all the notes with their id as the key
    Iterable notes = maps.map((map) => Note.fromMap(map));
    return <int,Note>{for (var note in notes) note.id: note};
  }

  // Clear all notes
  static Future<void> clearNotes() async {
    final db = await database;
    db.delete('notes');
  }

  // Insert a Note into the database and replace any conflicts
  static Future<int> insertNote(Note note) async {
    // Load the database
    final db = await database;

    // Insert the note into the database
    return db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a specific Note from the database
  static Future<void> deleteNote(Note note) async {
    final db = await database;

    db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

}