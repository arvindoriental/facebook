import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  Future<void> _showDeleteConfirmationDialog(String documentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // This function returns a Future<void>, indicating that it will complete in the future.
        // The function takes a documentId as a parameter, which is the ID of the document to be deleted.
        // The async keyword indicates that this function may contain asynchronous operations.

        return AlertDialog(
          title: Text('Delete User'),
          // Creates an AlertDialog widget with the title "Delete User".

          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this user?'),
              ],
            ),
          ),
          // The content of the AlertDialog is a SingleChildScrollView containing a ListBody.
          // The ListBody contains a Text widget with the confirmation question.

          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // The first action button is "Cancel".
            // It's a TextButton with the text "Cancel".
            // When pressed, it uses Navigator.of(context).pop() to close the dialog.

            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await FirebaseFirestore.instance.collection("users").doc(documentId).delete();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            // The second action button is "Delete".
            // It's a TextButton with the text "Delete".
            // When pressed, it performs the deletion operation using FirebaseFirestore.
            // After deletion, it uses Navigator.of(context).pop() to close the dialog.
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Users"),
            leading: GestureDetector(
              // onTap: ()
              // {
              //   Navigator.push(context,CupertinoPageRoute(builder: (context)=>const MyLoginPage()));
              // },
              child: const Icon(Icons.facebook),
            )
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.active)
            {
              if(snapshot.hasData && snapshot.data!=null)
                {
                  return Container(
                    child: ListView.builder(
                        itemCount:snapshot.data!.docs.length,
                        itemBuilder:(context,index)
                        {
                          Map<String,dynamic> usermap=snapshot.data!.docs[index].data() as Map<String,dynamic>;

                          final documentId = snapshot.data!.docs[index].id; // Get the document ID


                          final name = usermap["name"] ?? "N/A"; // Use "N/A" if name is null
                          final email = usermap["email"] ?? "N/A"; // Use "N/A" if email is null
                          return ListTile(
                            title: Text(name),
                            subtitle: Text(email),
                            trailing: IconButton(
                              onPressed: (){_showDeleteConfirmationDialog(documentId);},
                              icon: Icon(Icons.delete),
                            ),
                          );
                        }),
                  );


                }
              else
                {
                  return Text("No DATA BRO!");
                }
            }
          else
            {
              return  Center(
                child: CircularProgressIndicator(),
              );
            }
        },
      ),
    );
  }
}
