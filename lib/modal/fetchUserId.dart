import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> fetchUserIdForEmail(String email) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();

  if (querySnapshot.docs.isNotEmpty) {
    String userId = querySnapshot.docs.first.id;
    return userId;
  } else {
    throw Exception('No user found with the email $email');
  }
}