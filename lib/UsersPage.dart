import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'MyLoginPage.dart';


class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  void toastUserDelelted() {
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

  Future<void> _showDeleteConfirmationDialog(String documentId) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: const Text('Delete User'), content: const Text('Are you sure you want to delete this user?'), actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  FirebaseFirestore.instance.collection("users").doc(documentId).delete();
                  toastUserDelelted();
                  Navigator.of(context).pop(); // Close the dialog
                })
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Users"),
            leading: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLoginPage())), child: const Icon(Icons.arrow_back_sharp))),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> usermap = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                        final documentId = snapshot.data!.docs[index].id;

                        final name = usermap["name"] ?? "N/A";
                        final email = usermap["email"] ?? "N/A"; //
                        return ListTile(
                            title: Text(name),
                            subtitle: Text(email),
                            trailing: IconButton(onPressed: () => _showDeleteConfirmationDialog(documentId), icon: const Icon(Icons.delete)));
                      });
                } else {
                  return const Text("No DATA BRO!");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
