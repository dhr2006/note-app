// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_await_in_return

import 'package:noteapp/models/note_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_service.g.dart';

/// Main service class for all Supabase operations
class SupabaseService {
  SupabaseService(this._supabase);

  final SupabaseClient _supabase;

  // ==================== AUTH METHODS ====================

  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _supabase.auth.currentSession != null;

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  // ==================== NOTE METHODS ====================

  /// Fetch all notes for current user
  Future<List<Note>> fetchNotes() async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Note.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Create a new note
  Future<Note> createNote({
    required String title,
    required String content,
    String color = 'yellow',
  }) async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase.from('notes').insert({
      'title': title,
      'content': content,
      'user_id': userId,
      'color': color,
      'created_at': DateTime.now().toIso8601String(),
    }).select().single();

    return Note.fromJson(response);
  }

  /// Update an existing note
  Future<Note> updateNote({
    required String id,
    required String title,
    required String content,
    required String color,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase
        .from('notes')
        .update({
          'title': title,
          'content': content,
          'color': color,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .eq('user_id', userId)
        .select()
        .single();

    return Note.fromJson(response);
  }

  /// Delete a note by ID
  Future<void> deleteNote(String id) async {
    final userId = currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _supabase
        .from('notes')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  /// Watch notes in real-time
  Stream<List<Note>> watchNotes() {
    final userId = currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    return _supabase
        .from('notes')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        // ignore: avoid_redundant_argument_values
        .order('created_at', ascending: false)
        .map(
          (data) => data
              // ignore: unnecessary_lambdas
              .map((json) => Note.fromJson(json))
              .toList(),
        );
  }
}

// ==================== RIVERPOD PROVIDERS ====================

/// Provider for SupabaseService instance
@Riverpod(keepAlive: true)
SupabaseService supabaseService(SupabaseServiceRef ref) {
  return SupabaseService(Supabase.instance.client);
}

/// Provider for authentication state
@Riverpod(keepAlive: true)
Stream<AuthState> authState(AuthStateRef ref) {
  final service = ref.watch(supabaseServiceProvider);
  return service.authStateChanges;
}

/// Provider for current user
@Riverpod(keepAlive: true)
User? currentUser(CurrentUserRef ref) {
  final service = ref.watch(supabaseServiceProvider);
  return service.currentUser;
}

/// Provider for fetching notes list
@riverpod
Future<List<Note>> notesList(NotesListRef ref) async {
  final service = ref.watch(supabaseServiceProvider);
  return service.fetchNotes();
}

/// Provider for real-time notes stream
@riverpod
Stream<List<Note>> notesStream(NotesStreamRef ref) {
  final service = ref.watch(supabaseServiceProvider);
  return service.watchNotes();
}
