import 'dart:math';

import 'package:facebook/HomeFB.dart';
import 'package:facebook/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:facebook/MyLoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

   // await FirebaseFirestore.instance.collection("users").doc("oM5Qgzdm35M9XA60Idhr").delete();
   // print("Deleted hai bhai");
    return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FB",
      home:(FirebaseAuth.instance.currentUser!=null)? HomeFB(): MyLoginPage(),
    );
  }
}
