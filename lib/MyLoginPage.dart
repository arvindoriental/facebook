import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:facebook/MySignUpPage.dart';
import 'package:facebook/HomeFB.dart';
import 'package:facebook/UsersPage.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  void invalidpasswordtoast() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Center(child: Text("Invalid Password!")),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0)));

  Future<void> askAdminAlertBox() async {
    TextEditingController paas = TextEditingController();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: const EdgeInsets.all(15),
              title: const Text('Admin'),
              content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Enter Admin Password?'),
                TextFormField(
                  obscureText: true,
                  controller: paas,
                )
              ]),
              actions: <Widget>[
                TextButton(child: const Text('No'), onPressed: () => Navigator.pop(context)),
                TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      if (paas.text.trim() == 'arv123456') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UsersPage()));
                      } else {
                        Navigator.pop(context);
                        invalidpasswordtoast();
                      }
                    })
              ]);
        });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void snackBarInMyProject() => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text("Login Successful"), duration: Duration(seconds: 2), backgroundColor: Colors.green));

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      debugPrint("please fill all the details");
    } else {
      try {
        UserCredential userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        print("LOGIN SuxcessFUL");
        print(userCredential.toString());
        snackBarInMyProject();

        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeFB()));
      } on FirebaseException catch (ex) {
        debugPrint("Invalid user id and password");
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
            child: ListView(children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                TextField(controller: emailController, decoration: const InputDecoration(labelText: "E-Mail Address")),
                const SizedBox(height: 10),
                TextField(obscureText: true, controller: passwordController, decoration: const InputDecoration(labelText: "Password")),
                const SizedBox(height: 20),
                MaterialButton(
                    color: Colors.blue,
                    child: const Text("Login", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      login();
                    }),
                MaterialButton(
                    child: const Text("New User? Create An Account"),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MySignUpPage()));
                    }),
                MaterialButton(child: const Text("Users"), onPressed: () => askAdminAlertBox())
              ]))
        ])));
  }
}
