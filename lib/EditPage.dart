import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:facebook/modal/getURL.dart';
import 'package:facebook/modal/fetchUserId.dart';
import 'package:facebook/modal/UserData.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String idOfFirestore = await fetchUserIdForEmail(currentUser.email.toString());
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(idOfFirestore).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userDataMap = userSnapshot.data() as Map<String, dynamic>;

        UserData userData = UserData(
          firstName: userDataMap['firstName'],
          lastName: userDataMap['lastName'],
          mobile: userDataMap['mobile'],
          email: userDataMap['email'],
          photo: userDataMap['photo'], // Assuming 'photo' is the field containing the image URL
        );

        if (userData.photo != null) {
          try {
            Uint8List imageBytes = await getImageFromUrl(userData.photo!);

            setState(() {
              firstNameController.text = userData.firstName ?? '';
              lastNameController.text = userData.lastName ?? '';
              mobileNumberController.text = userData.mobile ?? '';
              emailController.text = userData.email ?? '';
              _image = imageBytes;
            });
          } catch (error) {
            debugPrint("Error fetching image: $error");
          }
        } else {
          setState(() {
            firstNameController.text = userData.firstName ?? '';
            lastNameController.text = userData.lastName ?? '';
            mobileNumberController.text = userData.mobile ?? '';
            emailController.text = userData.email ?? '';
            _image = null;
          });
        }
      }
    }
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      debugPrint("no image selected");
    }
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List imageBytes) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(imageBytes);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void updateUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Uint8List? imageBytes = _image;

      try {
        String idOfFirestore = await fetchUserIdForEmail(currentUser.email.toString());
        String imageUrl = '';

        if (imageBytes != null) {
          imageUrl = await uploadImageToStorage("profileImage_$idOfFirestore.png", imageBytes);
        }

        UserData updatedUserData = UserData(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          mobile: mobileNumberController.text,
          email: emailController.text,
          photo: imageUrl,
        );

        await FirebaseFirestore.instance.collection('users').doc(idOfFirestore).update(updatedUserData.toJson());

        debugPrint('User data updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (error) {
        debugPrint('Error updating user data: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile"),
          leading: const Icon(Icons.account_circle),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Stack(children: [
                    _image != null
                        ? CircleAvatar(radius: 90, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(radius: 90, backgroundImage: AssetImage('images/avatar.png')),
                    Positioned(
                        bottom: 0,
                        left: 120,
                        child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 50,
                            )))
                  ]),
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: "First Name"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: "Last Name"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: mobileNumberController,
                    decoration: const InputDecoration(labelText: "Mobile No."),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "E-Mail Address"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      updateUserData();
                    },
                    child: const Text("Update Profile"),
                  ),
                ])),
            Visibility(
              visible: firstNameController.text == "",
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                ),
              ),
            ),
            Visibility(visible: firstNameController.text == "", child: const Center(child: CircularProgressIndicator())),
          ],
        ));
  }
}
