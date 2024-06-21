import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_database_demo/db/keep_note_database.dart';
import 'package:sqflite_database_demo/model/keep_note_model.dart';
import 'package:sqflite_database_demo/ui/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    super.key,
    required this.noteId,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  KeepNoteModel? note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = (await KeepNoteDataBase.instance.readNote(widget.noteId));

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
        actionsIconTheme: const IconThemeData(color: Colors.green),
        foregroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            Text(
              note?.title ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMMMd().format(note?.createdTime ?? DateTime.now()),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              note?.description ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Widget editButton() => IconButton(
      icon: const Icon(
        Icons.edit_outlined,
        color: Colors.green,
      ),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () async {
          await KeepNoteDataBase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}
