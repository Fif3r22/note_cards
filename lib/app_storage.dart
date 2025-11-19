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
  static const List<DatabaseTable> _tables = [
    DatabaseTable(
      tableName: 'notes',
      columns: {
        'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
        'title': 'TEXT',
        'content': 'TEXT',
      }
    ),
    DatabaseTable(
      tableName: 'sources',
      columns: {
        'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
        'author': 'TEXT',
        'date': 'TEXT',
        'title': 'TEXT',
        'source': 'TEXT',
      }
    ),
  ];

  // References the existing database or creates and references a new one if none exists
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('notes.db');
    return _db!;
  }

  // Initializes the database for the first time
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

    // Return a reference to the database
    return await openDatabase(
      path,
      version: 1, // Set the version. This executes the onCreate function
      onCreate: (db, version) async { // Create a new table for each item in _tables
        for (var table in _tables) {
          await db.execute(table.createQuery());
        }
      },
    );
  }
  
  // Returns all notes in the database as a dictionary of id: Note pairs
  static Future<Map<int,Note>> getNotes() async {
    final db = await database;
    final maps = await db.query('notes');

    // Return a dictionary of all the notes with their id as the key
    Iterable notes = maps.map((map) => Note.fromMap(map));
    return <int,Note>{for (var note in notes) note.id: note};
  }

  // Clears all notes in the database
  static Future<void> clearNotes() async {
    final db = await database;
    db.delete('notes');
  }

  // Inserts a Note into the database and replace any existing notes that have matching ids
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

  // Deletes a given Note from the database
  static Future<void> deleteNote(Note note) async {
    final db = await database;

    db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

}

// Uses a title and a Map of 'column name': 'SQLite type' to generate an SQL query to create such a table
class DatabaseTable {
  final String tableName;
  final Map<String, String> columns; // Should be 'column name': 'SQLite type'

  const DatabaseTable({required this.tableName, required this.columns});
  
  // Outputs an SQLite query that creates a table using tableName as the table's name
  // and columns corresponding to the [columns] map
  String createQuery() {
    
    var args = <String>[];
    var keys = columns.keys;

    // Iterates through each column and adds the correct column COLUMN TYPE string
    for (var key in keys) {
      args.add('$key ${columns[key]}');
    }
    return 'CREATE TABLE $tableName(${args.join(", ")})';
  }
}