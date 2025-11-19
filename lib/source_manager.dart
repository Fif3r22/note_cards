// Define the [Source] class, which stores data about the
// source that notes are taken from (author, date, title, and source)

enum CitationStyle { apa, mla, chicago, } // Add later: ama, ieee. 
// Note: to add a new citation style 
// 1) Add the name of the new style to the [CitationStyle] enum
// 2) Add a static method to the [CitationFormatter] class that accepts a [Source]
//    object and returns a [String] object
// 3) Add an entry to the [CitationFormatter._formatters] Map with the new [CitationStyle]
//    enum value as the key and the [CitationFormatter] method as the value

class Source {
  final int? id;
  final String author;
  final DateTime date;
  final String title;
  final String source;

  static CitationStyle citationStyle = CitationStyle.apa;

  const Source({this.id, required this.author, required this.date, required this.title, required this.source});

  // Convert the [Source] into a [Map] for storing in a database
  Map<String, Object?> toMap() => {
    'id': id,
    'author': author,
    'date': date.toIso8601String(),
    'title': title,
    'source': source
  };
  
  // Convert a [Map] into a [Source] for parsing from a database
  factory Source.fromMap(Map<String,Object?> map) {
    return Source(
      id: map['id'] as int?,
      author: map['author'] as String,
      date: DateTime.parse(map['date'] as String),
      title: map['title'] as String,
      source: map['source'] as String,
    );
  }

  // Format as a string based either on the global CitationStyle, or an optional CitationStyle argument
  String toCitation({CitationStyle? style}) {
    final effectiveStyle = style ?? citationStyle;
    return CitationFormatter.formatter(effectiveStyle)(this);
  }

}

// Helper class with static methods to format [Source] objects as [String] object according to different styles
class CitationFormatter {
  
  // Maps the function to use with a particular [CitationStyle] value
  static final Map<CitationStyle, Formatter> _formatters = {
    CitationStyle.apa: CitationFormatter.apa,
    CitationStyle.mla: CitationFormatter.mla,
    CitationStyle.chicago: CitationFormatter.chicago,
  };
  
  // Returns the formatter for the given style and throws an error if not found
  static Formatter formatter(CitationStyle style) {
    var f = _formatters[style];
    if (f == null) {
      throw UnimplementedError("Formatter not defined for $style");
    }
    return f;
  }
  
  // APA Format
  static String apa(Source s) => '${s.author} (${s.date.year}). ${s.title}. ${s.source}.';

  // MLA Format
  static String mla(Source s) => '${s.author}. "${s.title}." ${s.source}, ${s.date.year}.';

  // Chicago Format
  static String chicago(Source s) => '${s.author}. ${s.title}. ${s.source}, ${s.date.year}.';
  
  // Default format to use if the [CitationStyle] is not included in formatters
  static String defaultFormat(Source s) => apa(s);
}

// For use in the formatters map in [CitationFormatter]
typedef Formatter = String Function(Source);
