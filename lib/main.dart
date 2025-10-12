import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import 'env.dart';
import 'theme.dart';
import 'screens/auth_screen.dart';
import 'screens/notes_screen.dart';
import 'providers/auth_provider.dart'; // includes both authProvider and authStateProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env only for non-web platforms
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: ".env");
      debugPrint('✅ .env loaded');
    } catch (e) {
      debugPrint('❌ Failed to load .env: $e');
    }
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
  debugPrint('✅ Supabase initialized');
  debugPrint('🔗 Supabase URL: ${Env.supabaseUrl}');
  debugPrint('🔑 Supabase Key: ${Env.supabaseAnonKey}');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Notes App',
      theme: appTheme,
      home: authState.when(
        data: (event) {
          final session = event.session;
          return session == null ? const AuthScreen() : const NotesScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          body: Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}