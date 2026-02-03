// profile_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Xử lý nút back tùy logic của bạn (về trang Home hoặc thoát)
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL ?? "https://via.placeholder.com/150"),
              ),
            ),
            const SizedBox(height: 30),

            // Form Fields (Read-only)
            _buildInfoField("Name", user.displayName ?? "No Name"),
            const SizedBox(height: 15),
            _buildInfoField("Email", user.email ?? "No Email"),
            const SizedBox(height: 15),

            // Date of Birth (Mock UI vì Google không cung cấp)
            _buildInfoField("Date of Birth", "23/05/1995", isDropdown: true),

            const SizedBox(height: 50),

            // Nút Logout (Mô phỏng nút Back màu xanh ở cuối ảnh)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await AuthService().signOut();
                  if(context.mounted) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text("Log Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con để vẽ các ô nhập liệu
  Widget _buildInfoField(String label, String value, {bool isDropdown = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(color: Colors.grey[700])),
              if (isDropdown) const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}