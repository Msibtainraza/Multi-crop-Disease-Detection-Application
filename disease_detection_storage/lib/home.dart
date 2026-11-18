

 import 'package:disease_detection_storage/Signup.dart';
import 'package:disease_detection_storage/welcome.dart';
import 'package:disease_detection_storage/Signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 Future login() async {

  try {

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    User? user = userCredential.user;

    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );

    } else {

      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please verify your email before logging in."),
        ),
      );

    }

  } on FirebaseAuthException catch (e) {

    String message = "";

    if (e.code == 'user-not-found') {
      message = "No user found with this email";
    } 
    else if (e.code == 'wrong-password') {
      message = "Incorrect password";
    } 
    else {
      message = e.message ?? "Login failed";
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

  }

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: login,
              child: const Text("Login"),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );

              },

              child: const Text("Create Account"),
            )

          ],
        ),
      ),
    );
  }
}