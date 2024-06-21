import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_database_demo/model/keep_note_model.dart';

final _lightColors = [
  Colors.tealAccent.shade100,
  Colors.indigo.shade100,
  Colors.deepPurple.shade100,
  Colors.teal.shade200,
  Colors.green.shade100,
  Colors.pink.shade100,
  Colors.yellow.shade100,
  Colors.red.shade100,
  Colors.purple.shade200,
  Colors.blueGrey.shade200,
  Colors.brown.shade200,
  Colors.orangeAccent.shade100,
];

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    super.key,
    required this.note,
    required this.index,
  });

  final KeepNoteModel note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              note.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
