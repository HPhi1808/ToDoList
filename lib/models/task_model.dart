import 'dart:convert';

class Subtask {
  final int id;
  final String title;
  final bool isCompleted;

  Subtask({required this.id, required this.title, required this.isCompleted});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'isCompleted': isCompleted};

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

  Map<String, dynamic> toJson() => {'id': id, 'fileName': fileName, 'fileUrl': fileUrl};

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
  final String desImageURL;
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

  // 1. Hàm chuyển Object -> Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id == 0 ? null : id,
      'title': title,
      'desImageURL': desImageURL,
      'description': description,
      'status': status,
      'priority': priority,
      'category': category,
      'dueDate': dueDate,
      'subtasks': jsonEncode(subtasks.map((e) => e.toJson()).toList()),
      'attachments': jsonEncode(attachments.map((e) => e.toJson()).toList()),
    };
  }

  // 2. Cập nhật hàm fromJson để đọc được cả từ API và SQLite
  factory Task.fromJson(Map<String, dynamic> json) {
    var subtasksRaw = json['subtasks'];
    List<Subtask> subList = [];
    if (subtasksRaw is String) {
      subList = (jsonDecode(subtasksRaw) as List).map((i) => Subtask.fromJson(i)).toList();
    } else if (subtasksRaw is List) {
      subList = subtasksRaw.map((i) => Subtask.fromJson(i)).toList();
    }
    var attachRaw = json['attachments'];
    List<Attachment> attList = [];
    if (attachRaw is String) {
      attList = (jsonDecode(attachRaw) as List).map((i) => Attachment.fromJson(i)).toList();
    } else if (attachRaw is List) {
      attList = attachRaw.map((i) => Attachment.fromJson(i)).toList();
    }

    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      desImageURL: json['desImageURL'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      priority: json['priority'] ?? 'Low',
      category: json['category'] ?? 'General',
      dueDate: json['dueDate'] ?? '',
      subtasks: subList,
      attachments: attList,
    );
  }
}