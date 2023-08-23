import 'package:facebook/HomeFB.dart';
import 'package:facebook/MyLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  void logout() async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context,CupertinoPageRoute(builder: (context)=>const MyLoginPage()));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: const Icon(Icons.facebook),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.home),
            title: Text('HomePage'),
            onTap: ()
            {
              Navigator.push(context,CupertinoPageRoute(builder: (context)=>const HomeFB()));
            },
          ),

          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Delete Account'),
          ),

          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),


          ListTile(
            onTap: ()
            {
              logout();
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      )
    );
  }
}
