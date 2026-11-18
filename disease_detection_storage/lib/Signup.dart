
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  Future signup() async {

    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {

      showMessage("All fields are required");
      return;
    }

    setState(() {
      loading = true;
    });

    try {

      /// Create user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      /// Store user profile in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set({

        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "created_at": DateTime.now()

      });

      /// Send verification email
      await user.sendEmailVerification();

      showMessage(
          "Account created successfully. Please verify your email before login.");

      await FirebaseAuth.instance.signOut();

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showMessage("This email is already registered");
      }
      else if (e.code == 'invalid-email') {
        showMessage("Invalid email format");
      }
      else if (e.code == 'weak-password') {
        showMessage("Password must be at least 6 characters");
      }
      else {
        showMessage(e.message ?? "Signup failed");
      }

    } finally {

      setState(() {
        loading = false;
      });

    }

  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Account"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            children: [

              /// First Name
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              /// Last Name
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              /// Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              /// Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signup,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )

            ],
          ),
        ),
      ),
    );
  }
}