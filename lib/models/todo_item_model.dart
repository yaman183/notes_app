class TodoItemModel {
  final String id;
  final String text;
  final bool isCompleted;

  TodoItemModel({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });

  TodoItemModel copyWith({
    String? id,
    String? text,
    bool? isCompleted,
  }) {
    return TodoItemModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isCompleted': isCompleted,
      };

  factory TodoItemModel.fromJson(Map<String, dynamic> json) {
    return TodoItemModel(
      id: json['id'],
      text: json['text'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}