import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import HomeScreen
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController =
      TextEditingController(); // Thêm controller cho tên
  final _phoneController =
      TextEditingController(); // Thêm controller cho số điện thoại
  final _addressController =
      TextEditingController(); // Thêm controller cho địa chỉ.
  bool _isLoading = false; // Biến để hiển thị loading indicator

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose(); // Dispose controller
    _phoneController.dispose(); // Dispose controller
    _addressController.dispose(); // Dispose controller
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Bắt đầu loading
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Thêm thông tin vào Firestore  <-- QUAN TRỌNG
        if (userCredential.user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _nameController.text, // Lưu tên
            'phone': _phoneController.text, // Lưu số điện thoại
            'address': _addressController.text, // Lưu địa chỉ
            'email': _emailController.text
                .trim(), // Nên lưu cả email, dù đã có ở Auth
          });
        }

        // Đăng ký thành công, chuyển hướng đến HomeScreen
        if (mounted) {
          // Check if the widget is still in the tree
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          ScaffoldMessenger.of(context).showSnackBar(
            // Thêm thông báo
            SnackBar(content: Text('Đăng ký thành công')),
          );
        }
      } on FirebaseAuthException catch (e) {
        // ... (xử lý lỗi như cũ) ...
        String errorMessage = "Có lỗi xảy ra, vui lòng thử lại.";
        if (e.code == 'weak-password') {
          errorMessage = 'Mật khẩu quá yếu.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Email đã được sử dụng.';
        } else if (e.code == 'invalid-email') {
          errorMessage = "Email không hợp lệ";
        }
        // Hiển thị thông báo lỗi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Có lỗi xảy ra: $e')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false; // Kết thúc loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController, // Thêm controller
                  decoration: InputDecoration(
                      labelText: 'Họ và tên',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu.';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      labelText: 'Nhập lại mật khẩu',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu.';
                    }
                    if (value != _passwordController.text) {
                      return 'Mật khẩu không khớp.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone)),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại.';
                    }
                    // Bạn có thể thêm kiểm tra định dạng số điện thoại ở đây
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 3, // Cho phép nhập nhiều dòng
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập địa chỉ.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                _isLoading
                    ? CircularProgressIndicator() // Hiển thị loading
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: _register,
                        child: Text('Đăng ký',
                            style: TextStyle(
                                fontSize: 18, color: Colors.white)),
                      ),
                SizedBox(height: 12.0), // Khoảng cách giữa nút và dòng chữ
                Row(
                  // Dùng Row để căn giữa
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Đã có tài khoản? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}