// Define the [Source] class, which stores data about the
// source that notes are taken from (author, date, title, and source)

import 'package:note_cards/core/db/mappable.dart';
import 'package:note_cards/features/sources/domain/citation_format.dart';

class Source implements Storable {
  @override
  int? id;
  String author;
  DateTime date;
  String title;
  String source;

  static CitationStyle citationStyle = CitationStyle.apa;

  Source({this.id, required this.author, required this.date, required this.title, required this.source});

  // Convert the source to a map for storing in a database
  @override
  Map<String, Object?> toMap() => {
    'id': id,
    'author': author,
    'date': date.toIso8601String(),
    'title': title,
    'source': source
  };
  
  // Convert a map back into a Source for parsing from a database
  factory Source.fromMap(Map<String,Object?> map) {
    return Source(
      id: map['id'] as int?,
      author: map['author'] as String,
      date: DateTime.parse(map['date'] as String),
      title: map['title'] as String,
      source: map['source'] as String,
    );
  }

}

