// Defines the class `NoteCard`
// NoteCard is a stateless widget that contains an icon, title, and content text 

import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String content;
  const NoteCard({super.key, this.icon = Icons.drag_indicator, this.title = "", this.content = ""});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(content),
      ),
    );
  }
}