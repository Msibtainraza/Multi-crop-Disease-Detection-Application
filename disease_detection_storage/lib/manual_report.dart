
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';



import 'package:disease_detection_storage/delete_account.dart';
import 'package:disease_detection_storage/my_report.dart';
import 'package:disease_detection_storage/reg_screen.dart';
import 'package:disease_detection_storage/rice.dart';
import 'package:disease_detection_storage/welcome.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';



class ManualReportScreen extends StatefulWidget {
  const ManualReportScreen({super.key});

  @override
  State<ManualReportScreen> createState() => _ManualReportScreenState();
}

class _ManualReportScreenState extends State<ManualReportScreen> {

  final cropController = TextEditingController();
  final diseaseController = TextEditingController();
  final pathogenController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  List<Uint8List> leafImages = [];
  List<Uint8List> pathogenImages = [];

  double? latitude;
  double? longitude;

  bool uploading = false;

  final picker = ImagePicker();

  void showMessage(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /// LOGOUT
 Future<void> logout() async {

  await FirebaseAuth.instance.signOut();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => Home(),
    ),
    (route) => false,
  );

}

  /// IMAGE COMPRESSION
  Uint8List compressImage(Uint8List bytes) {

    img.Image? image = img.decodeImage(bytes);

    img.Image resized = img.copyResize(image!, width: 512);

    return Uint8List.fromList(
        img.encodeJpg(resized, quality: 85));
  }

  /// PICK LEAF IMAGE
  Future<void> pickLeafImage() async {

    if (leafImages.length >= 3) {
      showMessage("Maximum 3 leaf images allowed");
      return;
    }

    final XFile? picked =
        await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();

    setState(() {
      leafImages.add(bytes);
    });
  }

  /// PICK PATHOGEN IMAGE
  Future<void> pickPathogenImage() async {

    final XFile? picked =
        await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();

    setState(() {
      pathogenImages.add(bytes);
    });
  }

  /// REMOVE IMAGE
  void removeLeafImage(int index) {
    setState(() {
      leafImages.removeAt(index);
    });
  }

  void removePathogenImage(int index) {
    setState(() {
      pathogenImages.removeAt(index);
    });
  }

  /// GET LOCATION
  Future<void> getLocation() async {

    try {

      Position position =
          await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> places =
          await placemarkFromCoordinates(latitude!, longitude!);

      Placemark place = places.first;

      setState(() {

        locationController.text =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";

      });

    } catch (e) {

      showMessage("Location error: $e");

    }
  }

  /// SUBMIT REPORT
  Future<void> submitReport() async {

    if (cropController.text.isEmpty) {
      showMessage("Please enter crop name");
      return;
    }

    if (diseaseController.text.isEmpty) {
      showMessage("Please enter disease name");
      return;
    }

    if (leafImages.isEmpty) {
      showMessage("Please add at least one leaf image");
      return;
    }

    setState(() {
      uploading = true;
    });

    try {

      User user = FirebaseAuth.instance.currentUser!;

      /// COMPRESS + CONVERT TO BASE64
      List<String> leafBase64 =
          leafImages.map((e) =>
              base64Encode(compressImage(e))).toList();

      List<String> pathogenBase64 =
          pathogenImages.map((e) =>
              base64Encode(compressImage(e))).toList();

      await FirebaseFirestore.instance
          .collection("manual_reports")
          .add({

        "user_id": user.uid,
        "email": user.email,

        "crop_name": cropController.text,
        "disease": diseaseController.text,
        "pathogen": pathogenController.text,

        "description": descriptionController.text,

        "location": locationController.text,

        "latitude": latitude ?? 0,
        "longitude": longitude ?? 0,

        "leaf_images": leafBase64,
        "pathogen_images": pathogenBase64,

        "timestamp": FieldValue.serverTimestamp(),
      });

      showMessage("Report submitted successfully");

      clearFields();

    } catch (e) {

      showMessage("Upload failed: $e");

    }

    setState(() {
      uploading = false;
    });
  }

  void clearFields() {

    cropController.clear();
    diseaseController.clear();
    pathogenController.clear();
    descriptionController.clear();
    locationController.clear();

    setState(() {

      leafImages.clear();
      pathogenImages.clear();

    });
  }

  Widget sectionTitle(String text) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [

          const Icon(Icons.science, color: Colors.green),

          const SizedBox(width: 8),

          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE PREVIEW GRID
  Widget imagePreview(List<Uint8List> images, bool isLeaf) {

    return Wrap(
      spacing: 10,
      children: List.generate(images.length, (index) {

        return Stack(
          children: [

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              right: 0,
              child: GestureDetector(

                onTap: () {

                  if (isLeaf) {
                    removeLeafImage(index);
                  } else {
                    removePathogenImage(index);
                  }

                },

                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        );

      }),
    );
  }

  Widget buildDrawer() {

  User? user = FirebaseAuth.instance.currentUser;

  return Drawer(

    child: Column(

      children: [

        UserAccountsDrawerHeader(

          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 5, 100, 8),
          ),

          accountName: const Text("Disease Detection App"),

          accountEmail: Text(user?.email ?? ""),

          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.green),
          ),
        ),

        /// Graphs
        ListTile(

          leading: const Icon(Icons.bar_chart),

          title: const Text("Disease Graphs"),

          onTap: () {

            Navigator.pop(context);

            // Navigate to graph screen later

          },
        ),

        /// Create Report
        ListTile(

          leading: const Icon(Icons.add_circle),

          title: const Text("Create Report"),

          onTap: () {

            Navigator.pop(context);

          },
        ),

        /// My Reports
        ListTile(
  leading: Icon(Icons.history),
  title: Text("My Reports"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => MyReportsScreen()),
    );
  },
),

        const Divider(),
ListTile(
  leading: const Icon(Icons.delete, color: Colors.red),
  title: const Text("Delete Account"),
  onTap: () {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  DeleteAccount(),
      ),
    );

  },
),
        
        /// Logout
        ListTile(

          leading: const Icon(Icons.logout, color: Colors.red),

          title: const Text("Logout"),

          onTap: logout,
        ),

      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     

      appBar: AppBar(
        title: const Text("Manual Disease Report"),
        backgroundColor: const Color.fromARGB(255, 5, 100, 8),

        
      ),
 drawer: buildDrawer(),
      body: Stack(

        children: [

          Positioned.fill(
            child: Image.asset(
              "images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),

          SingleChildScrollView(

            padding: const EdgeInsets.all(16),

            child: Column(

              children: [

                sectionTitle("Disease Information"),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(

                      children: [

                        TextField(
                          controller: cropController,
                          decoration: const InputDecoration(
                            labelText: "Crop Name",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: diseaseController,
                          decoration: const InputDecoration(
                            labelText: "Disease Name",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: pathogenController,
                          decoration: const InputDecoration(
                            labelText: "Causal Pathogen (Optional)",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "Disease Description",
                            border: OutlineInputBorder(),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                sectionTitle("Leaf Images (Max 3)"),

                ElevatedButton.icon(
                  onPressed: pickLeafImage,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text("Add Leaf Image"),
                ),

                const SizedBox(height: 10),

                imagePreview(leafImages, true),

                const SizedBox(height: 20),

                sectionTitle("Pathogen Lab Images (Optional)"),

                ElevatedButton.icon(
                  onPressed: pickPathogenImage,
                  icon: const Icon(Icons.biotech),
                  label: const Text("Add Pathogen Image"),
                ),

                const SizedBox(height: 10),

                imagePreview(pathogenImages, false),

                const SizedBox(height: 20),

                sectionTitle("Location"),

                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: getLocation,
                  icon: const Icon(Icons.location_on),
                  label: const Text("Auto Detect Location"),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                  ),
                  onPressed: submitReport,
                  icon: const Icon(Icons.send),
                  label: const Text(
                    "Submit Report",
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                const SizedBox(height: 40),

              ],
            ),
          ),

          if (uploading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

        ],
      ),
    );
  }
}