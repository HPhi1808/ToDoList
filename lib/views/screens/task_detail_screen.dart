import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../view_models/task_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  void _confirmDelete(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn muốn xóa task này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm && context.mounted) {
      await Provider.of<TaskViewModel>(context, listen: false).deleteTask(task.id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = task.dueDate.length >= 10
        ? task.dueDate.substring(0, 10)
        : task.dueDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ảnh mô tả
            if (task.desImageURL.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  task.desImageURL,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                        Text("Cannot load image offline", style: TextStyle(color: Colors.grey))
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // 2. Title
            Text(task.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // 3. Description
            Text(task.description, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
            const SizedBox(height: 16),

            // 4. Info Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoBadge(Icons.folder, "Category", task.category, Colors.blue),
                _buildInfoBadge(Icons.flag, "Priority", task.priority, Colors.orange),
                _buildInfoBadge(Icons.timelapse, "Status", task.status, Colors.purple),
              ],
            ),
            const SizedBox(height: 24),

            // 5. Subtasks
            if (task.subtasks.isNotEmpty) ...[
              const Text("Subtasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...task.subtasks.map((sub) => CheckboxListTile(
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

                },
                controlAffinity: ListTileControlAffinity.leading,
              )),
              const Divider(height: 32),
            ],

            // 6. Attachments
            const Text("Attachments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (task.attachments.isEmpty)
              const Text("No attachments", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),

            ...task.attachments.map((file) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.blue),
                title: Text(file.fileName),
                trailing: const Icon(Icons.download_rounded),
                onTap: () {
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

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