import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpt/main.dart';
import 'package:gpt/requestPage.dart';

class MyFormScreen extends StatefulWidget {
  final Function() onSubmitted;

  const MyFormScreen({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  _MyFormScreenState createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _placeController = TextEditingController();

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Phone number is required';
    }
    if (value!.length != 10 || int.tryParse(value) == null) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Form'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                  ),
                  validator: validatePhoneNumber,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                  validator: validateEmail,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _placeController,
                  decoration: InputDecoration(
                    labelText: 'Place of Requirement',
                    hintText: 'Enter the place where the item is required',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Place of requirement is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Get the current number of documents in the "users" collection
                      final usersSnapshot = await FirebaseFirestore.instance
                          .collection('users')
                          .get();
                      final userCount = usersSnapshot.docs.length;

                      // Create a new document with a name based on the number of documents in the collection
                      final userRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc('user ${userCount + 1}');

                      // Set the data for the new user document
                      await userRef.set({
                        'name': _nameController.text.trim(),
                        'phone': _phoneController.text.trim(),
                        'email': _emailController.text.trim(),
                        'place': _placeController.text.trim(),
                      });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
