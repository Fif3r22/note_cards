import 'package:note_cards/features/sources/domain/source.dart';
import 'package:sqflite/sqflite.dart';
import 'package:note_cards/core/db/base_dao.dart';

// Database Access Object (DAO) for sources

class SourceDao extends BaseDao<Source> {
  SourceDao(Database db) : super(db: db, tableName: 'sources');

  @override
  Source fromMap(Map<String, Object?> map) => Source.fromMap(map);
}