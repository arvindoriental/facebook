import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:facebook/SettingsPage.dart';
import 'package:facebook/modal/getURL.dart';
import 'package:facebook/modal/fetchUserId.dart';

import 'modal/UserData.dart';

class HomeFB extends StatefulWidget {
  const HomeFB({super.key});

  @override
  State<HomeFB> createState() => _HomeFBState();
}

class _HomeFBState extends State<HomeFB> {
  String? username = "";
  String? email = "";

  Uint8List _image = Uint8List(0);

  void fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String idOfFirestore = await fetchUserIdForEmail(currentUser.email.toString());
        debugPrint(idOfFirestore);
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(idOfFirestore).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userDataMap = userSnapshot.data() as Map<String, dynamic>;
          UserData userData = UserData(
            firstName: userDataMap['firstName'],
            lastName: userDataMap['lastName'],
            mobile: userDataMap['mobile'],
            email: userDataMap['email'],
            photo: userDataMap['photo'], // Assuming 'photo' is the field containing the image URL
          );
          if (userData.photo != null) {
            try {
              Uint8List imageBytes = await getImageFromUrl(userData.photo!);

              setState(() {
                username = userData.firstName ?? '';
                email = userData.email ?? '';
                _image = imageBytes;
              });
            } catch (error) {
              debugPrint("Error fetching image: $error");
            }
          } else {
            setState(() {
              username = userData.firstName ?? '';
              email = userData.email ?? '';
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Home"),
            leading: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeFB())), child: const Icon(Icons.facebook)),
            actions: [
              IconButton(
                  icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())))
            ]),
        body: Stack(children: [

          Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Welcome to facebook", style: TextStyle(letterSpacing: 4, fontSize: 25, color: Colors.blue, fontWeight: FontWeight.w700)),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
            ),
            const Image(image: AssetImage("images/metalogo.png"), width: 100),
            const SizedBox(height: 20),
            CircleAvatar(
                radius: 120, // Adjust the radius as needed
                backgroundImage: MemoryImage(_image!)),
            const SizedBox(height: 20),
            Text("$username", style: const TextStyle(fontSize: 20)),
            Text("$email", style: const TextStyle(fontSize: 20)),
          ])),
          Visibility(
            visible: email == "" || _image=="",
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
              ),
            ),
          ),
          Visibility(visible: email == "", child: const Center(child: CircularProgressIndicator()))
        ]));
  }
}
