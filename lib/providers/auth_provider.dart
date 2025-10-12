import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// Provides access to SupabaseService methods (signIn, signUp, etc.)
final authProvider = Provider((ref) => SupabaseService());

/// Watches Supabase auth state changes (login/logout)
final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});