import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_screen.dart'; // Import AuthScreen

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _currentUser = FirebaseAuth.instance.currentUser;

  // Hàm để lấy dữ liệu người dùng từ Firestore
  Future<DocumentSnapshot> _getUserData() async {
    if (_currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
    } else {
      // Trường hợp không có user đăng nhập
      throw Exception("User not logged in");
    }
  }

  Future<void> _signOut() async { // Hàm này sẽ hiển thị dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đăng xuất"),
          content: Text("Bạn có chắc chắn muốn đăng xuất?"),
          actions: <Widget>[
            TextButton(
              child: Text("Hủy", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              child: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Navigator.of(context).pop(); // Đóng dialog trước
                _performSignOut(); // Gọi hàm đăng xuất *sau* khi đóng dialog

              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _performSignOut() async { // Hàm này thực hiện đăng xuất
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi đăng xuất: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Không tìm thấy thông tin người dùng.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String name = userData['name'] ?? 'Chưa cập nhật';
          final String phone = userData['phone'] ?? 'Chưa cập nhật';
          final String address = userData['address'] ?? 'Chưa cập nhật';

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // URL ảnh
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    _currentUser!.email!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                _buildInfoRow(Icons.phone, phone),
                _buildInfoRow(Icons.email, _currentUser!.email!),
                _buildInfoRow(Icons.location_on, address),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _signOut, // Gọi hàm _signOut (hiển thị dialog)
                    child: Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}