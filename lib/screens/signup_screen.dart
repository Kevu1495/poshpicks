// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

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
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              // Username Text Field
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0), // Add spacing between fields

              // Password Text Field
              TextField(
                controller: _passwordController,
                obscureText: true, // Hide password characters
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              // Row for "Add Country" label and DropdownButton
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align left
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
                    onChanged: (value) => setState(() => _selectedCountry = value!),
                    dropdownColor: Color(0xFFA67D32), // Set dropdown color
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Checkbox for Terms
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) => setState(() => _agreeToTerms = value!),
                  ),
                  const Text("Agree to Terms and Conditions"),
                ],
              ),
              const SizedBox(height: 20.0),

              // Slider for Age
              Slider(
                value: _age,
                min: 0,
                max: 100.0,
                divisions: 100, // Number of marks on the slider track
                label: "Age: ${_age.round()}",
                onChanged: (value) => setState(() => _age = value),
              ),
              const SizedBox(height: 20.0),

              // Sign Up Button (add functionality as needed)
              ElevatedButton(
                onPressed: () {
                  // Add logic to handle form submission (e.g., validate input, register user)
                  print(
                    "Name: ${_nameController.text}\n"
                        "Email: ${_emailController.text}\n"
                    "Username: ${_usernameController.text}\n"
                        "Password: ${_passwordController.text}\n"
                        "Agreed to Terms: $_agreeToTerms\n"
                    "Country: $_selectedCountry\n"
                    "Age: $_age",
                  );
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
