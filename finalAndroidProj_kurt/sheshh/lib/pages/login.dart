import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sheshh/pages/backend/api.dart';
import 'register.dart';
import 'home_screen.dart';
import 'package:sheshh/pages/home_content.dart';
import 'package:sheshh/pages/settings_screen.dart';
import 'package:sheshh/pages/homepage_clone.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  String? loginError;
  int _selectedIndex = 0; // Default index for LoginPage
  static const List<Widget> _pages = <Widget>[
    LoginPage(),
    HomepageClone(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        // Assuming index 0 is for LoginPage
        _selectedIndex = index; // Keep it on LoginPage
      } else if (index == 1) {
        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomepageClone()),
        );
      } else {
        _selectedIndex = index; // Update for SettingsPage
      }
    });
  }

  final _emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Invalid email format';
    } return null;
  }
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    setState(() {
      emailError = _validateEmail(emailController.text);
      passwordError = _validatePassword(passwordController.text);
    });

    if (emailError == null && passwordError == null) {
      final authService = AuthService();
      try {
        final response = await authService.login(
          emailController.text,
          passwordController.text,
        );

        print('API Response: $response'); // Debugging line

        if (response['token'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Login failed: Password or Email is incorrect')),
          );
        } else {
          // Success - token and user data are set in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', response['token'] ?? '');
          prefs.setString('username', response['username'] ?? '');
          print('Username saved: ${prefs.getString('username')}');
          prefs.setString('email', response['email'] ?? '');
          prefs.setString('firstName', response['firstName'] ?? '');
          prefs.setString('lastName', response['lastName'] ?? '');
          prefs.setInt('age', response['age'] ?? 0);
          prefs.setString('gender', response['gender'] ?? '');
          prefs.setString('image', response['image'] ?? '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful')),
          );

          Navigator.pushNamed(context, '/homepage', arguments: response['token']);
        }
      } catch (e) {
        // Log the exception to catch network errors
        print('Login error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Password or Email is incorrect')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF87CEEB), Color(0xFF035594)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: _selectedIndex == 0
                    ? _buildLoginForm()
                    : _pages[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(1.0),
            topRight: Radius.circular(1.0),
            bottomLeft: Radius.circular(1.0),
            bottomRight: Radius.circular(1.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF035594), Color(0xFF4286f4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    );
                  }
                  return const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  );
                }),
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                destinations: <NavigationDestination>[
                  NavigationDestination(
                    icon: Image.asset(
                      'assets/logout.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    label: 'LOGIN',
                  ),
                  NavigationDestination(
                    icon: Image.asset(
                      'assets/lakbay_cavite_logo.png',
                      width: 40,
                      height: 40,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Image.asset(
                      'assets/setting.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/lakbayinlogo.png',
              height: 300,
            ),
            const SizedBox(height: 20),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: emailError,
                      labelStyle: const TextStyle(
                          color: Colors.white, fontFamily: 'Poppins'),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        emailError = _validateEmail(value);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: passwordError,
                      labelStyle: const TextStyle(
                          color: Colors.white, fontFamily: 'Poppins'),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        passwordError = _validatePassword(value);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Display login error if exists
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      elevation: 5,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: _handleLogin,
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black26,
                    ),
                    child: const Text(
                      'Don’t have an account? Sign Up',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
