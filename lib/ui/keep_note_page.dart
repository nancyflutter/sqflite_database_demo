import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite_database_demo/core/commons/common_card_widget.dart';
import 'package:sqflite_database_demo/db/keep_note_database.dart';
import 'package:sqflite_database_demo/model/keep_note_model.dart';
import 'package:sqflite_database_demo/ui/add_edit_note_page.dart';
import 'package:sqflite_database_demo/ui/note_detail_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<KeepNoteModel>? notes;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    refreshNote();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    KeepNoteDataBase.instance.closeDB();
    super.dispose();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    notes = await KeepNoteDataBase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'KeepNotes',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: const [Icon(Icons.search), SizedBox(width: 12)],
      ),
      /*    body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    'No Notes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  )
                : StaggeredGrid.count(
                    // itemCount: notes.length,
                    // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: List.generate(
                      notes.length,
                      (index) {
                        final note = notes[index];

                        return StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NoteDetailPage(noteId: note.id!),
                              ));
                              refreshNote();
                            },
                            child: NoteCardWidget(note: note, index: index),
                          ),
                        );
                      },
                    ),
                  ),
      ),*/
      body: StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        itemCount: notes?.length ?? 0,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes![index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id ?? 0),
              ));

              refreshNote();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade200,
        child: const Icon(Icons.add,color: Colors.white,),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );
          refreshNote();
        },
      ),
    );
  }
}
