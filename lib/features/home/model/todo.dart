class Todo {
  final String title;
  final bool isCompleted;
  final String category;

  Todo({
    required this.title,
    required this.isCompleted,
    required this.category,
  });

  // For JSON encoding and decoding
  Map<String, dynamic> toJson() => {
        'title': title,
        'isCompleted': isCompleted,
        'category': category,
      };

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isCompleted: json['isCompleted'],
      category: json['category'],
    );
  }
}
