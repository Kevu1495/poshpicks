import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poshpicks/fuctions/authfunctions.dart';
import 'package:poshpicks/screens/SignInScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreeToTerms = false;
  String _selectedCountry = "India"; // Default country
  double _age = 18; // Initial age for slider
  bool _nameValid = false;
  bool _emailValid = false;
  bool _usernameValid = false;
  bool _passwordValid = false;
  File? _image;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    print("getImage function called with source: $source");
    // Request permissions
    // if (source == ImageSource.camera) {
    //   var cameraPermissionStatus = await Permission.camera.request();
    //   if (!cameraPermissionStatus.isGranted) return;
    // } else {
    //   var storagePermissionStatus = await Permission.storage.request();
    //   if (!storagePermissionStatus.isGranted) return;
    // }

    // Proceed with image capture or selection
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("Image picked: ${_image!.path}");
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 191, 80),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? const CircleAvatar(
                      radius: 80,
                      child: Icon(Icons.person, size: 80),
                    )
                  : CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(_image!),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                child: Text('Take a Picture'),
              ),
              ElevatedButton(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                child: Text('Select from Gallery'),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                  errorText: _nameValid ? null : "Enter a valid name",
                ),
                onChanged: (value) {
                  setState(() {
                    _nameValid = value.isNotEmpty;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  errorText: _emailValid ? null : "Enter a valid email",
                ),
                onChanged: (value) {
                  setState(() {
                    _emailValid = value.isNotEmpty && value.contains('@');
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  errorText: _usernameValid ? null : "Enter a valid username",
                ),
                onChanged: (value) {
                  setState(() {
                    _usernameValid = value.isNotEmpty;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  errorText: _passwordValid ? null : "Enter a valid password",
                ),
                onChanged: (value) {
                  setState(() {
                    _passwordValid = value.isNotEmpty && value.length >= 6;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Country",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedCountry,
                    items: const [
                      DropdownMenuItem(
                        value: "India",
                        child: Text("India"),
                      ),
                      DropdownMenuItem(
                        value: "USA",
                        child: Text("USA"),
                      ),
                      DropdownMenuItem(
                        value: "UK",
                        child: Text("UK"),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedCountry = value!),
                    dropdownColor: const Color(0xFFA67D32),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) =>
                        setState(() => _agreeToTerms = value!),
                  ),
                  const Text("Agree to Terms and Conditions"),
                ],
              ),
              const SizedBox(height: 20.0),
              Slider(
                value: _age,
                min: 0,
                max: 100.0,
                divisions: 100,
                label: "Age: ${_age.round()}",
                onChanged: (value) => setState(() => _age = value),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _validateAndSignUp,
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSignUp() async {
    try {
      if (_nameValid &&
          _emailValid &&
          _usernameValid &&
          _passwordValid &&
          _agreeToTerms &&
          _image != null) {
        // Upload image to Firebase Storage
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_images/${_usernameController.text}.jpg');
        firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Perform sign up first
        await signup(_emailController.text, _passwordController.text);

        // Add user details to Firestore
        CollectionReference collRef =
            FirebaseFirestore.instance.collection('User');
        await collRef.doc(FirebaseAuth.instance.currentUser!.uid).set({
          'Name': _nameController.text,
          'Email': _emailController.text,
          'Username': _usernameController.text,
          'Password': _passwordController.text,
          'Agreed to Terms': _agreeToTerms,
          'Country': _selectedCountry,
          'Age': _age,
          'ImageURL': imageUrl, // Add image URL to Firestore
        });
        DocumentSnapshot snapshot =
            await collRef.doc(FirebaseAuth.instance.currentUser!.uid).get();

        // Fetch user details
        //DocumentSnapshot snapshot = await docRef.get();
        // Show user details in a popup
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("User Details"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${snapshot['Name']}"),
                Text("Email: ${snapshot['Email']}"),
                Text("Username: ${snapshot['Username']}"),
                Text("Country: ${snapshot['Country']}"),
                Text("Age: ${snapshot['Age']}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signinscreen()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // Show error message or handle invalid input
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Please fill all fields correctly and select an image."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error in signup: $e');
    }
  }
}
