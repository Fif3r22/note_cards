import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'note_card.dart';
import 'notes_provider.dart';

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
        appBar: AppBar(title: Text("Notes App")),
        body: Center(
          child: NotesView(),
        ),
        bottomNavigationBar: BottomRow(),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
    );
  }
}

class BottomRow extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();
  
  BottomRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsetsGeometry.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Start typing your note here",
              ),
            )
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(6),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                //iconSize: 50,
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  ref.read(notesProvider.notifier).saveNote(Note(content: _controller.text));
                  _controller.clear();
                },
              )
            )
          ),
        ],
      )
    );
  }
}
