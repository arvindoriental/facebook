import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/MyLoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {



  String ? selectedGender; // Track selected gender for dropdown
  List<String> genders = ['Male', 'Female', 'Others' ];

  TextEditingController firstnameController=TextEditingController();
  TextEditingController lastnameController=TextEditingController();
  TextEditingController mobilenumberController=TextEditingController();
  TextEditingController  emailController= TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController cpasswordController=TextEditingController();



  void createAccount() async
  {
    String firstname=firstnameController.text.trim();
    String lastname=lastnameController.text.trim();
    String mobile=mobilenumberController.text.trim();
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    String cpassword=cpasswordController.text.trim();
    Map<String,dynamic> userdata={"name":firstname+lastname , "mobile":mobile,"email":email};
    if(email.isEmpty || password.isEmpty || cpassword.isEmpty ||firstname.isEmpty ||lastname.isEmpty || mobile.isEmpty )
    {
      print("please fill all the details");
    }
    else if(password != cpassword)
    {
      print("please fill all the details");
    }
    else
    {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        FirebaseFirestore.instance.collection("users").add(userdata);
        print("User Created");
        if (userCredential.user != null) {
          Navigator.pop(context);
        }
      }
        on FirebaseAuthException catch(ex)
        {
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
          onTap: ()
          {
            Navigator.push(context,CupertinoPageRoute(builder: (context)=>const MyLoginPage()));
          },
          child: const Icon(Icons.facebook),
        )
      ),

      body: SafeArea(
        child: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(15),
            child: Column(
              children: [

                TextField(
                  controller:firstnameController,
                  decoration: InputDecoration(
                      labelText: "First Name"
                  ),
                ),
                const SizedBox(height: 10,),


                TextField(
                  controller: lastnameController,
                  decoration: InputDecoration(
                      labelText: "Last Name"
                  ),
                ),
                const SizedBox(height: 10,),


                TextField(
                  controller: mobilenumberController,
                  decoration: InputDecoration(
                      labelText: "Mobile No."
                  ),
                ),
                const SizedBox(height: 10,),


                Align(
                  alignment:Alignment.centerLeft,
                  child:DropdownButton<String>(
                  hint: const Text('Select Gender'),
                  value: selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                  items: genders.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),),





                // const TextField(
                //   decoration: InputDecoration(
                //       labelText: "Date Of Birth"
                //   ),
                // ),
                // const SizedBox(height: 10,),


                TextField(
                  controller:emailController,
                  decoration: const InputDecoration(
                    labelText: "E-Mail Address"
                  ),
                ),
                const SizedBox(height: 10,),

                TextField(
                  obscureText:true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: "Create Password"
                  ),
                ),
                const SizedBox(height: 10,),


                TextField(
                  obscureText:true,
                  controller: cpasswordController,
                  decoration: const InputDecoration(
                      labelText: "Confirm Password"
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle the logic for the Next button
                    },
                    child: Text("Next"),
                  )),

                CupertinoButton(color:Colors.green,child: const Text("Create An Account"), onPressed:(){ createAccount();}
                )
              ],


            ),)
          ],
        ),
      ),
    );
  }
}
