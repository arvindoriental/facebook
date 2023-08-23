import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
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
                              onPressed: (){FirebaseFirestore.instance.collection("users").doc(documentId).delete();},
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
