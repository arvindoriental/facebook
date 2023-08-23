import 'package:facebook/MySignUpPage.dart';
import 'package:facebook/Settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facebook/MyLoginPage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';



class HomeFB extends StatefulWidget {
  const HomeFB({super.key});

  @override
  State<HomeFB> createState() => _HomeFBState();
}

class _HomeFBState extends State<HomeFB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        leading: GestureDetector(
          onTap: ()
          {
              Navigator.push(context,CupertinoPageRoute(builder: (context)=>const HomeFB()));
            },
            child: const Icon(Icons.facebook),
          ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,CupertinoPageRoute(builder: (context)=>const Settings()));
              },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: TyperAnimatedTextKit(
                text: ['Welcome to Facebook $MySignUpPage.name'],
                textStyle: TextStyle(color:Colors.blue,fontSize: 24.0, fontWeight: FontWeight.bold),
                speed: Duration(milliseconds: 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
