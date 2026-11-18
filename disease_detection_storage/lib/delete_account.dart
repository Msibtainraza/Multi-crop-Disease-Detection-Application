// import 'package:disease_detection_storage/welcome.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DeleteAccount extends StatefulWidget {
//   const DeleteAccount({super.key});

//   @override
//   State<DeleteAccount> createState() => _DeleteAccountState();
// }

// class _DeleteAccountState extends State<DeleteAccount> {

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool loading = false;

//   String reason = "Privacy concerns";

//   void showMessage(String msg) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }

//   /// VERIFY USER EMAIL + PASSWORD
//   Future<void> verifyUser() async {

//     if(emailController.text.isEmpty || passwordController.text.isEmpty){
//       showMessage("Please enter email and password");
//       return;
//     }

//     try {

//       setState(() {
//         loading = true;
//       });

//       User user = FirebaseAuth.instance.currentUser!;

//       AuthCredential credential =
//           EmailAuthProvider.credential(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       await user.reauthenticateWithCredential(credential);

//       setState(() {
//         loading = false;
//       });

//       showWarningDialog();

//     } catch (e) {

//       setState(() {
//         loading = false;
//       });

//       showMessage("Incorrect email or password");
//     }
//   }

//   /// FINAL WARNING DIALOG
//   void showWarningDialog() {

//     showDialog(
//       context: context,
//       builder: (context) {

//         return AlertDialog(

//           title: const Text("Delete Account"),

//           content: const Text(
//               "All your reports, images and data will be permanently deleted. This action cannot be undone."),

//           actions: [

//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),

//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               onPressed: () {

//                 Navigator.pop(context);

//                 deleteAccount();

//               },
//               child: const Text("Delete"),
//             )

//           ],
//         );
//       },
//     );
//   }

//   /// DELETE ACCOUNT FUNCTION
//   Future<void> deleteAccount() async {

//     try {

//       setState(() {
//         loading = true;
//       });

//       User user = FirebaseAuth.instance.currentUser!;

//       /// delete user reports
//       var reports = await FirebaseFirestore.instance
//           .collection("manual_reports")
//           .where("user_id", isEqualTo: user.uid)
//           .get();

//       for (var doc in reports.docs) {
//         await doc.reference.delete();
//       }

//       /// delete user profile
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user.uid)
//           .delete();

//       /// delete firebase auth account
//       await user.delete();

//       setState(() {
//         loading = false;
//       });

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const Home()),
//         (route) => false,
//       );

//     } catch (e) {

//       setState(() {
//         loading = false;
//       });

//       showMessage("Account deletion failed");
//     }
//   }

//   Widget inputField(TextEditingController controller, String label, {bool isPassword=false}) {

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),

//       child: TextField(

//         controller: controller,
//         obscureText: isPassword,

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
//         title: const Text("Delete Account"),
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

//           /// MAIN UI
//           Center(

//             child: Padding(
//               padding: const EdgeInsets.all(20),

//               child: Card(

//                 color: Colors.black54,

//                 child: Padding(
//                   padding: const EdgeInsets.all(20),

//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,

//                     children: [

//                       const Text(
//                         "Delete Your Account",
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(height: 10),

//                       const Text(
//                         "Please tell us why you are leaving",
//                         style: TextStyle(color: Colors.white70),
//                       ),

//                       const SizedBox(height: 15),

//                       DropdownButtonFormField(

//                         dropdownColor: Colors.black87,

//                         value: reason,

//                         style: const TextStyle(color: Colors.white),

//                         decoration: const InputDecoration(
//                           labelText: "Reason",
//                           labelStyle: TextStyle(color: Colors.white),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                         ),

//                         items: const [

//                           DropdownMenuItem(
//                             value: "Privacy concerns",
//                             child: Text("Privacy concerns"),
//                           ),

//                           DropdownMenuItem(
//                             value: "App not useful",
//                             child: Text("App not useful"),
//                           ),

//                           DropdownMenuItem(
//                             value: "Too many bugs",
//                             child: Text("Too many bugs"),
//                           ),

//                           DropdownMenuItem(
//                             value: "Other",
//                             child: Text("Other"),
//                           ),

//                         ],

//                         onChanged: (v){
//                           setState(() {
//                             reason = v.toString();
//                           });
//                         },

//                       ),

//                       const SizedBox(height: 15),

//                       inputField(emailController,"Email"),

//                       inputField(passwordController,"Password", isPassword: true),

//                       const SizedBox(height: 20),

//                       loading
//                           ? const CircularProgressIndicator()

//                           : ElevatedButton(

//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 40, vertical: 14),
//                               ),

//                               onPressed: verifyUser,

//                               child: const Text("Delete Account"),
//                             )

//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:disease_detection_storage/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  String reason = "Privacy concerns";

  void showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /// VERIFY USER
  Future<void> verifyUser() async {

    if(emailController.text.isEmpty || passwordController.text.isEmpty){
      showMessage("Please enter email and password");
      return;
    }

    try {

      setState(() {
        loading = true;
      });

      User user = FirebaseAuth.instance.currentUser!;

      AuthCredential credential =
          EmailAuthProvider.credential(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      setState(() {
        loading = false;
      });

      showWarningDialog();

    } catch (e) {

      setState(() {
        loading = false;
      });

      showMessage("Incorrect email or password");
    }
  }

  /// WARNING DIALOG
  void showWarningDialog() {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Delete Account"),

          content: const Text(
              "All your reports, images and data will be permanently deleted. This action cannot be undone."),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {

                Navigator.pop(context);
                deleteAccount();

              },
              child: const Text("Delete"),
            )

          ],
        );
      },
    );
  }

  /// DELETE ACCOUNT
  Future<void> deleteAccount() async {

    try {

      setState(() {
        loading = true;
      });

      User user = FirebaseAuth.instance.currentUser!;

      /// delete reports
      var reports = await FirebaseFirestore.instance
          .collection("manual_reports")
          .where("user_id", isEqualTo: user.uid)
          .get();

      for (var doc in reports.docs) {
        await doc.reference.delete();
      }

      /// delete user profile
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .delete();

      /// delete auth account
      await user.delete();

      setState(() {
        loading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
        (route) => false,
      );

    } catch (e) {

      setState(() {
        loading = false;
      });

      showMessage("Account deletion failed");
    }
  }

  Widget inputField(TextEditingController controller, String label,
      {bool isPassword=false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: TextField(

        controller: controller,
        obscureText: isPassword,

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
        title: const Text("Delete Account"),
        backgroundColor: const Color.fromARGB(255, 5, 100, 8),
      ),

      body: Stack(

        children: [

          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),

          /// SCROLLABLE UI
          SafeArea(
            child: SingleChildScrollView(

              padding: const EdgeInsets.all(20),

              child: Center(

                child: Container(

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      const Text(
                        "Delete Your Account",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Please tell us why you are leaving",
                        style: TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 15),

                      DropdownButtonFormField(

                        dropdownColor: Colors.black87,

                        value: reason,

                        style: const TextStyle(color: Colors.white),

                        decoration: const InputDecoration(
                          labelText: "Reason",
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),

                        items: const [

                          DropdownMenuItem(
                            value: "Privacy concerns",
                            child: Text("Privacy concerns"),
                          ),

                          DropdownMenuItem(
                            value: "App not useful",
                            child: Text("App not useful"),
                          ),

                          DropdownMenuItem(
                            value: "Too many bugs",
                            child: Text("Too many bugs"),
                          ),

                          DropdownMenuItem(
                            value: "Other",
                            child: Text("Other"),
                          ),

                        ],

                        onChanged: (v){
                          setState(() {
                            reason = v.toString();
                          });
                        },

                      ),

                      const SizedBox(height: 15),

                      inputField(emailController,"Email"),

                      inputField(passwordController,"Password", isPassword: true),

                      const SizedBox(height: 20),

                      loading
                          ? const CircularProgressIndicator()

                          : ElevatedButton(

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                              ),

                              onPressed: verifyUser,

                              child: const Text("Delete Account"),
                            )

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}