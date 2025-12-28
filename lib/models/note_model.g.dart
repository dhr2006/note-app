// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  userId: json['user_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  color: json['color'] as String? ?? 'yellow',
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'color': instance.color,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
