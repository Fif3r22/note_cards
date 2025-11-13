import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'note_card.dart';
import 'notes_provider.dart';

// TO-DO:
// * Implement the NotesNotifier in the UI
// * Refactor App to use NotesNotifier for state

void main() async {
  runApp(const ProviderScope(
    child: NotesApp()
    )
  );
}

class NotesApp extends ConsumerWidget {

  const NotesApp({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: NotesView(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              ref.read(notesProvider.notifier).insertNote(Note());
            },
          ),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              ref.read(notesProvider.notifier).clearNotes();
            },
          ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
    );
  }
}
