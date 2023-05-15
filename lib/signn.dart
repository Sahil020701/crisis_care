import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 99, 53, 180),
        title: Text('Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.deepPurple)),
              child: Text('Login'),
              onPressed: () async {
                final String email = _emailController.text.trim();
                final String password = _passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  return;
                }

                try {
                  await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  _showError = false;
                } catch (e) {
                  setState(() {
                    _showError = true;
                  });
                  //print('Failed to sign in with email and password: $e');
                  return;
                }

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            SizedBox(height: 16.0),
            StreamBuilder<User?>(
              stream: _auth.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final User? user = snapshot.data;
                  if (user == null) {
                    return SizedBox();
                  }
                  return Text('Signed in as ${user.email}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            if (_showError)
              AlertDialog(
                title: Text('Error'),
                content: Text('Invalid email or password. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showError = false;
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
