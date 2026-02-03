import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task_model.dart';
import '../screens/task_detail_screen.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _getThemeColor(task.category);
    Color textColor = Colors.black87;
    String formattedDate = task.dueDate;
    try {
      DateTime date = DateTime.parse(task.dueDate);
      formattedDate = DateFormat('HH:mm yyyy-MM-dd').format(date);
    } catch (e) {
    }
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.7),
                  decoration: TextDecoration.none,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: textColor),
                      children: [
                        const TextSpan(
                          text: "Status: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: task.status,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(task.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getThemeColor(String category) {
    switch (category.toLowerCase()) {
      case 'android': return const Color(0xFFEF9A9A);
      case 'work': return const Color(0xFFC5E1A5);
      case 'fitness': return const Color(0xFF81D4FA);
      default: return const Color(0xFFFFE082);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return Colors.green.shade900;
      case 'in progress': return Colors.blue.shade900;
      case 'pending': return Colors.orange.shade900;
      default: return Colors.black87;
    }
  }
}