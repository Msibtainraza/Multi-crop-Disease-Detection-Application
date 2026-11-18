



// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// import 'manual_report.dart';

// class Rice extends StatefulWidget {
//   const Rice({super.key});

//   @override
//   State<Rice> createState() => _RiceState();
// }

// class _RiceState extends State<Rice> {

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

//   /// INIT
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

//   /// LOAD MODEL
//   Future<void> loadModel() async {

//     _interpreter =
//         await Interpreter.fromAsset('assets/rice_model.tflite');

//     final labelsData =
//         await rootBundle.loadString('assets/rice_labels.txt');

//     _labels = LineSplitter.split(labelsData).toList();
//   }

//   /// IMAGE PICKER (no compression)
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

//   /// IMAGE TO TENSOR
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

//   /// PREDICT
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

//   /// LOCATION
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

//   /// SEND REPORT
//   // Future<void> sendReport() async {

//   //   if (_selectedImage == null) {
//   //     showMessage("Please capture image first");
//   //     return;
//   //   }

//   //   setState(() {
//   //     _isUploading = true;
//   //   });

//   //   try {

//   //     final String base64Image =
//   //         base64Encode(_selectedImage!);

//   //     await FirebaseFirestore.instance
//   //         .collection("detections")
//   //         .add({

//   //       "crop": "Rice",
//   //       "disease": _prediction,
//   //       "confidence": _confidence,
//   //       "location": locationText,
//   //       "image_base64": base64Image,
//   //       "timestamp": FieldValue.serverTimestamp()

//   //     });

//   //     showMessage("Report sent successfully");

//   //   } catch (e) {

//   //     showMessage("Upload failed: $e");
//   //   }

//   //   setState(() {
//   //     _isUploading = false;
//   //   });
//   // }

//   // void showMessage(String message) {

//   //   ScaffoldMessenger.of(context)
//   //       .showSnackBar(SnackBar(content: Text(message)));
//   // }



// Future<void> sendReport() async {

//   if (_selectedImage == null) {
//     showMessage("Please capture image first");
//     return;
//   }

//   setState(() {
//     _isUploading = true;
//   });

//   try {

//     /// encode image (no quality change)
//     final String base64Image = base64Encode(_selectedImage!);

//     await FirebaseFirestore.instance
//         .collection("detections")
//         .add({

//       "crop": "Rice",
//       "disease": _prediction,
//       "confidence": _confidence,

//       /// location text
//       "location": locationText,

//       /// GPS coordinates
//       "latitude": latitude,
//       "longitude": longitude,

//       /// optional comment
//       "comment": commentController.text.isEmpty
//           ? null
//           : commentController.text,

//       /// image
//       "image_base64": base64Image,

//       /// timestamp
//       "timestamp": FieldValue.serverTimestamp(),
//     });

//     showMessage("Report sent successfully");

//     commentController.clear();

//   } catch (e) {

//     showMessage("Upload failed: $e");

//   }

//   setState(() {
//     _isUploading = false;
//   });
// }
// void showMessage(String message) {

//   if (!mounted) return;

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 2),
//     ),
//   );

// }
//   /// SECTION HEADER
//   Widget sectionTitle(String text) {

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [

//           const Icon(Icons.science, color: Colors.green),

//           const SizedBox(width: 8),

//           Text(
//             text,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.green,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// UI
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(
//         title: const Text("Rice Disease Detection"),
//         backgroundColor: const Color.fromARGB(255, 5, 100, 8),
//       ),

//       body: Stack(

//         children: [

//           /// BACKGROUND
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

//                 /// IMAGE CAPTURE
//                 sectionTitle("Leaf Image Capture"),

//                 Container(
//                   height: 300,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(
//                         color: Colors.green.shade700, width: 2),
//                     color: Colors.grey[200],
//                   ),
//                   child: _selectedImage == null
//                       ? const Center(
//                           child: Text(
//                             "Capture Rice Leaf Image",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.memory(
//                             _selectedImage!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                 ),

//                 const SizedBox(height: 10),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [

//                     ElevatedButton.icon(
//                       onPressed: () =>
//                           pickImage(ImageSource.camera),
//                       icon: const Icon(Icons.camera),
//                       label: const Text("Camera"),
//                     ),

//                     ElevatedButton.icon(
//                       onPressed: () =>
//                           pickImage(ImageSource.gallery),
//                       icon: const Icon(Icons.photo),
//                       label: const Text("Gallery"),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 /// RESULT
//                 sectionTitle("AI Diagnosis"),

//                 Card(
//                   elevation: 8,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(

//                       children: [

//                         const Text(
//                           "Diagnosis Result",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         ),

//                         const SizedBox(height: 10),

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: [

//                             const Text("Disease"),

//                             Text(
//                               _prediction,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green),
//                             ),
//                           ],
//                         ),

//                         const Divider(),

//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: [

//                             const Text("Confidence"),

//                             Text(
//                                 "${_confidence.toStringAsFixed(2)} %"),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 /// LOCATION
//                 sectionTitle("Location Data"),

//                 ElevatedButton.icon(
//                   onPressed: getLocation,
//                   icon: const Icon(Icons.location_on),
//                   label: const Text("Detect Location"),
//                 ),

//                 const SizedBox(height: 10),

//                 Container(
//   width: double.infinity,
//   padding: const EdgeInsets.all(12),
//   decoration: BoxDecoration(
//     color: Colors.white.withOpacity(0.9),
//     borderRadius: BorderRadius.circular(10),
//   ),
//   child: Text(
//     locationText,
//     style: const TextStyle(
//       fontSize: 16,
//       color: Colors.black,
//       fontWeight: FontWeight.w500,
//     ),
//   ),
// ),

//                 const SizedBox(height: 20),

//                 /// COMMENT
//              Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [

//     const Text(
//       "User Feedback (Optional)",
//       style: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//     ),

//     const SizedBox(height: 8),

//     Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.95),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           )
//         ],
//       ),
//       child: TextField(
//         controller: commentController,
//         maxLines: 4,
//         style: const TextStyle(
//           color: Colors.black,
//           fontSize: 15,
//         ),
//         decoration: InputDecoration(
//           hintText:
//               "Add observations about the crop condition (optional)...",
//           hintStyle: TextStyle(
//             color: Colors.grey[600],
//           ),
//           prefixIcon: const Icon(
//             Icons.feedback,
//             color: Colors.green,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: const EdgeInsets.all(16),
//         ),
//       ),
//     ),

//     const SizedBox(height: 8),

//     Text(
//       "You may describe symptoms such as spots, color change, or pest damage.",
//       style: TextStyle(
//         fontSize: 12,
//         color: Colors.white.withOpacity(0.9),
//       ),
//     ),

//   ],
// ),

//                 /// SEND RESULT
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 14),
//                   ),
//                   onPressed: sendReport,
//                   icon: const Icon(Icons.send),
//                   label: const Text(
//                     "Send Result to Research Server",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 /// MANUAL REPORT
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                   ),
//                   onPressed: () {

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             const ManualReportScreen(),
//                       ),
//                     );

//                   },
//                   icon: const Icon(Icons.chat),
//                   label: const Text("Manual Report"),
//                 ),
//               ],
//             ),
//           ),

//           /// PREDICTION LOADING
//           if (_isPredicting)
//             Container(
//               color: Colors.black.withOpacity(0.6),
//               child: const Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [

//                     CircularProgressIndicator(
//                         color: Colors.white),

//                     SizedBox(height: 20),

//                     Text(
//                       "Analyzing leaf image...",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//           /// UPLOAD LOADING
//           if (_isUploading)
//             Container(
//               color: Colors.black.withOpacity(0.6),
//               child: const Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [

//                     CircularProgressIndicator(
//                         color: Colors.white),

//                     SizedBox(height: 20),

//                     Text(
//                       "Submitting report...",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }



// rice.dart code used for apk not included inference time calculation

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

// class Rice extends StatefulWidget {
//   const Rice({super.key});

//   @override
//   State<Rice> createState() => _RiceState();
// }

// class _RiceState extends State<Rice> {

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
//         await Interpreter.fromAsset('assets/rice_model.tflite');

//     final labelsData =
//         await rootBundle.loadString('assets/rice_labels.txt');

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

//         "crop": "Rice",
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
//         title: const Text("Rice Disease Detection"),
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
//                                   child: Text("Capture Rice Leaf Image"),
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
//                   label: const Text("Send Result to Research Server 2"),
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
//                   label: const Text("Send us a Report"),
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






///
///
/// for interence time i am using this coce okay
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

class Rice extends StatefulWidget {
  const Rice({super.key});

  @override
  State<Rice> createState() => _RiceState();
}

class _RiceState extends State<Rice> {

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
    _interpreter = await Interpreter.fromAsset('assets/riceeeee.tflite');

    final labelsData = await rootBundle.loadString('assets/rice_labels.txt');
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
        _prediction = "Invalid Image";
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
        "crop": "Rice",
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
        title: const Text("Rice Disease Detection"),
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
                              ? const Center(child: Text("Capture Rice Leaf Image"))
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
                  label: const Text("Send Result to Research Server 2"),
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