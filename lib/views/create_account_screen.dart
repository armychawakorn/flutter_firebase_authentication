import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_authentication/custom_text_field.dart';

class CreateAccountPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Create Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(color: Colors.white), // สี icon ย้อนกลับ
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // ใช้ Gradient Background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[200]!],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Logo (Optional)
                // Image.asset(
                //   'assets/logo.png',
                //   height: 100,
                // ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // ปรับสี Title
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Email Input Field
                CustomTextField(
                  // ใช้ CustomTextField
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password Input Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                // Confirm Password Input Field
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Create Account Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // สลับสีกับ HomePage
                    foregroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // โค้งมน
                    ),
                  ),
                  onPressed: () {
                    _createAccount(context);
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 20),
                // "Already have an account?" Text
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Already have an account? Sign In',
                    style: TextStyle(color: Colors.white70), // สีอ่อนลง
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _createAccount, _showErrorDialog, _showSuccessDialog เหมือนเดิม (ไม่ต้องแก้)
  void _createAccount(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Basic Validation (เหมือนเดิม)
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog(context, "Please fill in all fields.");
      return;
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _showErrorDialog(context, "Invalid email format.");
      return;
    }

    if (password.length < 6) {
      _showErrorDialog(context, "Password must be at least 6 characters.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog(context, "Passwords do not match.");
      return;
    }

    // Firebase Authentication
    try {
      // 1. Show loading indicator (Optional, but recommended)
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // 2. Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 3. (Optional) Send email verification
      // await userCredential.user!.sendEmailVerification();

      // 4. Hide loading indicator
      Navigator.of(context).pop(); // Pop the loading dialog

      // 5. Show success dialog
      _showSuccessDialog(context);

      // 6. (Optional) Navigate to another screen (e.g., login)
      // Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      // Hide loading indicator (if any)
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Handle Firebase errors
      String errorMessage = "An error occurred."; // Default error message

      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else if (e.code == 'operation-not-allowed') {
        errorMessage =
            "Email/password accounts are not enabled. Enable them in the Firebase console.";
      }
      // Add more error handling as needed

      _showErrorDialog(
          context, errorMessage); // Show the specific error message
    } catch (e) {
      // Hide loading indicator (if any)
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // Handle other errors
      _showErrorDialog(
          context, "An unexpected error occurred: ${e.toString()}");
      print(e); // Log the error for debugging
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text("Account created successfully!"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, '/login'); // Navigate
              },
            ),
          ],
        );
      },
    );
  }
}
