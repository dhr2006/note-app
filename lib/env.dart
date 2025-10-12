import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl {
    return kIsWeb
        ? const String.fromEnvironment('SUPABASE_URL')
        : dotenv.env['SUPABASE_URL'] ?? '';
  }

  static String get supabaseAnonKey {
    return kIsWeb
        ? const String.fromEnvironment('SUPABASE_ANON_KEY')
        : dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }
}