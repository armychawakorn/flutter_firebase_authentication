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
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
                const SizedBox(height: 20),

                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

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

  void _createAccount(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

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

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.of(context).pop(); // Pop the loading dialog

      _showSuccessDialog(context);
    } on FirebaseAuthException catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      String errorMessage = "An error occurred.";

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

      _showErrorDialog(context, errorMessage);
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorDialog(
          context, "An unexpected error occurred: ${e.toString()}");
      print(e);
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
