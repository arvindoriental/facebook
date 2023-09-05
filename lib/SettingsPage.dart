import 'package:facebook/modal/fetchUserId.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/EditPage.dart';
import 'package:facebook/HomeFB.dart';
import 'package:facebook/MyLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void snackBarInMyProject() => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Logged Out Successful"), duration: Duration(seconds: 2), backgroundColor: Colors.red));

  void logout() async {
    await FirebaseAuth.instance.signOut();
    snackBarInMyProject();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyLoginPage()));
  }

  Future<void> _showLogOutConfirmationDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('LogOut??'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you sure you want to logout?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      logout();
                    })
              ]);
        });
  }

  void toastUserDeleted() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              "User Deleted",
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            )),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100.0, left: 16.0, right: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        )));
  }

  Future<void> _showDeleteAccountConfirmationDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('LogOut??'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Are you sure you want to delete permanently?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      deleteAccount();
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setting'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },icon: const Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: ListView(children: <Widget>[
          ListTile(leading: const Icon(Icons.delete_forever), title: const Text('Delete Account'), onTap: () => _showDeleteAccountConfirmationDialog()),
          ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditPage()))),
          ListTile(
            onTap: () => _showLogOutConfirmationDialog(),
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          )
        ]));
  }

  void deleteAccount() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String documentId = await fetchUserIdForEmail(currentUser.email.toString());
      FirebaseFirestore.instance.collection("users").doc(documentId).delete();
      toastUserDeleted();
      Navigator.of(context).pop();
    }
  }
}
