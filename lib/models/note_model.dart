// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

/// Represents a note with sticky note styling
@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String content,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default('yellow') String color,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Note;

  /// Creates a Note from JSON (Supabase response)
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

/// Sticky note color presets with unique gradients
enum NoteColor {
  yellow,
  pink,
  blue,
  green,
  purple,
  orange,
  mint,
  coral;

  String get displayName {
    switch (this) {
      case NoteColor.yellow:
        return 'Sunshine';
      case NoteColor.pink:
        return 'Rose';
      case NoteColor.blue:
        return 'Ocean';
      case NoteColor.green:
        return 'Forest';
      case NoteColor.purple:
        return 'Lavender';
      case NoteColor.orange:
        return 'Tangerine';
      case NoteColor.mint:
        return 'Mint';
      case NoteColor.coral:
        return 'Coral';
    }
  }

  Color get primary {
    switch (this) {
      case NoteColor.yellow:
        return const Color(0xFFFFF9C4);
      case NoteColor.pink:
        return const Color(0xFFFCE4EC);
      case NoteColor.blue:
        return const Color(0xFFE3F2FD);
      case NoteColor.green:
        return const Color(0xFFE8F5E9);
      case NoteColor.purple:
        return const Color(0xFFF3E5F5);
      case NoteColor.orange:
        return const Color(0xFFFFE0B2);
      case NoteColor.mint:
        return const Color(0xFFE0F2F1);
      case NoteColor.coral:
        return const Color(0xFFFFCCBC);
    }
  }

  Color get secondary {
    switch (this) {
      case NoteColor.yellow:
        return const Color(0xFFFFF59D);
      case NoteColor.pink:
        return const Color(0xFFF8BBD0);
      case NoteColor.blue:
        return const Color(0xFFBBDEFB);
      case NoteColor.green:
        return const Color(0xFFC8E6C9);
      case NoteColor.purple:
        return const Color(0xFFE1BEE7);
      case NoteColor.orange:
        return const Color(0xFFFFCC80);
      case NoteColor.mint:
        return const Color(0xFFB2DFDB);
      case NoteColor.coral:
        return const Color(0xFFFFAB91);
    }
  }

  Color get accent {
    switch (this) {
      case NoteColor.yellow:
        return const Color(0xFFFDD835);
      case NoteColor.pink:
        return const Color(0xFFEC407A);
      case NoteColor.blue:
        return const Color(0xFF42A5F5);
      case NoteColor.green:
        return const Color(0xFF66BB6A);
      case NoteColor.purple:
        return const Color(0xFFAB47BC);
      case NoteColor.orange:
        return const Color(0xFFFF9800);
      case NoteColor.mint:
        return const Color(0xFF26A69A);
      case NoteColor.coral:
        return const Color(0xFFFF7043);
    }
  }

  Color get textColor {
    return const Color(0xFF37474F);
  }

  Color get shadowColor {
    return accent.withValues(alpha: 0.3);
  }
}
