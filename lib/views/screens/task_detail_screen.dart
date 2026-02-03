import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/task_model.dart';
class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  Task? task;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTaskDetail();
  }

  Future<void> fetchTaskDetail() async {
    final url = Uri.parse('https://amock.io/api/researchUTH/task/${widget.taskId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final taskData = decoded['data'];

        setState(() {
          task = Task.fromJson(taskData);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load detail');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error: $e");
    }
  }

  Future<void> deleteTask() async {
    final url = Uri.parse('https://amock.io/api/researchUTH/task/${widget.taskId}');
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn muốn xóa task này?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Xóa", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      try {
        final response = await http.delete(url);
        if (response.statusCode == 200 || response.statusCode == 204) {
          debugPrint("Đã xoá task thành công!");
          if (mounted) Navigator.pop(context, true);
        }
      } catch (e) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: deleteTask,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : task == null
          ? const Center(child: Text("Lỗi tải dữ liệu"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ảnh mô tả (nếu có)
            if (task!.desImageURL.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  task!.desImageURL,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(height: 200, color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported)),
                ),
              ),
            const SizedBox(height: 16),

            // 2. Title
            Text(task!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // 3. Description
            Text(task!.description, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            const SizedBox(height: 16),

            // 4. Info Grid (Category, Status, Priority)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoBadge(Icons.folder, "Category", task!.category, Colors.blue),
                _buildInfoBadge(Icons.flag, "Priority", task!.priority, Colors.orange),
                _buildInfoBadge(Icons.timelapse, "Status", task!.status, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),

            // 5. Subtasks Section
            const Text("Subtasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...task!.subtasks.map((sub) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                sub.title,
                style: TextStyle(
                  decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                  color: sub.isCompleted ? Colors.grey : Colors.black,
                ),
              ),
              value: sub.isCompleted,
              onChanged: (val) {
                // Xử lý update trạng thái subtask ở đây (nếu cần gọi API)
              },
              controlAffinity: ListTileControlAffinity.leading,
            )),

            const Divider(height: 32),

            // 6. Attachments Section
            const Text("Attachments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (task!.attachments.isEmpty)
              const Text("No attachments", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            ...task!.attachments.map((file) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.blue),
                title: Text(file.fileName),
                trailing: const Icon(Icons.download_rounded),
                onTap: () {
                  // Mở link fileUrl
                  print("Opening ${file.fileUrl}");
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  // Widget con để vẽ các ô thông tin nhỏ
  Widget _buildInfoBadge(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}