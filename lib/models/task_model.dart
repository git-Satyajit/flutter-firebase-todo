class Task {
  String id;
  String title;
  bool isCompleted;

  Task({
    required this.id, 
    required this.title, 
    this.isCompleted = false,
  });

  // Converts our Task into JSON to send to Firebase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Converts JSON from Firebase back into a Task object
  factory Task.fromJson(String id, Map<String, dynamic> json) {
    return Task(
      id: id,
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}