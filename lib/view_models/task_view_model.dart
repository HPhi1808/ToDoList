import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import '../services/database_helper.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // 1. Hàm Load Data (Offline + Online)
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    // B1: Load từ Local DB trước (Hiển thị ngay lập tức)
    _tasks = await DatabaseHelper.instance.getAllTasks();
    notifyListeners();

    // B2: Gọi API (Chạy ngầm để cập nhật mới nhất)
    try {
      final url = Uri.parse('https://amock.io/api/researchUTH/tasks');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        List<dynamic> listData = (decoded is Map) ? decoded['data'] : decoded;

        List<Task> apiTasks = listData.map((e) => Task.fromJson(e)).toList();

        // B3: Có dữ liệu mới từ API -> Lưu vào Local DB -> Cập nhật UI
        if (apiTasks.isNotEmpty) {
          await DatabaseHelper.instance.syncTasks(apiTasks);
          _tasks = apiTasks;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Đang chạy chế độ Offline: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Hàm Thêm Task Mới
  Future<void> addNewTask(String title, String description) async {
    final newTask = Task(
      id: 0,
      title: title,
      description: description,
      dueDate: DateTime.now().toIso8601String(),
      status: 'Pending',
      priority: 'Medium',
      category: 'General', desImageURL: '', subtasks: [], attachments: [],
    );

    // Lưu vào Local DB
    await DatabaseHelper.instance.insertTask(newTask);

    // Reload lại list từ Local để hiện ngay lập tức
    _tasks = await DatabaseHelper.instance.getAllTasks();
    notifyListeners();
  }


  Future<void> deleteTask(int id) async {
    // 1. Xóa trong Local DB
    await DatabaseHelper.instance.deleteTask(id);

    // 2. Cập nhật list trong ViewModel
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();

    // 3. Gọi API xóa
    try {
      final url = Uri.parse('https://amock.io/api/researchUTH/task/$id');
      await http.delete(url);
    } catch (e) {
      debugPrint("Offline delete: Không thể xóa trên server ngay lập tức");
    }
  }
}