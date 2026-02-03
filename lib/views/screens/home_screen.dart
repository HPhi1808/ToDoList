import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'task_detail_screen.dart';
import '../../models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  // Gọi API lấy danh sách task
  Future<void> fetchTasks() async {
    final url = Uri.parse('https://amock.io/api/researchUTH/tasks');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // 1. Decode ra dynamic trước
        final dynamic decodedResponse = json.decode(response.body);

        // 2. Lấy danh sách từ key 'data'
        if (decodedResponse is Map<String, dynamic> && decodedResponse['data'] != null) {
          final List<dynamic> dataList = decodedResponse['data'];

          setState(() {
            tasks = dataList.map((json) => Task.fromJson(json)).toList();
            isLoading = false;
          });
        } else if (decodedResponse is List) {
          setState(() {
            tasks = decodedResponse.map((json) => Task.fromJson(json)).toList();
            isLoading = false;
          });
        } else {
          debugPrint("Cấu trúc JSON không khớp: $decodedResponse");
          setState(() => isLoading = false);
        }
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }

  // Hàm chuyển trang và reload list khi quay lại (nếu có xóa)
  void _navigateToDetail(String taskId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailScreen(taskId: taskId)),
    );

    if (result == true) {
      fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UTH SmartTasks")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? _buildEmptyView() // Hiển thị nếu danh sách rỗng
          : _buildListView(), // Hiển thị danh sách
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.assignment_late_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("No Tasks Yet!", style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final task = tasks[index];

        // Xử lý hiển thị ngày tháng đơn giản (lấy phần yyyy-mm-dd)
        String displayDate = task.dueDate.length >= 10
            ? task.dueDate.substring(0, 10)
            : task.dueDate;

        return Card(
          elevation: 2, // Tạo bóng đổ nhẹ
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _navigateToDetail(task.id.toString()), // Chuyển int sang String nếu cần
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Ảnh thumbnail (Nếu có URL thì hiện, không thì hiện icon mặc định)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                      image: task.desImageURL.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(task.desImageURL),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: task.desImageURL.isEmpty
                        ? const Icon(Icons.assignment, color: Colors.grey)
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // 2. Nội dung chính
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),

                        const SizedBox(height: 4),

                        // Description
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),

                        const SizedBox(height: 8),

                        // Row chứa Date và Priority
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(displayDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),

                            const SizedBox(width: 12),

                            // Priority Badge nhỏ
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(task.priority).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: _getPriorityColor(task.priority), width: 0.5),
                              ),
                              child: Text(
                                task.priority,
                                style: TextStyle(fontSize: 10, color: _getPriorityColor(task.priority), fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  // 3. Status Chip (Góc phải)
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(task.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.status,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Hàm phụ trợ để lấy màu theo mức độ ưu tiên
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.green;
      default: return Colors.blue;
    }
  }

// Hàm phụ trợ để lấy màu theo trạng thái
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress': return Colors.blue;
      case 'completed': return Colors.green;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }
}