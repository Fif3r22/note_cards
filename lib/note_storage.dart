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
import 'package:note_cards/note_card.dart';

// NoteStorage Class

class NoteStorage {
  late final Database database;
  final String databaseFile;
  late final String databasePath;

  NoteStorage({this.databaseFile = 'note_database.db'}); // Basic constructor
  
  // Must be called before the database can be used
  Future<void> initialize() async {
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
    databasePath = Platform.isAndroid ? await getDatabasesPath() : (await getApplicationDocumentsDirectory()).path;
    
    // Create a database and store the reference
    database = await openDatabase(
      join(databasePath, databaseFile), // Specify the path
      onCreate: (db, version) => db.execute('CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)'), // Create a table to store notes 
      version: 1, // Set the version. This executes the onCreate function
    );
  }
  
  // Clear all notes
  Future<void> clear() async {
    database.delete('notes');
  }

  // Insert a Note into the database and replace any duplicate notes already in the database
  Future<void> addNote(Note note) async {
    await database.insert(
      'notes', // Table to use
      note.toMap(), // Converts the Note to a Map<String, Object?>
      conflictAlgorithm: ConflictAlgorithm.replace, // Specifies the algorithm to resolve duplicate entries
    );
  }

  Future<List<Note>> getNotes() async {
    // Query the table for all the notes
    final List<Map<String, Object?>> noteMaps = await database.query('notes');

    // Return the List<Map<String, Object?>> as a List<Note> using a list comprehension
    return [
      for (final {"id" : id as int, 'title' : title as String, 'content' : content as String} in noteMaps)
      Note(id: id, title: title, content: content)
    ];
  }
}