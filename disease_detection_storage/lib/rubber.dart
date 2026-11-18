
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;

// class Rubber extends StatefulWidget {
//   const Rubber({super.key});

//   @override
//   State<Rubber> createState() => _RubberState();
// }

// class _RubberState extends State<Rubber> {
//   Interpreter? _interpreter;
//   List<String> _labels = [];

//   Uint8List? _selectedImage;

//   String _prediction = '';
//   double _confidence = 0.0;

//   static const int imageSize = 256; // MUST match training

//   // ================= INIT =================
//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//   }

//   @override
//   void dispose() {
//     _interpreter?.close();
//     super.dispose();
//   }

//   // ================= LOAD MODEL =================
//   Future<void> _loadModel() async {
//     _interpreter =
//         await Interpreter.fromAsset('assets/rubber_model.tflite');

//     print("Input Shape: ${_interpreter!.getInputTensor(0).shape}");
//     print("Output Shape: ${_interpreter!.getOutputTensor(0).shape}");

//     final labelsData =
//         await rootBundle.loadString('assets/rubber_labels.txt');
//     _labels = LineSplitter.split(labelsData).toList();

//     setState(() {});
//   }

//   // ================= IMAGE PICK =================
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final XFile? picked = await picker.pickImage(source: source);
//     if (picked == null) return;

//     final bytes = await File(picked.path).readAsBytes();

//     setState(() {
//       _selectedImage = bytes;
//       _prediction = '';
//       _confidence = 0.0;
//     });

//     await _predict(bytes);
//   }

//   // ================= IMAGE → TENSOR =================
// Float32List _imageToTensor(img.Image image) {
//   final Float32List buffer =
//       Float32List(imageSize * imageSize * 3);

//   int index = 0;

//   for (int y = 0; y < imageSize; y++) {
//     for (int x = 0; x < imageSize; x++) {
//       final pixel = image.getPixel(x, y);

//       // 🔥 DO NOT NORMALIZE
//       buffer[index++] = pixel.r.toDouble();
//       buffer[index++] = pixel.g.toDouble();
//       buffer[index++] = pixel.b.toDouble();
//     }
//   }

//   return buffer;
// }
//   // ================= PREDICTION =================
//   Future<void> _predict(Uint8List imageBytes) async {
//   if (_interpreter == null) return;

//   final img.Image? decoded = img.decodeImage(imageBytes);
//   if (decoded == null) return;

//   final img.Image resized =
//       img.copyResize(decoded, width: imageSize, height: imageSize);

//   final input = _imageToTensor(resized);
//   final inputTensor = input.reshape([1, imageSize, imageSize, 3]);

//   // ✅ CORRECT OUTPUT SHAPE [1, 7]
//   final output = List.generate(
//     1,
//     (_) => List.filled(_labels.length, 0.0),
//   );

//   _interpreter!.run(inputTensor, output);

//   print("Raw output: ${output[0]}");

//   double bestScore = output[0][0];
//   int bestIndex = 0;

//   for (int i = 1; i < output[0].length; i++) {
//     if (output[0][i] > bestScore) {
//       bestScore = output[0][i];
//       bestIndex = i;
//     }
//   }

//   setState(() {
//     _confidence = bestScore * 100;

//     if (bestScore < 0.80) {
//       _prediction = 'Invalid / Try Again';
//     } else {
//       _prediction = _labels[bestIndex];
//     }
//   });
// }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Rubber Disease Detection')),
//       body: Container(
//           decoration: const BoxDecoration(
//     image: DecorationImage(
//       image: AssetImage('images/background.jpg'),
//       fit: BoxFit.cover,
//     ),
//   ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: _selectedImage == null
//                     ? const Center(child: Text('No Image Selected'))
//                     : Image.memory(
//                         _selectedImage!,
//                         fit: BoxFit.contain,
//                       ),
//               ),
        
//               const SizedBox(height: 20),
        
//               Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Prediction',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         _prediction,
//                         style: const TextStyle(fontSize: 18),
//                       ),
//                       const Divider(height: 24),
//                       const Text(
//                         'Confidence',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         _confidence == 0
//                             ? '--'
//                             : '${_confidence.toStringAsFixed(2)} %',
//                         style: const TextStyle(fontSize: 18),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
        
//               const SizedBox(height: 20),
        
//               Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () =>
//                         _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('Camera'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () =>
//                         _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text('Gallery'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



















// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;

// class Rubber extends StatefulWidget {
//   const Rubber({super.key});

//   @override
//   State<Rubber> createState() => _RubberState();
// }

// class _RubberState extends State<Rubber> {
//   Interpreter? _interpreter;
//   List<String> _labels = [];

//   Uint8List? _selectedImage;

//   String _prediction = '';
//   double _confidence = 0.0;

//   static const int imageSize = 256; // MUST match training

//   // ================= INIT =================
//   @override
//   void initState() {
//     super.initState();
//     _loadModel();
//   }

//   @override
//   void dispose() {
//     _interpreter?.close();
//     super.dispose();
//   }

//   // ================= LOAD MODEL =================
//   Future<void> _loadModel() async {
//     _interpreter =
//         await Interpreter.fromAsset('assets/rubber_model.tflite');

//     print("Input Shape: ${_interpreter!.getInputTensor(0).shape}");
//     print("Output Shape: ${_interpreter!.getOutputTensor(0).shape}");

//     final labelsData =
//         await rootBundle.loadString('assets/rubber_labels.txt');
//     _labels = LineSplitter.split(labelsData).toList();

//     setState(() {});
//   }

//   // ================= IMAGE PICK =================
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final XFile? picked = await picker.pickImage(source: source);
//     if (picked == null) return;

//     final bytes = await File(picked.path).readAsBytes();

//     setState(() {
//       _selectedImage = bytes;
//       _prediction = '';
//       _confidence = 0.0;
//     });

//     await _predict(bytes);
//   }

//   // ================= IMAGE → TENSOR =================
//   Float32List _imageToTensor(img.Image image) {
//     final Float32List buffer =
//         Float32List(imageSize * imageSize * 3);

//     int index = 0;

//     for (int y = 0; y < imageSize; y++) {
//       for (int x = 0; x < imageSize; x++) {
//         final pixel = image.getPixel(x, y);

//         // 🔥 RAW PIXEL VALUES (0–255) — matches training
//         buffer[index++] = pixel.r.toDouble();
//         buffer[index++] = pixel.g.toDouble();
//         buffer[index++] = pixel.b.toDouble();
//       }
//     }

//     return buffer;
//   }

//   // ================= PREDICTION =================
//   Future<void> _predict(Uint8List imageBytes) async {
//     if (_interpreter == null) return;

//     final img.Image? decoded = img.decodeImage(imageBytes);
//     if (decoded == null) return;

//     final img.Image resized =
//         img.copyResize(decoded, width: imageSize, height: imageSize);

//     final input = _imageToTensor(resized);
//     final inputTensor = input.reshape([1, imageSize, imageSize, 3]);

//     final output = List.generate(
//       1,
//       (_) => List.filled(_labels.length, 0.0),
//     );

//     _interpreter!.run(inputTensor, output);

//     print("Raw output: ${output[0]}");

//     double bestScore = output[0][0];
//     int bestIndex = 0;

//     for (int i = 1; i < output[0].length; i++) {
//       if (output[0][i] > bestScore) {
//         bestScore = output[0][i];
//         bestIndex = i;
//       }
//     }

//     setState(() {
//       _confidence = bestScore * 100;

//       if (_confidence < 80) {
//         _prediction = 'Invalid Image';
//       } else {
//         _prediction = _labels[bestIndex];
//       }
//     });
//   }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Rubber Disease Detection',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color.fromARGB(255, 5, 100, 8),
//       ),
//       body: Stack(
//         children: [
//           // FULL SCREEN BACKGROUND
//           Positioned.fill(
//             child: Image.asset(
//               'images/background.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),

//           // LIGHT OVERLAY FOR READABILITY
//           Positioned.fill(
//             child: Container(
//               color: Colors.white.withOpacity(0.15),
//             ),
//           ),

//           // MAIN CONTENT
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),

//                 // IMAGE DISPLAY
//                 Container(
//                   width: double.infinity,
//                   height: 300,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: _selectedImage == null
//                       ? const Center(
//                           child: Text(
//                             'No Image Selected',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         )
//                       : Image.memory(
//                           _selectedImage!,
//                           fit: BoxFit.contain,
//                         ),
//                 ),

//                 const SizedBox(height: 25),

//                 // RESULT CARD
//                 Card(
//                   elevation: 8,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16)),
//                   color: Colors.white.withOpacity(0.95),
//                   child: Padding(
//                     padding: const EdgeInsets.all(18),
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Prediction',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           _prediction,
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                         const Divider(height: 30),
//                         const Text(
//                           'Confidence',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           _confidence == 0
//                               ? '--'
//                               : '${_confidence.toStringAsFixed(2)} %',
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // BUTTONS
//                 Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () =>
//                           _pickImage(ImageSource.camera),
//                       icon: const Icon(Icons.camera_alt),
//                       label: const Text('Camera'),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () =>
//                           _pickImage(ImageSource.gallery),
//                       icon: const Icon(Icons.photo),
//                       label: const Text('Gallery'),
//                     ),
//                   ],
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


//  code for apk without inference time

// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:convert';

// import 'package:disease_detection_storage/reg_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// import 'manual_report.dart';

// class Rubber extends StatefulWidget {
//   const Rubber({super.key});

//   @override
//   State<Rubber> createState() => _RubberState();
// }

// class _RubberState extends State<Rubber> {

//   Interpreter? _interpreter;
//   List<String> _labels = [];

//   Uint8List? _selectedImage;

//   String _prediction = "";
//   double _confidence = 0;

//   String locationText = "Location not fetched";

//   double? latitude;
//   double? longitude;

//   bool _isPredicting = false;
//   bool _isUploading = false;

//   final commentController = TextEditingController();

//   static const int imageSize = 256;

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   @override
//   void dispose() {
//     _interpreter?.close();
//     super.dispose();
//   }

//   Future<void> loadModel() async {

//     _interpreter =
//         await Interpreter.fromAsset('assets/rubber_model.tflite');

//     final labelsData =
//         await rootBundle.loadString('assets/rubber_labels.txt');

//     _labels = LineSplitter.split(labelsData).toList();
//   }

//   Future<void> pickImage(ImageSource source) async {

//     final picker = ImagePicker();

//     final XFile? picked =
//         await picker.pickImage(source: source);

//     if (picked == null) return;

//     final bytes = await File(picked.path).readAsBytes();

//     setState(() {
//       _selectedImage = bytes;
//       _prediction = "";
//       _confidence = 0;
//     });

//     await predict(bytes);
//   }

//   Float32List imageToTensor(img.Image image) {

//     final Float32List buffer =
//         Float32List(imageSize * imageSize * 3);

//     int index = 0;

//     for (int y = 0; y < imageSize; y++) {
//       for (int x = 0; x < imageSize; x++) {

//         final pixel = image.getPixel(x, y);

//         buffer[index++] = pixel.r.toDouble();
//         buffer[index++] = pixel.g.toDouble();
//         buffer[index++] = pixel.b.toDouble();

//       }
//     }

//     return buffer;
//   }

//   Future<void> predict(Uint8List imageBytes) async {

//     setState(() {
//       _isPredicting = true;
//     });

//     final decoded = img.decodeImage(imageBytes);

//     if (decoded == null) return;

//     final resized =
//         img.copyResize(decoded, width: imageSize, height: imageSize);

//     final input = imageToTensor(resized);

//     final inputTensor = input.reshape([1, imageSize, imageSize, 3]);

//     final output =
//         List.generate(1, (_) => List.filled(_labels.length, 0.0));

//     _interpreter!.run(inputTensor, output);

//     double bestScore = output[0][0];
//     int bestIndex = 0;

//     for (int i = 1; i < output[0].length; i++) {

//       if (output[0][i] > bestScore) {
//         bestScore = output[0][i];
//         bestIndex = i;
//       }
//     }

//     setState(() {

//       _confidence = bestScore * 100;

//       if (_confidence < 80) {
//         _prediction = "Invalid Image";
//       } else {
//         _prediction = _labels[bestIndex];
//       }

//       _isPredicting = false;
//     });
//   }

//   Future<void> getLocation() async {

//     try {

//       Position position =
//           await Geolocator.getCurrentPosition(
//               desiredAccuracy: LocationAccuracy.high);

//       latitude = position.latitude;
//       longitude = position.longitude;

//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(latitude!, longitude!);

//       Placemark place = placemarks.first;

//       setState(() {

//         locationText =
//             "${place.locality}, ${place.administrativeArea}, ${place.country}";

//       });

//     } catch (e) {

//       showMessage("Location error: $e");

//     }
//   }

//   Future<void> sendReport() async {

//     if (_selectedImage == null) {
//       showMessage("Please capture image first");
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     try {

//       final String base64Image = base64Encode(_selectedImage!);

//       await FirebaseFirestore.instance
//           .collection("detections")
//           .add({

//         "crop": "Rubber",
//         "disease": _prediction,
//         "confidence": _confidence,
//         "location": locationText,
//         "latitude": latitude,
//         "longitude": longitude,
//         "comment": commentController.text.isEmpty
//             ? null
//             : commentController.text,
//         "image_base64": base64Image,
//         "timestamp": FieldValue.serverTimestamp(),

//       });

//       showMessage("Report sent successfully");

//       commentController.clear();

//     } catch (e) {

//       showMessage("Upload failed: $e");

//     }

//     setState(() {
//       _isUploading = false;
//     });
//   }

//   void showMessage(String message) {

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   Widget cardTitle(String text) {

//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(
//         title: const Text("Rubber Disease Detection"),
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

//             child: Column(

//               children: [

//                 Card(
//                   elevation: 8,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(

//                       children: [

//                         cardTitle("Leaf Image Capture"),

//                         const SizedBox(height: 10),

//                         Container(
//                           height: 260,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.green,width: 2),
//                             color: Colors.grey[200],
//                           ),
//                           child: _selectedImage == null
//                               ? const Center(
//                                   child: Text("Capture Rubber Leaf Image"),
//                                 )
//                               : ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.memory(
//                                     _selectedImage!,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                         ),

//                         const SizedBox(height: 10),

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceEvenly,
//                           children: [

//                             ElevatedButton.icon(
//                               onPressed: () =>
//                                   pickImage(ImageSource.camera),
//                               icon: const Icon(Icons.camera),
//                               label: const Text("Camera"),
//                             ),

//                             ElevatedButton.icon(
//                               onPressed: () =>
//                                   pickImage(ImageSource.gallery),
//                               icon: const Icon(Icons.photo),
//                               label: const Text("Gallery"),
//                             ),

//                           ],
//                         ),

//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Card(
//                   elevation: 8,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(

//                       children: [

//                         cardTitle("AI Diagnosis"),

//                         const SizedBox(height: 10),

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: [

//                             const Text("Disease"),

//                             Text(_prediction,
//                                 style: const TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold)),

//                           ],
//                         ),

//                         const Divider(),

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: [

//                             const Text("Confidence"),

//                             Text("${_confidence.toStringAsFixed(2)} %"),

//                           ],
//                         ),

//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Card(
//                   elevation: 8,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(

//                       children: [

//                         cardTitle("Location"),

//                         ElevatedButton.icon(
//                           onPressed: getLocation,
//                           icon: const Icon(Icons.location_on),
//                           label: const Text("Detect Location"),
//                         ),

//                         const SizedBox(height: 10),

//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(locationText),
//                         ),

//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 Card(
//                   elevation: 8,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(

//                       crossAxisAlignment: CrossAxisAlignment.start,

//                       children: [

//                         cardTitle("User Feedback (Optional)"),

//                         const SizedBox(height: 10),

//                         TextField(
//                           controller: commentController,
//                           maxLines: 4,
//                           decoration: const InputDecoration(
//                             hintText: "Describe symptoms...",
//                             border: OutlineInputBorder(),
//                           ),
//                         ),

//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 14),
//                   ),
//                   onPressed: sendReport,
//                   icon: const Icon(Icons.send),
//                   label: const Text("Send Result to Research Server"),
//                 ),

//                 const SizedBox(height: 10),

//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                   ),
//                  onPressed:  () {

//   final user = FirebaseAuth.instance.currentUser;

//   if (user != null) {

//     /// User already logged in
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const ManualReportScreen(),
//       ),
//     );

//   } else {

//     /// User not logged in → go to register/login
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const RegisterScreen(),
//       ),
//     );

//   }

// },
//                   icon: const Icon(Icons.chat),
//                   label: const Text("Send us aReport"),
//                 ),

//               ],
//             ),
//           ),

//           if (_isPredicting)
//             const Center(child: CircularProgressIndicator()),

//           if (_isUploading)
//             const Center(child: CircularProgressIndicator()),

//         ],
//       ),
//     );
//   }
// }



// code with inference time 


import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:disease_detection_storage/reg_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'manual_report.dart';

class Rubber extends StatefulWidget {
  const Rubber({super.key});

  @override
  State<Rubber> createState() => _RubberState();
}

class _RubberState extends State<Rubber> {

  Interpreter? _interpreter;
  List<String> _labels = [];

  Uint8List? _selectedImage;

  String _prediction = "";
  double _confidence = 0;

  String locationText = "Location not fetched";

  double? latitude;
  double? longitude;

  bool _isPredicting = false;
  bool _isUploading = false;

  final commentController = TextEditingController();

  static const int imageSize = 256;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/rubber_model.tflite');

    final labelsData = await rootBundle.loadString('assets/rubber_labels.txt');
    _labels = LineSplitter.split(labelsData).toList();
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);

    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();

    setState(() {
      _selectedImage = bytes;
      _prediction = "";
      _confidence = 0;
    });

    await predict(bytes);
  }

  Float32List imageToTensor(img.Image image) {
    final Float32List buffer = Float32List(imageSize * imageSize * 3);
    int index = 0;

    for (int y = 0; y < imageSize; y++) {
      for (int x = 0; x < imageSize; x++) {
        final pixel = image.getPixel(x, y);
        buffer[index++] = pixel.r.toDouble();
        buffer[index++] = pixel.g.toDouble();
        buffer[index++] = pixel.b.toDouble();
      }
    }
    return buffer;
  }

  Future<void> predict(Uint8List imageBytes) async {
    setState(() {
      _isPredicting = true;
    });

    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      setState(() {
        _isPredicting = false;
      });
      return;
    }

    final resized = img.copyResize(decoded, width: imageSize, height: imageSize);
    final input = imageToTensor(resized);
    final inputTensor = input.reshape([1, imageSize, imageSize, 3]);

    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    // ====================== INFERENCE TIME MEASUREMENT ======================
    final stopwatch = Stopwatch()..start();

    _interpreter!.run(inputTensor, output);

    stopwatch.stop();
    final inferenceTimeMs = stopwatch.elapsedMilliseconds;
    // ========================================================================

    print("Inference Time: $inferenceTimeMs ms");

    double bestScore = output[0][0];
    int bestIndex = 0;

    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > bestScore) {
        bestScore = output[0][i];
        bestIndex = i;
      }
    }

    setState(() {
      _confidence = bestScore * 100;

      if (_confidence < 80) {
        _prediction = "Invalid Image  ($inferenceTimeMs ms)";
      } else {
        _prediction = "${_labels[bestIndex]}  ($inferenceTimeMs ms)";
      }

      _isPredicting = false;
    });
  }

  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showMessage("Please enable Location / GPS");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showMessage("Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showMessage("Location permission permanently denied. Please enable it from Settings.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);
      Placemark place = placemarks.first;

      setState(() {
        locationText = "${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}";
      });
    } catch (e) {
      showMessage("Location error: $e");
      print("Location Error: $e");
    }
  }

  Future<void> sendReport() async {
    if (_selectedImage == null) {
      showMessage("Please capture image first");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final String base64Image = base64Encode(_selectedImage!);

      await FirebaseFirestore.instance.collection("detections").add({
        "crop": "Rubber",
        "disease": _prediction,
        "confidence": _confidence,
        "location": locationText,
        "latitude": latitude,
        "longitude": longitude,
        "comment": commentController.text.isEmpty ? null : commentController.text,
        "image_base64": base64Image,
        "timestamp": FieldValue.serverTimestamp(),
      });

      showMessage("Report sent successfully");
      commentController.clear();
    } catch (e) {
      showMessage("Upload failed: $e");
    }

    setState(() {
      _isUploading = false;
    });
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget cardTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rubber Disease Detection"),
        backgroundColor: const Color.fromARGB(255, 5, 100, 8),
      ),
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
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        cardTitle("Leaf Image Capture"),
                        const SizedBox(height: 10),
                        Container(
                          height: 260,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green, width: 2),
                            color: Colors.grey[200],
                          ),
                          child: _selectedImage == null
                              ? const Center(child: Text("Capture Rubber Leaf Image"))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera),
                              label: const Text("Camera"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo),
                              label: const Text("Gallery"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        cardTitle("AI Diagnosis"),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Disease"),
                            Text(
                              _prediction,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Confidence"),
                            Text("${_confidence.toStringAsFixed(2)} %"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        cardTitle("Location"),
                        ElevatedButton.icon(
                          onPressed: getLocation,
                          icon: const Icon(Icons.location_on),
                          label: const Text("Detect Location"),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(locationText),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cardTitle("User Feedback (Optional)"),
                        const SizedBox(height: 10),
                        TextField(
                          controller: commentController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Describe symptoms...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  onPressed: sendReport,
                  icon: const Icon(Icons.send),
                  label: const Text("Send Result to Research Server"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManualReportScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text("Send us a Report"),
                ),
              ],
            ),
          ),
          if (_isPredicting) const Center(child: CircularProgressIndicator()),
          if (_isUploading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}