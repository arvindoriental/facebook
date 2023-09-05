import 'package:facebook/MyLoginPage.dart';
import 'package:facebook/MySignUpPage2.dart';
import 'package:flutter/material.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return "Enter Valid Email";
    }
    return null;
  }

  String? selectedGender; // Track selected gender for dropdown
  List<String> genders = ['Male', 'Female', 'Others'];

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobilenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Sign Up Page"),
            leading: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLoginPage())), child: const Icon(Icons.facebook))),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Center(
                    child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(children: [
                              TextFormField(controller: firstnameController, decoration: const InputDecoration(labelText: "First Name")),
                              const SizedBox(
                                height: 10,
                              ),

                              TextFormField(controller: lastnameController, decoration: const InputDecoration(labelText: "Last Name")),
                              const SizedBox(
                                height: 10,
                              ),

                              TextFormField(controller: mobilenumberController, decoration: const InputDecoration(labelText: "Mobile No.")),
                              const SizedBox(
                                height: 10,
                              ),

                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      width: double.infinity, // Set the container width to expand across the screen
                                      child: DropdownButton<String>(
                                          hint: const Text('Sex'),
                                          value: selectedGender,
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedGender = newValue;
                                            });
                                          },
                                          items: genders.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(value: value, child: Text(value));
                                          }).toList()))),


                              TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value != null || !RegExp(r'[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+$').hasMatch(value!)) {
                                    return "enter correct name";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(labelText: "E-Mail Address"),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                  width: 80,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MySigUpPage2(firstnameController.text.trim(), lastnameController.text.trim(),
                                                  mobilenumberController.text.trim(), emailController.text.trim())));
                                    },
                                    child: const Text("Next"),
                                  )),
                            ])))))));
  }
}
