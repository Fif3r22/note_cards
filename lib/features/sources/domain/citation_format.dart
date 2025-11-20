import 'package:note_cards/features/sources/domain/source.dart';

// The available styles for formatting sources
// Note: To add a new citation style 
// 1) Add the name of the new citation style to the [CitationStyle] enum
// 2) Add a static formatting method to the [CitationFormatter] class that returns the correctly formatted string
// 3) Map the new formatting method to the new citation style in [CitationFormatter._formatters]
enum CitationStyle { apa, mla, chicago, } // Add later: ama, ieee. 

// Adds a method to the Source class to format as a string based either on the
// global CitationStyle, or an optional CitationStyle argument
extension CitationFormat on Source {
  String toCitation({CitationStyle? style}) {
    final effectiveStyle = style ?? Source.citationStyle;
    return CitationFormatter.formatter(effectiveStyle)(this);
  }
}

// Helper class with static methods to convert sources into strings with different styles
class CitationFormatter {
  
  // Maps the function to use with a particular CitationStyle value
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
  
}

// For use in the formatters map in [CitationFormatter]
typedef Formatter = String Function(Source);