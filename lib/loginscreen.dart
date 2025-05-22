import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For DateFormat in _getTime()
import 'dart:async';

import 'animatedbackground.dart'; // Your animated background wrapper
import 'userclientscreen.dart'; // Your dashboard screen with role-based drawer

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _currentTime;
  late Timer _timer;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentTime = _getTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == 'UrbanPulse@owner.com' && password == 'urbanpulse123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard(role: 'owner')),
      );
    } else if (email == 'UrbanPulse@client.com' && password == 'urbanuser123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard(role: 'client')),
      );
    } else {
      _showDialog('Login Failed', 'Invalid email or password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BackgroundWrapper(
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Girl image on the left side
                Container(
                  width: size.width * 0.55,
                  child: Image.asset(
                    'assets/girl.png',
                    width: 450,
                    height: 450,
                    fit: BoxFit.contain,
                  ),
                ),

                // White login container on the right
                Container(
                  height: size.height * 0.98,
                  width: size.width * 0.4,
                  margin: EdgeInsets.only(right: size.width * 0.05),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Center(
                                child: Text(
                                  'Welcome to UrbanPulse',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlue.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  '"Redefining Urban Intelligence. Seamlessly monitor, track, and manage drainage systems with precision."',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 56),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Gmail',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _login,
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Positioned clock
            Positioned(
              bottom: 16,
              left: 50,
              child: Text(
                _currentTime,
                style: GoogleFonts.poppins(
                  fontSize: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
