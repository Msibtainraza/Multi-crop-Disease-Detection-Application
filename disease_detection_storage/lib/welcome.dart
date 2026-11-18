// //import 'package:disease_detection_storage/home.dart';
// import 'package:flutter/material.dart';

// class Welcome extends StatelessWidget {
//   const Welcome({super.key});

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(title: const Text("Welcome")),

//       body: const Center(
//         child: Column(
//           children:[
//              Text(
//             "Welcome to the Application",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10,),
// //            ElevatedButton(
// //   onPressed: () async {

// //     await FirebaseAuth.instance.signOut();

// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (context) =>  Home()),
// //     );

// //   // },
// //   child: const Text("Logout"),
// // )

// ElevatedButton(onPressed: (){},
//  child: Text("Get Location"))
//           ]
//         ),
//       ),
//     );
//   }
// }




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:disease_detection_storage/maize.dart';
// import 'package:disease_detection_storage/rice.dart';
// import 'package:disease_detection_storage/rubber.dart';
// import 'package:disease_detection_storage/tea.dart';
// import 'package:disease_detection_storage/wheat.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// class Welcome extends StatefulWidget {
//   const Welcome({super.key});

//   @override
//   State<Welcome> createState() => _WelcomeState();
// }

// class _WelcomeState extends State<Welcome> {

//   String locationMessage = "Location not fetched";
//   Future<void> getLocation() async {

//   bool serviceEnabled;
//   LocationPermission permission;

//   serviceEnabled = await Geolocator.isLocationServiceEnabled();

//   if (!serviceEnabled) {
//     setState(() {
//       locationMessage = "Location services are disabled";
//     });
//     return;
//   }

//   permission = await Geolocator.checkPermission();

//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }

//   if (permission == LocationPermission.deniedForever) {
//     setState(() {
//       locationMessage = "Location permission permanently denied";
//     });
//     return;
//   }

//   Position position = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.best,
//   );

//   List<Placemark> placemarks = await placemarkFromCoordinates(
//     position.latitude,
//     position.longitude,
//   );

//   Placemark place = placemarks[0];

//   setState(() {
//     locationMessage =
//         "Latitude: ${position.latitude}\n"
//         "Longitude: ${position.longitude}\n\n"
//         "${place.street}, ${place.subLocality}, ${place.locality}, "
//         "${place.administrativeArea}, ${place.country}";
//   });
// }

// Future<void> storeLocation() async {

//   Position position = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.best,
//   );

//   await FirebaseFirestore.instance.collection("detections").add({

//     "latitude": position.latitude,
//     "longitude": position.longitude,
//     "timestamp": DateTime.now()

//   });

// }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(

//       appBar: AppBar(title: const Text("Welcome")),

//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,

//           children: [
//              SizedBox(height: 50,),
//               ElevatedButton(onPressed: (){
//                             Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) =>  Tea(),
//   ),
// );
         
//               },
//               style: ElevatedButton.styleFrom(
//                  fixedSize: const Size(180, 80),
//                 backgroundColor: const Color.fromARGB(255, 6, 57, 8),
//               ),
//                child: Container(
//                 child: Text('Tea',style: TextStyle(fontWeight: FontWeight.bold,fontSize:25, color:Colors.black),),
//               )),
//               SizedBox(height: 15,),
//               ElevatedButton(onPressed: (){
//                     Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) =>  Rice(),
//   ),
// );
//               },
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(180, 80),
//                 backgroundColor: const Color.fromARGB(255, 6, 57, 8),
//               ),
//                child: Container(
//                 child: Text('Rice',style: TextStyle(fontWeight: FontWeight.bold,fontSize:25, color:Colors.black),),
//               )),
//               SizedBox(height: 15,),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) =>  Wheat(),
//   ),
// );
       

//               },
//               style: ElevatedButton.styleFrom(
//                   fixedSize: const Size(180, 80),
//                 backgroundColor: const Color.fromARGB(255, 6, 57, 8),
//               ),
//                child: Container(
//                 child: Text('Wheat',style: TextStyle(fontWeight: FontWeight.bold,fontSize:25, color:Colors.black),),
//               )),
//               SizedBox(height: 15,),
//               ElevatedButton(onPressed: (){
//                  Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) =>  Rubber(),
//   ),
// );
//               },
//               style: ElevatedButton.styleFrom(
//                   fixedSize: const Size(180, 80),
//                 backgroundColor: const Color.fromARGB(255, 6, 57, 8),
//               ),
//                child: Container(
//                 child: Text('Rubber',style: TextStyle(fontWeight: FontWeight.bold,fontSize:25, color:Colors.black),),
//               )),
//               SizedBox(height: 15,),
//               ElevatedButton(onPressed: (){
//                   Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => Maize(),
//   ),
// );

//               },
//               style: ElevatedButton.styleFrom(
//                   fixedSize: const Size(180, 80),
//                 backgroundColor: const Color.fromARGB(255, 6, 57, 8),
//               ),
//                child: Container(
//                 child: Text('Maize',style: TextStyle(fontWeight: FontWeight.bold,fontSize:25, color:Colors.black),),
//               )),

//             const Text(
//               "Welcome to the Application",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 20),

//             Text(
//               locationMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 18),
//             ),

//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: getLocation,
//               child: const Text("Get Location"),
//             ),
//             ElevatedButton(
//   onPressed: () async {

//     await storeLocation();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Location stored in Firebase")),
//     );

//   },
//   child: const Text("Send Location"),
// )

//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:disease_detection_storage/maize.dart';
import 'package:disease_detection_storage/rice.dart';
import 'package:disease_detection_storage/rubber.dart';
import 'package:disease_detection_storage/tea.dart';
import 'package:disease_detection_storage/wheat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Widget cropButton(String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 70),
          backgroundColor: const Color.fromARGB(255, 6, 57, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: [

          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Dark overlay for readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          /// Main UI
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  const Text(
                    "Crop Disease Detection",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Select Crop",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 30),

                  cropButton("Tea", const Tea()),
                  cropButton("Rice", const Rice()),
                  cropButton("Wheat", const Wheat()),
                  cropButton("Rubber", const Rubber()),
                  cropButton("Maize", const Maize()),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}