import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheshh/pages/buttons/terminal_provider.dart';
import 'package:sheshh/pages/home_screen.dart';
import 'package:sheshh/pages/login.dart';
import 'package:sheshh/pages/register.dart';
import 'package:sheshh/pages/settings_screen.dart';
import 'package:sheshh/pages/logout_sample.dart';
import 'package:sheshh/AuthProvider.dart';
import 'package:sheshh/pages/update.dart'; // Import your AuthProvider
import 'package:sheshh/pages/homepage_clone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheshh/pages/buttons/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Import for token storage

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TerminalProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),// Provide AuthProvider to the widget tree
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Home Page Example',

      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const HomepageClone(), // Unrestricted page
      routes: {
        '/login': (context) => LoginPage(),
        '/homepage': (context) => HomePageWithAuth(), // Protected page
        '/register': (context) => const RegisterPage(),
        '/settings': (context) => const SettingsPage(),
        '/logout': (context) => const LogoutSamplePage(),
        '/update_profile': (context) => UpdateProfileWithAuth(), // Protected page
      },
    );
  }
}

// Middleware logic for protected routes

class HomePageWithAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(), // Function to get stored token
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading until token is fetched
        } else if (snapshot.data != null) {
          final token=snapshot.data!;
          return HomePage(userKey: token); // If token exists, navigate to HomePage
        } else {
          return LoginPage(); // If no token, navigate to login
        }
      },
    );
  }
}

class UpdateProfileWithAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(), // Function to get stored token
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.data != null) {
          final token = snapshot.data!;
          return UpdateProfileScreen(userKey: token); // Pass token to UpdateProfileScreen
        } else {
          return LoginPage(); // Redirect to login if token is missing
        }
      },
    );
  }
}

// Helper function to get the token from SharedPreferences
Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token'); // Retrieve the stored token
}