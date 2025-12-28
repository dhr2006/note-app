// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseServiceHash() => r'ba31f253ac2214fefe1212c8a0d4764afbcc5909';

/// Provider for SupabaseService instance
///
/// Copied from [supabaseService].
@ProviderFor(supabaseService)
final supabaseServiceProvider = Provider<SupabaseService>.internal(
  supabaseService,
  name: r'supabaseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseServiceRef = ProviderRef<SupabaseService>;
String _$authStateHash() => r'2c8f0eacdcb024c364867e7740ab4a07ba9c1090';

/// Provider for authentication state
///
/// Copied from [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<AuthState>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = StreamProviderRef<AuthState>;
String _$currentUserHash() => r'029bf9c267714b5abc1987bbaaacd40a316cab6e';

/// Provider for current user
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = Provider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = ProviderRef<User?>;
String _$notesListHash() => r'27e122d621ab663a1dce907fcb4548c232f4e6ff';

/// Provider for fetching notes list
///
/// Copied from [notesList].
@ProviderFor(notesList)
final notesListProvider = AutoDisposeFutureProvider<List<Note>>.internal(
  notesList,
  name: r'notesListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesListRef = AutoDisposeFutureProviderRef<List<Note>>;
String _$notesStreamHash() => r'afc1026d48aff342c247c44e864c52ce27bbd21f';

/// Provider for real-time notes stream
///
/// Copied from [notesStream].
@ProviderFor(notesStream)
final notesStreamProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  notesStream,
  name: r'notesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotesStreamRef = AutoDisposeStreamProviderRef<List<Note>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
