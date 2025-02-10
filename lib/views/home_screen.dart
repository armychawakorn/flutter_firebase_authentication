import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/home'); // ไปหน้า Login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('', style: TextStyle(color: Colors.white)), // สี title
        backgroundColor: Colors.blue[800],
        elevation: 0, // เอา shadow ใต้ AppBar ออก
        actions: [
          if (_user != null)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white), // สี icon
              onPressed: _signOut,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // เพิ่ม Background
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[200]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // เพิ่ม padding รอบๆ content
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_user != null) {
      return _buildLoggedInContent();
    } else {
      return _buildLoggedOutContent();
    }
  }

  Widget _buildLoggedInContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // เพิ่ม Icon
        const Icon(
          Icons.check_circle, // หรือ Icons.verified_user, Icons.account_circle
          color: Colors.white,
          size: 60,
        ),
        const SizedBox(height: 20),
        Text(
          'Welcome, ${_user!.displayName ?? _user!.email ?? "User"}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // สีข้อความ
          ),
          textAlign: TextAlign.center, // จัดให้อยู่ตรงกลาง
        ),
        const SizedBox(height: 40), // เพิ่มระยะห่าง
        ElevatedButton.icon(
          // ใช้ ElevatedButton.icon
          icon: const Icon(Icons.logout, color: Colors.blue),
          label: const Text('Sign Out', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // สีปุ่ม
            foregroundColor: Colors.blue[800], // สีข้อความในปุ่ม
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // ทำให้ปุ่มโค้งมน
            ),
          ),
          onPressed: _signOut,
        ),
      ],
    );
  }

  Widget _buildLoggedOutContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image/Icon (Optional)
        // Image.asset(
        //   'assets/welcome_image.png', // ใส่ path ของรูปภาพ
        //   height: 150,
        // ),
        // หรือ
        const Icon(
          Icons.person,
          color: Colors.white,
          size: 60,
        ),

        const SizedBox(height: 20),
        const Text(
          'Welcome to pingpong show!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please login or create an account to continue.', // เพิ่มข้อความ
          style: TextStyle(fontSize: 16, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue[800],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text('Login', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white), // สีเส้นขอบ
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/create_account');
          },
          child: const Text('Create Account', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
