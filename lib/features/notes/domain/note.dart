import 'package:note_cards/core/db/mappable.dart';

// Handles the data and logic for each individual note

class Note implements Storable {
  @override
  int? id;
  final String title;
  final String content;

  Note({this.id, this.title = '', this.content = ''});

  // Convert the Note into a Map to save in a database
  @override
  Map<String, Object?> toMap() => {'id': id, 'title': title, 'content': content};

  // Make a factory constructor to convert a Note from a Map<String, Object?>
  factory Note.fromMap(Map<String, Object?> map) {
    return Note(
      id: map['id'] as int?, 
      title: map['title'] as String, 
      content: map['content'] as String,
    );
  }

}
