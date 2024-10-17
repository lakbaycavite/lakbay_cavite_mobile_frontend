import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'package:sheshh/pages/backend/api.dart';
import 'login.dart';
import 'package:flutter/gestures.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final AuthService _authService = AuthService();

  // Validation regular expressions
  final _emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  final _passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$');
  final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
  String? _emailError;
  String? _passwordError;
  String? _repeatPasswordError;
  String? _verificationCodeError;
  String? _usernameError;
  bool isEmailVerified = false;
  bool isCodeSent = false;

  // Validators for username, email, password, and repeat password
  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username cannot be empty';
    } else if (username.length <= 3 || username.length >= 20) {
      return 'Username is too short; \nThe minimum length is 3 characters \nThe maximum length is 20 characters';
    } else if (!usernameRegExp.hasMatch(username)){
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Invalid email format';
    } else if (email.length > 254) {
      return 'Email is too long';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (value.length > 20) {
      return 'Password cannot exceed 20 characters';
    } else if (!_passwordRegExp.hasMatch(value)) {
      return 'Password must include an uppercase letter, lowercase letter, digit, and special character';
    }
    return null;
  }

  String? _validateRepeatPassword(String value) {
    if (value.isEmpty) {
      return 'Please repeat your password';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _sendVerificationCode() async {
    final response = await _authService.sendVerificationCode(emailController.text);
    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'] ?? 'Error sending code')),
      );
    } else {
      setState(() {
        isCodeSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code sent')),
      );
    }
  }

  Future<void> _verifyCode() async {
    final response = await _authService.verifyCode(emailController.text, codeController.text);
    if (response.containsKey('error')) {
      setState(() {
        _verificationCodeError = response['error'];
      });
    } else {
      setState(() {
        isEmailVerified = true;
        _verificationCodeError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email verified successfully')),
      );
    }
  }

  Future<void> _handleRegister() async {
    setState(() {
      _emailError = _validateEmail(emailController.text);
      _passwordError = _validatePassword(passwordController.text);
      _repeatPasswordError = _validateRepeatPassword(repeatPasswordController.text);
      _usernameError = _validateUsername(usernameController.text);
    });

    if (_emailError == null && _passwordError == null && _repeatPasswordError == null && isEmailVerified && _usernameError == null) {
      try {
        // Call the AuthService register method
        final response = await _authService.register(
          emailController.text,
          passwordController.text,
          usernameController.text,
        );

        // Check the response for success or error
        if (response.containsKey('error')) {
          // If the response has an 'error' key, show the error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Registration failed')),
          );
        } else {
          // If the response is successful, show the success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Registration successful')),
          );

          // Navigate to the LoginPage on success
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      } catch (error) {
        // Handle any error thrown by the backend or during the request
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())), // Show the error message
        );
      }
    }
  }



  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Privacy Policy',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 10),
                Text(
                  'Effective/Updated Date: October 01, 2024',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Lakbay Cavite (“we,” “our,” or “us”) respects your privacy and is committed to protecting your data. This Privacy Policy explains how we collect, use, and disclose information when you use the Lakbay Cavite mobile application (“App”).',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Information We Collect',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'a. Personal Information\n-Account Data: When you sign up for an account, we collect your name, username, email address, and any other information you provide during registration.\n-User-Generated Content: When you post comments, routes, or recommendations, the content you share will be publicly visible along with your username.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 10),
                Text(
                  'b. Non-Personal Information\n-Location Data: If you allow location tracking, we may collect your real-time location data to suggest nearby routes or services.\n-Usage Data: We collect information on how you interact with the App, including the features you use, pages you visit, and actions you take within the App.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 10),
                Text(
                  'c. Device Information\n-We may collect information about the device you are using, including device type, operating system, and app performance data to improve user experience.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'How We Use Your Information',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We use the information we collect for the following purposes:\n-To Provide Services: Use your location to suggest relevant routes and transportation options.\n-To Personalize User Experience: Display personalized content based on your preferences and interactions.\n-To Communicate with You: Send updates, and notifications, or respond to your inquiries.\n-To Improve the App: Analyze usage data and feedback to enhance the functionality and user experience of the App.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Sharing Your Information',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We do not sell your data. However, we may share information in the following situations:\n-Publicly Shared Content: Comments and recommendations you post, along with your username, will be visible to all users.\n-With Service Providers: We may share your data with third-party service providers who assist in operating the App under strict confidentiality agreements.\n-As Required by Law: If legally required, we may disclose your information to comply with legal processes or to protect the rights, property, and safety of Lakbay Cavite and its users.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Your Choices',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'You have control over your information and can exercise the following rights:\n-Account Settings: You can update your personal information or delete your account through the settings menu.\n-Location Sharing: You can enable or disable location services at any time in your device’s settings.\n-Deleting Data: You may request the deletion of your data by contacting us at lakbaycavite@gmail.com.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Data Security',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no security measures are entirely foolproof, and we cannot guarantee the absolute security of your data.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Data Retention',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We will retain your data for as long as your account is active or as necessary to provide you with services. We may also retain data to comply with legal obligations, resolve disputes, or enforce agreements.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Children’s Privacy',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Lakbay Cavite is not intended for children under the age of 16. We do not knowingly collect personal information from children. If we become aware that we have inadvertently collected data from a child, we will take steps to delete such information.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Changes to this Policy',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We may update this Privacy Policy from time to time. Any changes will be communicated to you through the App or by other means. Continued use of the App following any modifications signifies your acceptance of the updated terms.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Contact Us',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'If you have any questions or concerns about this Privacy Policy or your data, please contact us at:\nEmail: lakbaycavite@gmail.com\nPhone: 09661834946',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(fontFamily: 'Poppins')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Terms and Conditions',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 10),
                Text(
                  'Acceptance of Terms',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'By using Lakbay Cavite, you agree to comply with these terms and conditions.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'User Responsibility',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Users must exercise caution while using the app. Please don\'t rely solely on the navigation application, and always stay aware of your surroundings. Lakbay Cavite is a tool for guidance and not a replacement for real-time navigation tools or human judgment.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Comments and Recommendations',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Users can post comments recommending routes and transportation options. By posting, you agree that your username will be publicly displayed alongside your comments.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'User Conduct',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Comments must be respectful and relevant. Any offensive or inappropriate content may lead to filtering or removal and potential account suspension.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Liability Disclaimer',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Lakbay Cavite is not responsible for any consequences arising from the use of suggested routes or user information.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Modifications',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'We reserve the right to modify these terms at any time. Continued use of the application signifies acceptance of any changes.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Governing Law',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'These terms shall be governed by the laws of Imus, Cavite.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'For more information, please contact us at @09661834946 @lakbaycavite.gmail',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'By using this application, you confirm your understanding and acceptance of these terms.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(fontFamily: 'Poppins')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF035594),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/lakbaylogo.png',
                height: 70,
              ),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _emailError,
                            labelStyle: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              _emailError = _validateEmail(value);
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: _sendVerificationCode,
                          child: Text('Send Verification Code'),
                        ),
                        if (isCodeSent)
                          TextFormField(
                            controller: codeController,
                            decoration: InputDecoration(
                              labelText: 'Enter Verification Code',
                              errorText: _verificationCodeError,
                              prefixIcon: Icon(Icons.code),
                            ),
                          ),
                        if (isCodeSent)
                          ElevatedButton(
                            onPressed: _verifyCode,
                            child: Text('Verify Code'),
                          ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            errorText: _usernameError,
                            labelStyle: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                            prefixIcon: const Icon(Icons.verified_user),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _usernameError = _validateUsername(value);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText: _passwordError,
                            labelStyle: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _passwordError = _validatePassword(value);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: repeatPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Repeat Password',
                            errorText: _repeatPasswordError,
                            labelStyle: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              _repeatPasswordError = _validateRepeatPassword(value);
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // Add RichText for clickable terms and privacy policy
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                            children: [
                              const TextSpan(text: 'By clicking register, you agree to our '),
                              TextSpan(
                                text: 'Terms',
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _showTermsDialog();
                                  },
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _showPrivacyPolicyDialog();
                                  },
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _handleRegister,
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
