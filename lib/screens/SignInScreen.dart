import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poshpicks/fuctions/authfunctions.dart';
import 'package:poshpicks/screens/signup_screen.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();


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
              // Username Text Field
            Positioned( // Position login form elements strategically
            bottom: 370.0, // Adjust bottom position for desired layout
            left: 20.0, // Adjust left position for desired padding
            right: 20.0,
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // Hide password characters
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(height: 25.0), // Add spacing between fields and button

                  SizedBox(
                    width: 500.0,
                    height: 50.0,
                    child: ElevatedButton(
                      child: Text('Submit',style: TextStyle(fontSize: 18.0)),
                      onPressed: () {
                        signin(_usernameController.text, _passwordController.text);
                        // Handle login logic here
                        print('Logging in...');
                        // TODO: Implement login logic
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFA67D32)), // Background color
                        foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF261601)), // Text color
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Positioned(
                    bottom: 100,
                    child: SizedBox(
                      width: 500.0,
                      height: 50.0,
                      child: ElevatedButton(
                        child: Text('Create Account',style: TextStyle(fontSize: 18.0)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFA67D32)), // Background color
                          foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF261601)), // Text color
                        ),
                      ),
                    ),
                  )
                  // SizedBox(
                  //
                  // ),

                ],
              )
 // Add spacing between fields
            ),

            ],
          ),
        ),
      ),
    );
  }
}
