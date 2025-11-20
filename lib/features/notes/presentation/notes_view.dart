import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:note_cards/features/notes/application/notes_provider.dart';
import 'package:note_cards/features/notes/presentation/note_card.dart';
import 'package:note_cards/features/notes/domain/note.dart';

// NotesView Class

class NotesView extends ConsumerWidget {
    
  const NotesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesMap = ref.watch(notesProvider).value;

    if (notesMap == null || notesMap.isEmpty) {
      return ListView(children: []);
    } else {
      // Gets the keys as a list so that the builder can iterate over them
      final keys = notesMap.keys.toList();
      // Build the list of notes for the view
      return ListView.builder(
          itemCount: notesMap.length,
          itemBuilder: (context, index) {
            final key = keys[index];
            return NoteCard(notesMap[key] ?? Note());
          }
      );
    }
  }
}