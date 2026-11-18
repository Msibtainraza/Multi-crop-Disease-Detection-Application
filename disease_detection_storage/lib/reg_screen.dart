// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'manual_report.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {

//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final instituteController = TextEditingController();
//   final countryController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   String profession = "Student";

//   bool isLogin = false;

//   void showMessage(String msg) {

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }

//   Future<void> registerUser() async {

//     try {

//       UserCredential user =
//           await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(
//                   email: emailController.text,
//                   password: passwordController.text);

//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user.user!.uid)
//           .set({

//         "first_name": firstNameController.text,
//         "last_name": lastNameController.text,
//         "profession": profession,
//         "institute": instituteController.text,
//         "country": countryController.text,
//         "email": emailController.text,
//         "timestamp": FieldValue.serverTimestamp()

//       });

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const ManualReportScreen(),
//         ),
//       );

//     } catch (e) {

//       showMessage(e.toString());

//     }
//   }

//   Future<void> loginUser() async {

//     try {

//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//               email: emailController.text,
//               password: passwordController.text);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const ManualReportScreen(),
//         ),
//       );

//     } catch (e) {

//       showMessage(e.toString());

//     }
//   }

//   Widget buildField(TextEditingController controller, String label) {

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(
//         title: Text(isLogin ? "Login" : "Register"),
//         backgroundColor: const Color.fromARGB(255, 5, 100, 8),
//       ),

//       body: Stack(

//         children: [

//           Positioned.fill(
//             child: Image.asset(
//               "images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),

//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.25),
//             ),
//           ),

//           SingleChildScrollView(

//             padding: const EdgeInsets.all(16),

//             child: Card(

//               elevation: 8,

//               child: Padding(

//                 padding: const EdgeInsets.all(16),

//                 child: Column(

//                   children: [

//                     if (!isLogin) ...[

//                       buildField(firstNameController, "First Name"),
//                       buildField(lastNameController, "Last Name"),
//                       buildField(instituteController, "Institute"),
//                       buildField(countryController, "Country"),

//                       const SizedBox(height: 10),

//                       DropdownButtonFormField(

//                         value: profession,

//                         decoration: const InputDecoration(
//                           labelText: "Profession",
//                           border: OutlineInputBorder(),
//                         ),

//                         items: const [

//                           DropdownMenuItem(
//                               value: "Student",
//                               child: Text("Student")),

//                           DropdownMenuItem(
//                               value: "Farmer",
//                               child: Text("Farmer")),

//                           DropdownMenuItem(
//                               value: "Researcher",
//                               child: Text("Researcher")),

//                           DropdownMenuItem(
//                               value: "Other",
//                               child: Text("Other")),

//                         ],

//                         onChanged: (value) {

//                           setState(() {
//                             profession = value.toString();
//                           });

//                         },

//                       ),

//                       const SizedBox(height: 10),

//                     ],

//                     buildField(emailController, "Email"),

//                     TextField(
//                       controller: passwordController,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: "Password",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     ElevatedButton(
//                       onPressed:
//                           isLogin ? loginUser : registerUser,
//                       child: Text(isLogin ? "Login" : "Register"),
//                     ),

//                     TextButton(

//                       onPressed: () {

//                         setState(() {
//                           isLogin = !isLogin;
//                         });

//                       },

//                       child: Text(isLogin
//                           ? "Create account"
//                           : "Already have account? Login"),

//                     )

//                   ],
//                 ),
//               ),
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }









// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'manual_report.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {

//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final institute = TextEditingController();
//   final country = TextEditingController();
//   final email = TextEditingController();
//   final password = TextEditingController();

//   String profession = "Student";

//   bool isLogin = false;

//   void showMessage(String msg){
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }

//   Future<void> registerUser() async {

//     try {

//       UserCredential user =
//           await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(
//               email: email.text,
//               password: password.text);

//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user.user!.uid)
//           .set({

//         "first_name": firstName.text,
//         "last_name": lastName.text,
//         "profession": profession,
//         "institute": institute.text,
//         "country": country.text,
//         "email": email.text

//       });

//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (_) => const ManualReportScreen()));

//     } catch(e){
//       showMessage(e.toString());
//     }
//   }

//   Future<void> loginUser() async {

//     try {

//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email.text,
//           password: password.text);

//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (_) => const ManualReportScreen()));

//     } catch(e){
//       showMessage(e.toString());
//     }
//   }

//   Widget field(TextEditingController c,String label){

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical:8),
//       child: TextField(
//         controller: c,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.white),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.green),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context){

//     return Scaffold(

//       appBar: AppBar(
//         title: Text(isLogin ? "User Login" : "User Registration"),
//         backgroundColor: const Color.fromARGB(255,5,100,8),
//       ),

//       body: Stack(

//         children: [

//           Positioned.fill(
//             child: Image.asset(
//               "images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),

//           Positioned.fill(
//             child: Container(color: Colors.black.withOpacity(0.4)),
//           ),

//           SingleChildScrollView(

//             padding: const EdgeInsets.all(20),

//             child: Column(

//               children: [

//                if(!isLogin)...[

//                   field(firstName,"First Name"),
//                   field(lastName,"Last Name"),
//                   field(institute,"Institute"),
//                   field(country,"Country"),

//                   DropdownButtonFormField(

//                     dropdownColor: Colors.black87,
//                     value: profession,

//                     style: const TextStyle(color: Colors.white),

//                     decoration: const InputDecoration(
//                       labelText: "Profession",
//                       labelStyle: TextStyle(color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                     ),

//                     items: const [

//                       DropdownMenuItem(
//                           value:"Student",
//                           child:Text("Student")),

//                       DropdownMenuItem(
//                           value:"Farmer",
//                           child:Text("Farmer")),

//                       DropdownMenuItem(
//                           value:"Researcher",
//                           child:Text("Researcher")),

//                       DropdownMenuItem(
//                           value:"Other",
//                           child:Text("Other"))

//                     ],

//                     onChanged:(v){
//                       setState(()=>profession=v.toString());
//                     },

//                   ),

//                 ],

//                 field(email,"Email"),

//                 field(password,"Password"),

//                 const SizedBox(height:20),

//                 ElevatedButton(
//                   onPressed: isLogin?loginUser:registerUser,
//                   child: Text(isLogin?"Login":"Register"),
//                 ),

//                 TextButton(

//                   onPressed:(){
//                     setState(()=>isLogin=!isLogin);
//                   },

//                   child: Text(
//                     isLogin?
//                     "Create new account":
//                     "Already have account? Login",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 )


//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

















// old code

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'manual_report.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {

//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final institute = TextEditingController();
//   final country = TextEditingController();
//   final email = TextEditingController();
//   final password = TextEditingController();

//   String profession = "Student";
//   bool isLogin = false;

//   void showMessage(String msg) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }

//   /// REGISTER USER
//   Future<void> registerUser() async {
//     try {

//       UserCredential user =
//           await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(
//               email: email.text,
//               password: password.text);

//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user.user!.uid)
//           .set({

//         "first_name": firstName.text,
//         "last_name": lastName.text,
//         "profession": profession,
//         "institute": institute.text,
//         "country": country.text,
//         "email": email.text

//       });

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (_) => const ManualReportScreen()),
//       );

//     } catch (e) {
//       showMessage(e.toString());
//     }
//   }

//   /// LOGIN USER
//   Future<void> loginUser() async {
//     try {

//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email.text,
//           password: password.text);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (_) => const ManualReportScreen()),
//       );

//     } catch (e) {
//       showMessage(e.toString());
//     }
//   }

//   /// RESET PASSWORD
//   Future<void> resetPassword() async {

//     if (email.text.isEmpty) {
//       showMessage("Enter your email first");
//       return;
//     }

//     try {

//       await FirebaseAuth.instance
//           .sendPasswordResetEmail(email: email.text);

//       showMessage("Password reset email sent");

//     } catch (e) {

//       showMessage(e.toString());

//     }
//   }

//   /// TEXT FIELD
//   Widget field(TextEditingController c, String label,
//       {bool passwordField = false}) {

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),

//       child: TextField(

//         controller: c,

//         obscureText: passwordField,

//         style: const TextStyle(color: Colors.white),

//         decoration: InputDecoration(

//           labelText: label,

//           labelStyle: const TextStyle(color: Colors.white),

//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),

//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.green),
//           ),

//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(
//         title: Text(isLogin ? "User Login" : "User Registration"),
//         backgroundColor: const Color.fromARGB(255, 5, 100, 8),
//       ),

//       body: Stack(

//         children: [

//           /// FULL BACKGROUND IMAGE
//           Positioned.fill(
//             child: Image.asset(
//               "images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),

//           /// DARK OVERLAY
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.5),
//             ),
//           ),

//           /// FORM
//           SingleChildScrollView(

//             padding: const EdgeInsets.all(20),

//             child: Column(

//               children: [

//                 if (!isLogin) ...[

//                   field(firstName, "First Name"),
//                   field(lastName, "Last Name"),
//                   field(institute, "Institute"),
//                   field(country, "Country"),

//                   DropdownButtonFormField(

//                     dropdownColor: Colors.black87,
//                     value: profession,

//                     style: const TextStyle(color: Colors.white),

//                     decoration: const InputDecoration(
//                       labelText: "Profession",
//                       labelStyle: TextStyle(color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                     ),

//                     items: const [

//                       DropdownMenuItem(
//                           value: "Student",
//                           child: Text("Student")),

//                       DropdownMenuItem(
//                           value: "Farmer",
//                           child: Text("Farmer")),

//                       DropdownMenuItem(
//                           value: "Researcher",
//                           child: Text("Researcher")),

//                       DropdownMenuItem(
//                           value: "Other",
//                           child: Text("Other")),

//                     ],

//                     onChanged: (v) {
//                       setState(() => profession = v.toString());
//                     },

//                   ),

//                   const SizedBox(height: 10),
//                 ],

//                 field(email, "Email"),

//                 field(password, "Password", passwordField: true),

//                 /// FORGOT PASSWORD
//                 if (isLogin)
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: resetPassword,
//                       child: const Text(
//                         "Forgot Password?",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),

//                 const SizedBox(height: 20),

//                 /// LOGIN / REGISTER BUTTON
//                 SizedBox(
//                   width: double.infinity,

//                   child: ElevatedButton(

//                     style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: Colors.green),

//                     onPressed: isLogin ? loginUser : registerUser,

//                     child: Text(
//                       isLogin ? "Login" : "Register",
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 /// SWITCH LOGIN/REGISTER
//                 TextButton(

//                   onPressed: () {
//                     setState(() => isLogin = !isLogin);
//                   },

//                   child: Text(
//                     isLogin
//                         ? "Create new account"
//                         : "Already have account? Login",

//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }










// code
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'manual_report.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {

//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final institute = TextEditingController();
//   final country = TextEditingController();
//   final email = TextEditingController();
//   final password = TextEditingController();

//   String profession = "Student";
//   bool isLogin = false;

//   @override
//   void initState() {
//     super.initState();
//     checkUser();
//   }

//   /// CHECK IF USER ALREADY LOGGED IN
//   void checkUser() {

//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {

//       Future.microtask(() {

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const ManualReportScreen(),
//           ),
//         );

//       });

//     }
//   }

//   /// SHOW MESSAGE
//   void showMessage(String msg) {

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));

//   }

//   /// REGISTER USER
//   Future<void> registerUser() async {

//     try {

//       UserCredential userCredential =
//           await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(
//         email: email.text.trim(),
//         password: password.text.trim(),
//       );

//       User? user = userCredential.user;

//       /// SAVE USER PROFILE
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user!.uid)
//           .set({

//         "first_name": firstName.text,
//         "last_name": lastName.text,
//         "profession": profession,
//         "institute": institute.text,
//         "country": country.text,
//         "email": email.text,
//         "created_at": FieldValue.serverTimestamp()

//       });

//       /// SEND EMAIL VERIFICATION
//       await user.sendEmailVerification();

//       showMessage(
//         "User registered. Please verify your email and check spam folder."
//       );

//       await FirebaseAuth.instance.signOut();

//       setState(() {
//         isLogin = true;
//       });

//     } on FirebaseAuthException catch (e) {

//       String message = "";

//       if (e.code == 'email-already-in-use') {
//         message = "This email is already registered.";
//       }
//       else if (e.code == 'invalid-email') {
//         message = "Invalid email format.";
//       }
//       else if (e.code == 'weak-password') {
//         message = "Password must be at least 6 characters.";
//       }
//       else {
//         message = e.message ?? "Registration failed.";
//       }

//       showMessage(message);

//     }

//   }

//   /// LOGIN USER
//   Future<void> loginUser() async {

//     try {

//       UserCredential userCredential =
//           await FirebaseAuth.instance
//               .signInWithEmailAndPassword(
//         email: email.text.trim(),
//         password: password.text.trim(),
//       );

//       User? user = userCredential.user;

//       await user?.reload();
//       user = FirebaseAuth.instance.currentUser;

//       /// CHECK EMAIL VERIFIED
//       if (user != null && user.emailVerified) {

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const ManualReportScreen(),
//           ),
//         );

//       } else {

//         await FirebaseAuth.instance.signOut();

//         showMessage(
//           "Please verify your email before login. Check spam folder."
//         );

//       }

//     } on FirebaseAuthException catch (e) {

//       String message = "";

//       if (e.code == 'user-not-found') {
//         message = "No user found with this email.";
//       }
//       else if (e.code == 'wrong-password') {
//         message = "Incorrect password.";
//       }
//       else {
//         message = e.message ?? "Login failed.";
//       }

//       showMessage(message);

//     }

//   }

//   /// RESET PASSWORD
//   Future<void> resetPassword() async {

//     if (email.text.trim().isEmpty) {

//       showMessage("Enter your email first");
//       return;

//     }

//     try {

//       await FirebaseAuth.instance.sendPasswordResetEmail(
//         email: email.text.trim(),
//       );

//       showMessage(
//         "Password reset email sent. Please check your inbox or spam folder."
//       );

//     } on FirebaseAuthException catch (e) {

//       String message = "";

//       if (e.code == 'user-not-found') {
//         message = "No user found with this email.";
//       }
//       else if (e.code == 'invalid-email') {
//         message = "Invalid email.";
//       }
//       else {
//         message = e.message ?? "Reset failed.";
//       }

//       showMessage(message);

//     }

//   }

//   /// TEXT FIELD
//   Widget field(TextEditingController c, String label,
//       {bool passwordField = false}) {

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),

//       child: TextField(

//         controller: c,
//         obscureText: passwordField,

//         style: const TextStyle(color: Colors.white),

//         decoration: InputDecoration(

//           labelText: label,

//           labelStyle: const TextStyle(color: Colors.white),

//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),

//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.green),
//           ),

//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(
//         title: Text(isLogin ? "User Login" : "User Registration"),
//         backgroundColor: const Color.fromARGB(255, 5, 100, 8),
//       ),

//       body: Stack(

//         children: [

//           /// BACKGROUND IMAGE
//           Positioned.fill(
//             child: Image.asset(
//               "images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),

//           /// DARK OVERLAY
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.5),
//             ),
//           ),

//           /// FORM
//           SingleChildScrollView(

//             padding: const EdgeInsets.all(20),

//             child: Column(

//               children: [

//                 if (!isLogin) ...[

//                   field(firstName, "First Name"),
//                   field(lastName, "Last Name"),
//                   field(institute, "Institute"),
//                   field(country, "Country"),

//                   DropdownButtonFormField(

//                     dropdownColor: Colors.black87,
//                     value: profession,

//                     style: const TextStyle(color: Colors.white),

//                     decoration: const InputDecoration(
//                       labelText: "Profession",
//                       labelStyle: TextStyle(color: Colors.white),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.white),
//                       ),
//                     ),

//                     items: const [

//                       DropdownMenuItem(
//                           value: "Student",
//                           child: Text("Student")),

//                       DropdownMenuItem(
//                           value: "Farmer",
//                           child: Text("Farmer")),

//                       DropdownMenuItem(
//                           value: "Researcher",
//                           child: Text("Researcher")),

//                       DropdownMenuItem(
//                           value: "Other",
//                           child: Text("Other")),

//                     ],

//                     onChanged: (v) {
//                       setState(() => profession = v.toString());
//                     },

//                   ),

//                   const SizedBox(height: 10),
//                 ],

//                 field(email, "Email"),

//                 field(password, "Password", passwordField: true),

//                 /// FORGOT PASSWORD
//                 if (isLogin)
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: resetPassword,
//                       child: const Text(
//                         "Forgot Password?",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),

//                 const SizedBox(height: 20),

//                 /// LOGIN / REGISTER BUTTON
//                 SizedBox(
//                   width: double.infinity,

//                   child: ElevatedButton(

//                     style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: Colors.green),

//                     onPressed: isLogin ? loginUser : registerUser,

//                     child: Text(
//                       isLogin ? "Login" : "Register",
//                       style: const TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 /// SWITCH LOGIN / REGISTER
//                 TextButton(

//                   onPressed: () {
//                     setState(() => isLogin = !isLogin);
//                   },

//                   child: Text(
//                     isLogin
//                         ? "Create new account"
//                         : "Already have account? Login",

//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//               ],
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manual_report.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final institute = TextEditingController();
  final country = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String profession = "Student";
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  /// CHECK IF USER ALREADY LOGGED IN
  void checkUser() {

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {

      Future.microtask(() {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ManualReportScreen(),
          ),
        );

      });

    }
  }

  /// SHOW MESSAGE
  void showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /// REGISTER USER
  Future<void> registerUser() async {

    try {

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      User? user = userCredential.user;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set({

        "first_name": firstName.text,
        "last_name": lastName.text,
        "profession": profession,
        "institute": institute.text,
        "country": country.text,
        "email": email.text,
        "created_at": FieldValue.serverTimestamp()

      });

      await user.sendEmailVerification();

      showMessage(
          "User registered. Please verify your email and check spam folder.");

      await FirebaseAuth.instance.signOut();

      setState(() {
        isLogin = true;
      });

    } on FirebaseAuthException catch (e) {

      String message = "";

      if (e.code == 'email-already-in-use') {
        message = "This email is already registered.";
      }
      else if (e.code == 'invalid-email') {
        message = "Invalid email format.";
      }
      else if (e.code == 'weak-password') {
        message = "Password must be at least 6 characters.";
      }
      else {
        message = e.message ?? "Registration failed.";
      }

      showMessage(message);
    }
  }

  /// LOGIN USER
  Future<void> loginUser() async {

    try {

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      User? user = userCredential.user;

      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ManualReportScreen(),
          ),
        );

      } else {

        await FirebaseAuth.instance.signOut();

        showMessage(
            "Please verify your email before login. Check spam folder.");

      }

    } on FirebaseAuthException catch (e) {

      String message = "";

      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      }
      else if (e.code == 'wrong-password') {
        message = "Incorrect password.";
      }
      else {
        message = e.message ?? "Login failed.";
      }

      showMessage(message);
    }
  }

  /// RESET PASSWORD
  Future<void> resetPassword() async {

    if (email.text.trim().isEmpty) {
      showMessage("Enter your email first");
      return;
    }

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.text.trim(),
      );

      showMessage(
          "Password reset email sent. Check inbox or spam folder.");

    } on FirebaseAuthException catch (e) {

      String message = "";

      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      }
      else if (e.code == 'invalid-email') {
        message = "Invalid email.";
      }
      else {
        message = e.message ?? "Reset failed.";
      }

      showMessage(message);
    }
  }

  /// INPUT FIELD
  Widget field(TextEditingController c, String label,
      {bool passwordField = false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: TextField(

        controller: c,
        obscureText: passwordField,

        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(

          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),

          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),

          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(isLogin ? "User Login" : "User Registration"),
        backgroundColor: const Color.fromARGB(255, 5, 100, 8),
      ),

      body: Stack(

        children: [

          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          /// FIXED FULL HEIGHT FORM
          LayoutBuilder(

            builder: (context, constraints) {

              return SingleChildScrollView(

                child: ConstrainedBox(

                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),

                  child: IntrinsicHeight(

                    child: Padding(

                      padding: const EdgeInsets.all(20),

                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          if (!isLogin) ...[

                            field(firstName, "First Name"),
                            field(lastName, "Last Name"),
                            field(institute, "Institute"),
                            field(country, "Country"),

                            DropdownButtonFormField(

                              dropdownColor: Colors.black87,
                              value: profession,

                              style: const TextStyle(color: Colors.white),

                              decoration: const InputDecoration(
                                labelText: "Profession",
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),

                              items: const [

                                DropdownMenuItem(
                                    value: "Student",
                                    child: Text("Student")),

                                DropdownMenuItem(
                                    value: "Farmer",
                                    child: Text("Farmer")),

                                DropdownMenuItem(
                                    value: "Researcher",
                                    child: Text("Researcher")),

                                DropdownMenuItem(
                                    value: "Other",
                                    child: Text("Other")),

                              ],

                              onChanged: (v) {
                                setState(() => profession = v.toString());
                              },

                            ),

                            const SizedBox(height: 10),
                          ],

                          field(email, "Email"),

                          field(password, "Password", passwordField: true),

                          if (isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: resetPassword,
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: Colors.green),

                              onPressed: isLogin ? loginUser : registerUser,

                              child: Text(
                                isLogin ? "Login" : "Register",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          TextButton(

                            onPressed: () {
                              setState(() => isLogin = !isLogin);
                            },

                            child: Text(
                              isLogin
                                  ? "Create new account"
                                  : "Already have account? Login",

                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}