import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'screens/note_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ydczphujuezkncyanhwc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlkY3pwaHVqdWV6a25jeWFuaHdjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1NjQ3OTQsImV4cCI6MjA3NTE0MDc5NH0.RBXdiCHuvNd8E5BB2dhpzyJ10JxJcdirq1y5DlxDasI',
  );

  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Supabase.instance.client.auth.currentSession != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F1FA),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: isLoggedIn ? '/notes' : '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/notes': (context) => const NotesScreen(),
      },
    );
  }
}