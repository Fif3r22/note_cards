// Define a class NoteStorage that handles the database storage, updates, and retrieval for NoteCards

import 'dart:async'; // For asynchronous operations
import 'dart:io'; // To detect platform
import 'package:path/path.dart'; // For file path management
import 'package:path_provider/path_provider.dart'; // For file path management
import 'package:sqflite/sqflite.dart'; // For native mobile and macOS databases
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // For desktop (Windows/Linux) databases

class NoteStorage {
  late final Future<Database> database;
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

    // Set the path to the database. If the platform is Android, using `getDatabasesPath()` is appropriate,
    // otherwise use `getApplicationDocumentsDirectory()`
    databasePath = Platform.isAndroid ? await getDatabasesPath() : (await getApplicationDocumentsDirectory()).path;
    
    // Create a database and store the reference
    database = openDatabase(
      join(databasePath, databaseFile), // Specify the path
      onCreate: (db, version) => db.execute('CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)'), // Create a table to store notes 
      version: 1, // Set the version. This executes the onCreate function
    );
  }
}