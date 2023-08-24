import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MyLoginPage.dart';

class MySigUpPage2 extends StatefulWidget {String firstname,lastname,mobile,email;
      MySigUpPage2(this.firstname, this.lastname, this.mobile, this.email,
      {super.key});

  @override
  State<MySigUpPage2> createState() => _MySigUpPage2State();
}

class _MySigUpPage2State extends State<MySigUpPage2> {
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  void createAccount() async {

    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();
    Map<String, dynamic> userdata = {"name": widget.firstname + widget.lastname, "mobile": widget.mobile, "email": widget.email};
    if (widget.email.isEmpty || password.isEmpty || cpassword.isEmpty || widget.firstname.isEmpty || widget.lastname.isEmpty || widget.mobile.isEmpty) {
      print("please fill all the details");
    } else if (password != cpassword) {
      print("please fill all the details");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: widget.email, password: password);
        FirebaseFirestore.instance.collection("users").add(userdata);
        print("User Created");
        if (userCredential.user != null) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (ex) {
        print(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up Page"),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLoginPage()));
          },
          child: const Icon(Icons.facebook),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextFormField(decoration: const InputDecoration(labelText: "Nationality")),
                    const SizedBox(height: 10),
                    TextFormField(obscureText: true, controller: passwordController, decoration: const InputDecoration(labelText: "Password")),
                    const SizedBox(height: 10),
                    TextFormField(obscureText: true, controller: cpasswordController, decoration: const InputDecoration(labelText: "Confirm Password")),
                    const SizedBox(height: 10),
                    MaterialButton(
                      color: Colors.green,
                      child: const Text("Create An Account"),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          createAccount();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
