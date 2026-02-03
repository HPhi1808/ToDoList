// Model cho Subtask (Công việc phụ)
class Subtask {
  final int id;
  final String title;
  final bool isCompleted;

  Subtask({required this.id, required this.title, required this.isCompleted});

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

// Model cho Attachment (File đính kèm)
class Attachment {
  final int id;
  final String fileName;
  final String fileUrl;

  Attachment({required this.id, required this.fileName, required this.fileUrl});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
    );
  }
}

// Model chính cho Task
class Task {
  final int id;
  final String title;
  final String desImageURL; // Ảnh mô tả
  final String description;
  final String status;
  final String priority;
  final String category;
  final String dueDate;
  final List<Subtask> subtasks;
  final List<Attachment> attachments;

  Task({
    required this.id,
    required this.title,
    required this.desImageURL,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    required this.dueDate,
    required this.subtasks,
    required this.attachments,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Xử lý an toàn cho list subtask
    var listSub = json['subtasks'] as List? ?? [];
    List<Subtask> subtaskList = listSub.map((i) => Subtask.fromJson(i)).toList();

    // Xử lý an toàn cho list attachment
    var listAtt = json['attachments'] as List? ?? [];
    List<Attachment> attList = listAtt.map((i) => Attachment.fromJson(i)).toList();

    return Task(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      desImageURL: json['desImageURL'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      priority: json['priority'] ?? 'Low',
      category: json['category'] ?? 'General',
      dueDate: json['dueDate'] ?? '',
      subtasks: subtaskList,
      attachments: attList,
    );
  }
}