import 'package:flutter/material.dart';
import 'package:sqflite_database_demo/core/commons/notes_from_widget.dart';
import 'package:sqflite_database_demo/db/keep_note_database.dart';
import 'package:sqflite_database_demo/model/keep_note_model.dart';

class AddEditNotePage extends StatefulWidget {
  final KeepNoteModel? note;

  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        actions: [buildButton()],
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangedImportant: (isImportant) => setState(() => this.isImportant = isImportant),
          onChangedNumber: (number) => setState(() => this.number = number),
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) => setState(() => this.description = description),
        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? Colors.green.shade700 : Colors.green.shade300,
        ),
        onPressed: addOrUpdateNote,
        child: Text(
          'Save',
          style: TextStyle(
            color: isFormValid ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await KeepNoteDataBase.instance.update(note);
  }

  Future addNote() async {
    final note = KeepNoteModel(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await KeepNoteDataBase.instance.create(note);
  }
}
