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
