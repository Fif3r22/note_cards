import 'package:sqflite/sqflite.dart';
import 'package:note_cards/core/db/mappable.dart';

abstract class BaseDao<T extends Storable> {
  final Database db;
  final String tableName;

  BaseDao({required this.db, required this.tableName});

  // Define basic CRUD operations

  // Insert
  Future<int> insert(T item) async {
    return db.insert(tableName, item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update
  Future<int> update(T item, {String? where, List<Object?>? whereArgs}) async {
    return db.update(tableName, item.toMap(), where: where, whereArgs: whereArgs);
  }

  // Delete
  Future<int> delete({String? where, List<Object?>? whereArgs}) async {
    return db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  // Query
  Future<Map<int, T>> query({String? where, List<Object?>? whereArgs}) async {
    // Gets a list of raw map objects
    List<Map<String, Object?>> rows = await db.query(tableName, where: where, whereArgs: whereArgs);

    // Converts the list into a dictionary that maps each item of type T to an integer that represents its id
    return <int,T>{
      for (var row in rows)
        row['id'] as int: fromMap(row)
    };
  
  }

  // Return all elements in the table as an id-keyed dictionary of T objects
  Future<Map<int,T>> getAll() async => query();
  
  // Deletes all elements in the table
  Future<int> deleteAll() async => delete();

  // Abstract fromMap function
  T fromMap(Map<String, Object?> map);

}