import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? selectedGender;
  List<String> genders = ['Male', 'Female', 'Others'];


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc('uQKcfcRQPgEWoU1dE4mJ').get();
      if (userSnapshot.exists) {
        UserData userData = userSnapshot.data() as UserData;
        debugPrint("${userData.toString()} helo");
        setState(() {
          firstnameController.text = userData.firstName ?? '';
          lastnameController.text = userData.lastName ?? '';
          mobilenumberController.text = userData.mobile ?? '';
          emailController.text = userData.email ?? '';
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        leading: const Icon(Icons.account_circle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: firstnameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: lastnameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: mobilenumberController,
              decoration: const InputDecoration(labelText: "Mobile No."),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "E-Mail Address"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

              },
              child: const Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
class UserData{
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;

  UserData({this.firstName, this.lastName, this.email, this.mobile});
  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    firstName: json["firstname"],
    lastName: json["lastname"],
    email: json["email"],
    mobile: json["mobile"],
  );
}