// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class MyReportsScreen extends StatelessWidget {

// //   const MyReportsScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {

// //     String uid = FirebaseAuth.instance.currentUser!.uid;

// //     return Scaffold(

// //       appBar: AppBar(
// //         title: const Text("My Reports"),
// //         backgroundColor: const Color.fromARGB(255, 5, 100, 8),
// //       ),

// //       body: StreamBuilder(

// //         stream: FirebaseFirestore.instance
// //             .collection("manual_reports")
// //             .where("user_id", isEqualTo: uid)
// //             .snapshots(),

// //         builder: (context, snapshot) {

// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           var docs = snapshot.data!.docs;

// //           return ListView.builder(

// //             itemCount: docs.length,

// //             itemBuilder: (context, index) {

// //               var data = docs[index];

// //               return Card(

// //                 child: ListTile(

// //                   leading: const Icon(Icons.local_florist),

// //                   title: Text(data["disease"]),

// //                   subtitle: Text(
// //                       "Crop: ${data["crop_name"]}\nLocation: ${data["location"]}"
// //                   ),

// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }


// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MyReportsScreen extends StatelessWidget {

//   const MyReportsScreen({super.key});

//   Uint8List decodeImage(String base64String) {

//     return base64Decode(base64String);
//   }
// Future<void> generateReportPDF(Map data) async {

//   final pdf = pw.Document();

//   pdf.addPage(

//     pw.Page(

//       build: (pw.Context context) {

//         return pw.Column(

//           crossAxisAlignment: pw.CrossAxisAlignment.start,

//           children: [

//             pw.Text("Plant Disease Report",
//                 style: pw.TextStyle(
//                     fontSize: 24,
//                     fontWeight: pw.FontWeight.bold)),

//             pw.SizedBox(height: 20),

//             pw.Text("Crop: ${data["crop_name"] ?? ""}"),
//             pw.Text("Disease: ${data["disease"] ?? ""}"),
//             pw.Text("Pathogen: ${data["pathogen"] ?? ""}"),
//             pw.Text("Location: ${data["location"] ?? ""}"),

//             pw.SizedBox(height: 10),

//             pw.Text("Description:"),

//             pw.Text(data["description"] ?? ""),

//           ],
//         );
//       },
//     ),
//   );

//   await Printing.layoutPdf(
//       onLayout: (format) async => pdf.save());
// }
//   @override
//   Widget build(BuildContext context) {

//     String uid = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(

//       appBar: AppBar(
//         title: const Text("My Reports"),
//         backgroundColor: const Color.fromARGB(255, 5, 100, 8),
//       ),

//       body: StreamBuilder(

//         stream: FirebaseFirestore.instance
//             .collection("manual_reports")
//             .where("user_id", isEqualTo: uid)
//             .orderBy("timestamp", descending: true)
//             .snapshots(),

//         builder: (context, snapshot) {

//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           var docs = snapshot.data!.docs;

//           if (docs.isEmpty) {
//             return const Center(
//                 child: Text("No reports submitted yet"));
//           }

//           return ListView.builder(

//             itemCount: docs.length,

//             itemBuilder: (context, index) {

//               var data = docs[index];

//               String crop =
//                   data.data().containsKey("crop_name")
//                       ? data["crop_name"]
//                       : "Unknown";

//               String disease =
//                   data.data().containsKey("disease")
//                       ? data["disease"]
//                       : "Unknown";

//               String location =
//                   data.data().containsKey("location")
//                       ? data["location"]
//                       : "Unknown";

//               List leafImages =
//                   data.data().containsKey("leaf_images")
//                       ? data["leaf_images"]
//                       : [];

//               return Card(

//                 margin: const EdgeInsets.all(12),

//                 child: Padding(

//                   padding: const EdgeInsets.all(10),

//                   child: Column(

//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,

//                     children: [

//                       /// LEAF IMAGE
//                       if (leafImages.isNotEmpty)

//                         ClipRRect(

//                           borderRadius:
//                               BorderRadius.circular(10),

//                           child: Image.memory(

//                             decodeImage(leafImages[0]),

//                             height: 200,
//                             width: double.infinity,

//                             fit: BoxFit.cover,
//                           ),
//                         ),

//                       const SizedBox(height: 10),

//                       Text(
//                         "Crop: $crop",
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold),
//                       ),

//                       Text("Disease: $disease"),

//                       Text("Location: $location"),

//                       const SizedBox(height: 8),

//                       if (data.data().containsKey("description"))

//                         Text(
//                             "Description: ${data["description"]}"),
//                             ElevatedButton.icon(

//   icon: const Icon(Icons.picture_as_pdf),

//   label: const Text("Export PDF"),

//   onPressed: () {

//     generateReportPDF(data.data());

//   },
// )

//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  /// Decode Base64 image
  Uint8List decodeImage(String base64String) {
    return base64Decode(base64String);
  }

  /// Generate PDF report
  Future<void> generateReportPDF(Map data) async {

    final pdf = pw.Document();

    List images = data["leaf_images"] ?? [];

    pdf.addPage(
      pw.Page(
        build: (context) {

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              pw.Center(
                child: pw.Text(
                  "PLANT DISEASE REPORT",
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold),
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Divider(),

              pw.Text("Crop: ${data["crop_name"] ?? ""}"),
              pw.Text("Disease: ${data["disease"] ?? ""}"),
              pw.Text("Pathogen: ${data["pathogen"] ?? "Not specified"}"),
              pw.Text("Location: ${data["location"] ?? ""}"),

              pw.SizedBox(height: 10),

              pw.Text(
                "Description:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),

              pw.Text(data["description"] ?? ""),

              pw.SizedBox(height: 20),

              if (images.isNotEmpty) ...[

                pw.Text(
                  "Leaf Images",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),

                pw.SizedBox(height: 10),

                pw.Wrap(
                  spacing: 10,
                  runSpacing: 10,

                  children: images.map<pw.Widget>((img) {

                    final bytes = base64Decode(img);

                    return pw.Image(
                      pw.MemoryImage(bytes),
                      height: 120,
                      width: 120,
                    );

                  }).toList(),
                ),
              ],

              pw.SizedBox(height: 20),

              pw.Divider(),

              pw.Center(
                child: pw.Text(
                  "Generated by Crop Disease Detection System",
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Reports"),
        backgroundColor: const Color.fromARGB(255, 5, 100, 8),
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("manual_reports")
            .where("user_id", isEqualTo: uid)
            .orderBy("timestamp", descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("No reports submitted yet"),
            );
          }

          return ListView.builder(

            itemCount: docs.length,

            itemBuilder: (context, index) {

              var data = docs[index];

              String crop =
                  data.data().containsKey("crop_name")
                      ? data["crop_name"]
                      : "Unknown";

              String disease =
                  data.data().containsKey("disease")
                      ? data["disease"]
                      : "Unknown";

              String pathogen =
                  data.data().containsKey("pathogen")
                      ? data["pathogen"]
                      : "Not specified";

              String location =
                  data.data().containsKey("location")
                      ? data["location"]
                      : "Unknown";

              List leafImages =
                  data.data().containsKey("leaf_images")
                      ? data["leaf_images"]
                      : [];

              return Card(

                margin: const EdgeInsets.all(12),

                elevation: 4,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Padding(

                  padding: const EdgeInsets.all(12),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      /// IMAGE GALLERY
                      if (leafImages.isNotEmpty)

                        SizedBox(
                          height: 120,

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,

                            itemCount: leafImages.length,

                            itemBuilder: (context, i) {

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),

                                  child: Image.memory(
                                    decodeImage(leafImages[i]),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 10),

                      Text(
                        "Crop: $crop",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      Text("Disease: $disease"),

                      Text("Pathogen: $pathogen"),

                      Text("Location: $location"),

                      const SizedBox(height: 8),

                      if (data.data().containsKey("description"))

                        Text("Description: ${data["description"]}"),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,

                        child: ElevatedButton.icon(

                          icon: const Icon(Icons.picture_as_pdf),

                          label: const Text("Export PDF"),

                          onPressed: () {

                            generateReportPDF(data.data());

                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}