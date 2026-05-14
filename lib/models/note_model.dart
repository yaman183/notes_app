import 'attachment_model.dart';
import 'todo_item_model.dart';

class NoteModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TodoItemModel> todos;
  final List<AttachmentModel> attachments;
  final bool isDeleted;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.todos = const [],
    this.attachments = const [],
    this.isDeleted = false,
  });

  NoteModel copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
    List<TodoItemModel>? todos,
    List<AttachmentModel>? attachments,
    bool? isDeleted,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      todos: todos ?? this.todos,
      attachments: attachments ?? this.attachments,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'todos': todos.map((e) => e.toJson()).toList(),
        'attachments': attachments.map((e) => e.toJson()).toList(),
        'isDeleted': isDeleted,
      };

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      todos: (json['todos'] as List)
          .map((e) => TodoItemModel.fromJson(e))
          .toList(),
      attachments: (json['attachments'] as List)
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}