import 'package:flutter/material.dart';
import 'package:poshpicks/fuctions/authfunctions.dart';
import 'package:poshpicks/screens/SignInScreen.dart';

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
  bool _nameValid = false;
  bool _emailValid = false;
  bool _usernameValid = false;
  bool _passwordValid = false;

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

  void _validateAndSignUp() {
    if (_nameValid &&
        _emailValid &&
        _usernameValid &&
        _passwordValid &&
        _agreeToTerms) {
      signup(_emailController.text, _passwordController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Signinscreen()),
      );
      print(
        "Name: ${_nameController.text}\n"
            "Email: ${_emailController.text}\n"
            "Username: ${_usernameController.text}\n"
            "Password: ${_passwordController.text}\n"
            "Agreed to Terms: $_agreeToTerms\n"
            "Country: $_selectedCountry\n"
            "Age: $_age",
      );
    } else {
      // Show error message or handle invalid input
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Please fill all fields correctly."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
