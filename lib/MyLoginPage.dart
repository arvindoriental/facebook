import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facebook/MySignUpPage.dart';
import 'package:facebook/HomeFB.dart';

import 'UsersPage.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {

  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController=TextEditingController();

  void snackBarInMyProject()
  {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content :Text("Login Sucessfull"),
      duration: Duration(seconds: 2),
    ));
  }

  void login() async
  {
    String email=emailController.text.trim();
    String password=passwordController.text.trim();

    if(email.isEmpty || password.isEmpty)
    {
      print("please fill all the details");
    }
    else
      {
        try{
          UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
          print("LOGIN SuxcessFUL");
          snackBarInMyProject();

          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeFB()));
        }
        on FirebaseException catch(ex)
        {
          print("Invalid user id and password");
        }
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facebook"),
        leading: const Icon(Icons.facebook),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  controller:emailController,
                  decoration: const InputDecoration(
                    labelText: "E-Mail Address"
                  ),
                ),
                const SizedBox(height: 10,),

                TextField(
                  obscureText:true,
                    controller:passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password"
                  ),
                ),
                const SizedBox(height: 20,),

                CupertinoButton(color:Colors.blue,child:const  Text("Login"), onPressed:(){login();}),
                CupertinoButton(child: const Text("New User? Create An Account"), onPressed:(){
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(context,CupertinoPageRoute(builder: (context)=> const MySignUpPage()));
                }),

                CupertinoButton(child:const  Text("Users"), onPressed:(){Navigator.push(context, CupertinoPageRoute(builder: (context)=>const UsersPage()));}),

              ],
            ),)
          ],
        ),
      ),
    );
  }
}
