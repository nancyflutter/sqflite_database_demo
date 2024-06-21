import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_database_demo/ui/keep_note_page.dart';

Future<void> main() async {
  // for portrait mod
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "KeepNotes SQLite",
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white)
        ),
      ),
      home: const NotesPage(),
    );
  }
}
