import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Thêm logo hoặc hình ảnh giới thiệu ở đây (nếu muốn)
            Image.network(
  'https://st5.depositphotos.com/1748586/65664/v/450/depositphotos_656642312-stock-illustration-coffee-shop-logo-template-natural.jpg', // Replace with the ACTUAL URL of your image
  width: 300,
  height: 300,
  // Optional: Add loading and error handling
  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  },
  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
    return Icon(Icons.error); // Or some other placeholder
  },
),
            SizedBox(height: 30),

            Text(
              'Chào mừng đến với Coffee Topaz!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            ElevatedButton(
               style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Đăng nhập',style: TextStyle(fontSize: 18, color: Colors.white),),
            ),
            SizedBox(height: 15),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                      ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Đăng ký',  style: TextStyle(fontSize: 18, color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}