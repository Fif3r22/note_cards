import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:note_cards/core/db/database_table.dart';

// AppStorage class intializes the database and returns a reference
class AppStorage {
  // Single database instance
  static Database? _db;
  
  // Information for tables within database
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
  static Future<Database> getInstance() async {
    // Return the database immediately if it has already been initializedd
    if (_db != null) return _db!;

    // Setup sqflite for cross-paltform use
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      // For mobile and macOS, the databaseFactory is set by default
    } else {
      // Desktop (Windows, Linux) use sqflite_common_ffi and need the databaseFactory set manually
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Set the path to the database. On Android platforms, using getDatabasesPath() is appropriate,
    // otherwise use getApplicationDocumentsDirectory()
    final String databasePath = Platform.isAndroid ? await getDatabasesPath() : (await getApplicationDocumentsDirectory()).path;
    final String path = join(databasePath, 'notes.db');

    // Open the database and return it
    _db = await openDatabase(
      path,
      version: 1, // Set the version. This executes the onCreate function
      onCreate: (db, version) async { // Create a new table for each item in _tables
        for (var table in _tables) {
          await db.execute(table.createQuery());
        }
      },
    );
    return _db!;
  }
  
}

// App Storage database provider
final databaseProvider = FutureProvider<Database>((ref) async {return await AppStorage.getInstance();});